# MBTI 추천 모델 & 유형별 대화

## Process Record
- https://www.notion.so/YBIGTA-MBTI-b4bccc4df4704ca59c29bcfad937d477

<br>

# Task 1

## Goal
- 랜덤하게 선별한 질문을 바탕으로 사용자의 답변을 받기 (multi-turn)
- 답변들을 바탕으로 사용자의 MBTI 예측

## Dataset
- https://www.kaggle.com/datasets/zeyadkhalid/mbti-personality-types-500-dataset/data
![image](https://github.com/chaehyun1/study/assets/108905986/c04df444-da62-416f-91ab-8703d32c819a)
![image](https://github.com/chaehyun1/study/assets/108905986/2786bf3c-9be2-4c38-941e-efa15e01728e)

## Modeling
![image](https://github.com/chaehyun1/study/assets/108905986/72e4bd77-145a-4d3c-8b05-8755ed71afae)

## Frontend & Backend
![image](https://github.com/chaehyun1/study/assets/108905986/fa958668-8ec6-4b2f-8857-368f3343197a)
![image](https://github.com/chaehyun1/study/assets/108905986/55064238-4e41-4860-96a9-da17ffe62a54)

<br>

# Task2

## Goal
- 내가 대화하고 싶은 상대방의 MBTI를 입력하고 이에 맞는 답변을 출력하는 챗봇을 만들어보자.

## Dataset
- OpenAI API를 사용한 특정 MBTI Q&A 데이터셋 생성

```
model = "gpt-3.5-turbo"

query =  "You are a close friend who's MBTI is ENFP.You produce two sets of questions and answers, Both questions and answers must be in Korean, reflecting deep insight and thoughtful analysis inherent to ENFP personalities."

input =  "일상생활, 학교생활, 성격, 가치관, 취미, 시사, 스포츠, 상식, 인간관계 등과 관련된 여러 가지 주제로, 내가 질문하고 MBTI가 ENFP인 친구가 대답하는 대화의 예시를 생성해주세요. 반드시 한국어로 생성해야 합니다."
```
![image](https://github.com/chaehyun1/study/assets/108905986/ab60ebbd-ba4f-4273-838d-ce9915024513)

## Modeling
![image](https://github.com/chaehyun1/study/assets/108905986/440d02d2-0355-4cb7-bd09-744373ea8c8f)
- Davidkim205의 komt-llama2-7b-v1모델
- https://huggingface.co/ToBeWithYou/MBTI_ENFP
- https://huggingface.co/ToBeWithYou/MBTI_ENTP
- https://huggingface.co/ToBeWithYou/MBTI_ISFJ
  
- https://huggingface.co/ToBeWithYou/MBTI_ESFP
- https://huggingface.co/ToBeWithYou/MBTI_INTJ
## Frontend & Backend
