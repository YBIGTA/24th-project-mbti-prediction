from concurrent.futures import ProcessPoolExecutor
from transformers import BertTokenizerFast
import torch
from tqdm.notebook import tqdm
import pandas as pd

class Encode:
    def __init__(self):
        self.data = pd.read_csv('../dataset/upsampled_data.csv')

    def encode_text(self, sent, tokenizer, max_len): 
        encoded = tokenizer.encode_plus( 
            sent, # Sentence to encode
            add_special_tokens=True, # Add '[CLS]' and '[SEP]'
            max_length=max_len, # Pad & truncate all sentences.
            padding='max_length', 
            return_attention_mask=True, # Construct attention masks.
            truncation=True # Truncate representations to max_length
        )
        return encoded['input_ids'], encoded['attention_mask'] 
    
    def bert_encode(self, max_len:int): # BERT 모델을 이용해 토큰화
        tokenizer = BertTokenizerFast.from_pretrained('bert-base-uncased') 
        input_ids = [] 
        attention_masks = []

        with ProcessPoolExecutor() as executor: 
            results = list(tqdm(executor.map(self.encode_text, 
                                             self.data['filtered_posts'], 
                                             [tokenizer]*len(self.data),
                                             [max_len]*len(self.data)), 
                                             total=len(self.data), 
                                             desc="Encoding")
                                             )

        for ids, masks in results: 
            input_ids.append(ids)
            attention_masks.append(masks)

        input_ids = torch.tensor(input_ids)
        attention_masks = torch.tensor(attention_masks)

        return input_ids, attention_masks