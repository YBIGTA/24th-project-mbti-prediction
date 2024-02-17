import 'package:flutter/material.dart';

class MBTIDialog extends StatelessWidget {
  const MBTIDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('대화하고 싶은 MBTI를 선택하세요'),
      ),
      body: Container( // Container로 감싸서 배경색을 설정합니다.
        color: Color(0xff00FFFF), // 배경색을 #00FFFF로 설정합니다.
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MBTIButton(title: 'ISTJ'),
            MBTIButton(title: 'ISFJ'),
            MBTIButton(title: 'INFJ'),
            MBTIButton(title: 'INTJ'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MBTIButton(title: 'ISTP'),
            MBTIButton(title: 'ISFP'),
            MBTIButton(title: 'INFP'),
            MBTIButton(title: 'INTP'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MBTIButton(title: 'ESTP'),
            MBTIButton(title: 'ESFP'),
            MBTIButton(title: 'ENFP'),
            MBTIButton(title: 'ENTP'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MBTIButton(title: 'ESTJ'),
            MBTIButton(title: 'ESFJ'),
            MBTIButton(title: 'ENFJ'),
            MBTIButton(title: 'ENTJ'),
          ],
        )
            ],
          ),
        ),
      ),
    );
  }
}

class MBTIButton extends StatelessWidget {
  final String title;

  const MBTIButton({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      onPressed: () {
        // 여기서 선택된 MBTI를 이용하여 원하는 작업을 수행할 수 있습니다.
        Navigator.pop(context);
      },
      child: Text(title),
    );
  }
}