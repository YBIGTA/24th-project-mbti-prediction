import argparse
import torch
import nltk
from preprocessing import DataPreprocessor
from encode import Encode
from train import Train
from torch.utils.data import DataLoader, RandomSampler, TensorDataset, SequentialSampler
from transformers import BertTokenizer, BertForSequenceClassification
from sklearn.model_selection import train_test_split
import re
from nltk.stem import WordNetLemmatizer
from nltk.corpus import stopwords
import utility
from transformers import MBartForConditionalGeneration, MBart50TokenizerFast

def parse_args():
    # 실험 조건을 argument로 받음
    parser = argparse.ArgumentParser()
    parser.add_argument('-e', '--epoch', type=int, default=1, help='the number of train epochs')
    parser.add_argument('-b', '--batch', type=int, default=32, help='batch size')
    parser.add_argument('-lr', '--learning_rate', type=float, default=2e-5, help='learning rate')
    parser.add_argument('-rd', '--reduced_data', action='store_true', help='Use reduced data')
    parser.add_argument('-qn', '--ques_num', type=int, default=3, help='The number of Questions.')
    return parser.parse_args()

def create_data_loaders(input_ids, attention_masks, labels, batch_size, random_state=2018, test_size=0.2):
    # 데이터셋 분리
    train_inputs, temp_inputs, train_labels, temp_labels = train_test_split(input_ids, labels, random_state=random_state, test_size=test_size)
    validation_inputs, test_inputs, validation_labels, test_labels = train_test_split(temp_inputs, temp_labels, random_state=random_state, test_size=0.5)

    # 마스크 분리
    train_masks, temp_masks, _, _ = train_test_split(attention_masks, labels, random_state=random_state, test_size=test_size)
    validation_masks, test_masks, _, _ = train_test_split(temp_masks, temp_labels, random_state=random_state, test_size=0.5)

    # 데이터셋 생성
    train_dataset = TensorDataset(train_inputs, train_masks, train_labels)
    validation_dataset = TensorDataset(validation_inputs, validation_masks, validation_labels)
    test_dataset = TensorDataset(test_inputs, test_masks, test_labels)

    # 데이터 로더 생성
    train_dataloader = DataLoader(train_dataset, sampler=RandomSampler(train_dataset), batch_size=batch_size)
    validation_dataloader = DataLoader(validation_dataset, sampler=SequentialSampler(validation_dataset), batch_size=batch_size)
    test_dataloader = DataLoader(test_dataset, sampler=SequentialSampler(test_dataset), batch_size=batch_size)
    
    return train_dataloader, validation_dataloader, test_dataloader

def preprocess_text(text):
    text = re.sub(r'[^\w\s]', '', text)
    
    words = text.split()

    lemmatizer = WordNetLemmatizer()
    stop_words = set(stopwords.words('english'))
    cleaned_text = [lemmatizer.lemmatize(word.lower()) for word in words if word.lower() not in stop_words]

    return ' '.join(cleaned_text)


if __name__ == '__main__':
    args = parse_args()

    # 데이터 전처리 실행 
    if args.reduced_data:
        preprocessor = DataPreprocessor('../dataset/reduced_data.csv')
    else:
        preprocessor = DataPreprocessor('../dataset/MBTI_500.csv')
    preprocessor.preprocess()
    preprocessor.resample()
    encode = Encode()
    input_ids, attention_masks = encode.bert_encode(max_len=64)
    labels = torch.tensor(preprocessor.data['encoded_labels'].values)

    # 데이터 로더 생성
    train_dataloader, validation_dataloader, test_dataloader = create_data_loaders(input_ids, attention_masks, labels, args.batch)
    
    # 모델 학습 및 평가
    train = Train(train_dataloader, validation_dataloader, test_dataloader, preprocessor.label_encoder, args)
    train.train()
    train.run_test()

    # 예측 -----------------------
    nltk.download('wordnet')
    nltk.download('stopwords')

    # 1. 사용자 답변 번역
    ques_num = args.ques_num
    questions = utility.make_question(ques_num)
    qn = 0
    answer = '' # save user's answer
    answers = ''

    while qn < len(questions):
        answer = input(f'{questions[qn]}: ')
        answers += answer
        qn += 1
    
    model_translate = MBartForConditionalGeneration.from_pretrained('mbart_model')
    tokenizer_translate = MBart50TokenizerFast.from_pretrained('mbart_tokenizer')
    tokenizer_translate.src_lang = 'ko_KR'
    encoded_hi = tokenizer_translate(answers, return_tensors='pt')
    generated_tokens = model_translate.generate(
        **encoded_hi,
        forced_bos_token_id=tokenizer_translate.lang_code_to_id['en_XX']
    )
    translated_input = tokenizer_translate.batch_decode(generated_tokens, skip_special_tokens=True)[0] # save translated text.

    cleaned_text = utility.preprocess_text(translated_input)

    # 2. 모델 예측
    tokenizer = BertTokenizer.from_pretrained('bert_tokenizer')
    model = BertForSequenceClassification.from_pretrained('bert_model')
    model.load_state_dict(torch.load('../model/best_model.pth'))
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model.to(device)
    model.eval()

    encoded_input = tokenizer.encode_plus(
        cleaned_text,
        add_special_tokens=True,
        max_length=64,
        padding='max_length',
        return_attention_mask=True,
        truncation=True,
        return_tensors='pt'
    )
    input_ids = encoded_input['input_ids'].to(device)
    attention_mask = encoded_input['attention_mask'].to(device)

    with torch.no_grad():
        outputs = model(input_ids, attention_mask=attention_mask)
        logits = outputs.logits

    predicted_label_idx = torch.argmax(logits, dim=1).cpu().numpy()[0]
    predicted_label = utility.idx_to_mbti(predicted_label_idx)
    pred_type_demo = utility.print_demo(predicted_label)
    print(f'''당신의 MBTI는 {predicted_label}이고, 이 MBTI의 {pred_type_demo}''')
