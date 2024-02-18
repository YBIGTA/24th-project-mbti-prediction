import random 
import re
from nltk.stem import WordNetLemmatizer
from nltk.corpus import stopwords
from transformers import MBartForConditionalGeneration, MBart50TokenizerFast, BertTokenizer, BertForSequenceClassification

if __name__ == '__main__':
    # Save BERT for translation and for predict MBTI to reduce main.py's running time.
    mbart_model = MBartForConditionalGeneration.from_pretrained("facebook/mbart-large-50-many-to-many-mmt")
    mbart_tokenizer = MBart50TokenizerFast.from_pretrained("facebook/mbart-large-50-many-to-many-mmt")
    bert_tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')
    bert_model = BertForSequenceClassification.from_pretrained('bert-base-uncased', num_labels=16)

    mbart_model.save_pretrained("mbart_model")
    mbart_tokenizer.save_pretrained("mbart_tokenizer")
    bert_tokenizer.save_pretrained("bert_tokenizer")
    bert_model.save_pretrained("bert_model")