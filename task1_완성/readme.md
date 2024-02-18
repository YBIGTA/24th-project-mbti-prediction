## 구조
```
task1_완성  
├── code
│   ├── ???.json                     - firebase에서 할당받은 개인 json 파일 필요 (참고: https://tre2man.tistory.com/196)
│   ├── save_bert.py                 - **첫번째 실행** 시간 단축용, 필요한 모델 미리 저장하기 
│   └── real_main.py                 - **두번째 실행** firebase real-time db에 저장된 답변을 바탕으로 예측된 mbti 결과 db에 다시 저장
│  
└── model                          
    └── best_model.pth               - pretrained model, 용량이 커서 안올립니다.
```

