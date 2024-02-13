import pandas as pd
from collections import defaultdict
import re
from typing import List
from nltk.stem import WordNetLemmatizer # 단어의 원형을 찾아줌
from nltk.corpus import stopwords # 불용어 제거
import nltk
from sklearn.preprocessing import LabelEncoder
from sklearn.utils import resample # 데이터 불균형 해소
from concurrent.futures import ProcessPoolExecutor
from transformers import BertTokenizer
import torch
from tqdm.notebook import tqdm

# data = pd.read_csv('F:/신입기수 프로젝트/24th-project-mbti-prediction/dataset/MBTI_500.csv')

class DataPreprocessor:
    def __init__(self, filename: str):
        self.data = pd.read_csv(filename)
        self.label_encoder = LabelEncoder() # mbti(범주형)를 숫자로 변환
        nltk.download('stopwords')
        self.stop_words = set(stopwords.words('english')) # 불용어 제거
        self.lemmatizer = WordNetLemmatizer() # 단어의 원형을 찾아줌
    
    def tokenize(self, text: str) -> List[str]: 
        text = re.sub(r'http\S+|[^a-zA-Z0-9\s]','',text) # url, non-alphanumeric characters 제거
        return text.lower().split()

    def filter_text_preserve_delimiter(self, text:str, filtered_words_set:dict) -> str: # 특정 유의미한 단어만 추출
        posts = text.split('|||') # posts를 |||로 나눔, 없으면 그대로 리스트 반환
        filtered_posts = [' '.join([word for word in self.tokenize(post) if word in filtered_words_set]) for post in posts]
        return '|||'.join(filtered_posts) 
    
    def clean_and_preprocess(self, text: str) -> str: # 불용어 제거, 단어의 원형 찾기
        text = re.sub(r'http\S+', '', text) 
        text = re.sub(r'[^\w\s]', '', text) 
        words = text.split()
        cleaned_text = []
        for word in words:
            if word.lower() not in self.stop_words:
                lemmatized_word = self.lemmatizer.lemmatize(word.lower()) 
                cleaned_text.append(lemmatized_word)

        return ' '.join(cleaned_text)
    
    def preprocess(self):
        word_cnt = defaultdict(int)
        for text in self.data['posts']:
            words = set(self.tokenize(text)) # 행마다 중복 단어 제거
            for word in words:
                word_cnt[word] += 1
        
        filtered_words = {word: count for word, count in word_cnt.items() if count >= 69} # 69번 이상 등장한 단어만 추출
        self.data['filtered_posts'] = self.data['posts'].apply(lambda x: self.filter_text_preserve_delimiter(x, set(filtered_words))) # 한 행씩 전달
        self.data['filtered_posts'] = self.data['filtered_posts'].str.replace('|||', '', regex=False)
        self.data['filtered_posts'] = self.data['filtered_posts'].apply(self.clean_and_preprocess)
        self.data = self.data[self.data['filtered_posts'].str.strip() != ''] 
        self.data['encoded_labels'] = self.label_encoder.fit_transform(self.data['type']) 
        X = self.data['filtered_posts'] 
        y = self.data['encoded_labels']

    def resample(self) -> pd.DataFrame:
        class_counts = self.data['encoded_labels'].value_counts()  
        max_class_count = class_counts.max()

        data_upsampled = pd.DataFrame()
        for class_index, count in class_counts.items():
            data_class = self.data[self.data['encoded_labels'] == class_index]
            data_class_upsampled = resample(data_class, 
                                            replace=True, 
                                            n_samples=max_class_count, 
                                            random_state=123)
            data_upsampled = pd.concat([data_upsampled, data_class_upsampled])

        self.data = data_upsampled.sample(frac=1).reset_index(drop=True)
        self.data.to_csv('../dataset/upsampled_data.csv', index=False)
    

    


