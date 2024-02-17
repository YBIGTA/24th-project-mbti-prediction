## 구조
```
task1  
├── code  
│   ├── 0212_make_small_dataset.py   - 데이터 셋 줄여서 학습할 때 필요  
│   ├── main.py                      - 전체 과정(학습, 평가, 예측), 두번째 실행
│   ├── encode.py                    - encode하는 부분  
│   ├── preprocessing.py             - 전처리 및 unsampling  
│   ├── train.py                     - train & evaluate  
│   ├── utility.py                   - 승준님 코드 참고, 첫번째 실행
│   └── real_main.py                 - **최종적으로 실행할 부분** firebase에서 할당받은 json 파일 필요, firebase real-time db에 질문/답변 저장 가능
│  
└── dataset                          - this folder contains any dataset of our project.  
    ├── reduced_data.csv             - MBTI_500 small version  
    └── MBTI_500.csv                 - original dataset
```
- MBTI_500.csv는 용량이 커서 안올립니다. (각자 해당 폴더에 넣어서 실행)

## 실행

- 올려주신 코드 참고하여 **utility.py를 먼저 수행**하고 하는 것이 좋을 듯 합니다.

1. main.py를 수행할 때
- 다음, 아래의 내용 입력
    ```
    python .\main.py -e ?? -b ?? -lr ?? -rd -qn ??
    ```
- epoch, batch, learning_rate, reduced_data, question_num
- -rd를 입력하지 않으면 MBTI_500 실행, -rd를 입력하면 reduced_data 실행
- 나머지는 입력하지 않을 시 default 값으로 수행

2. real_main.py를 수행할 때
- 그냥 실행하면 됩니다.
- 학습된 모델을 바탕으로 mbti를 실제로 예측하는 task 수행
- 수집된 Q/A 데이터는 firebase real-time db에 유저별로 저장된다.
