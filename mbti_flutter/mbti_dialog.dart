import 'package:flutter/material.dart';

class MBTIDialog extends StatelessWidget {
  const MBTIDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('대화하고 싶은 MBTI를 선택하세요'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MBTIButton(title: 'ISTJ'),
            MBTIButton(title: 'ISFJ'),
            MBTIButton(title: 'INFJ'),
            MBTIButton(title: 'INTJ'),
            MBTIButton(title: 'ISTP'),
            MBTIButton(title: 'ISFP'),
            MBTIButton(title: 'INFP'),
            MBTIButton(title: 'INTP'),
            MBTIButton(title: 'ESTP'),
            MBTIButton(title: 'ESFP'),
            MBTIButton(title: 'ENFP'),
            MBTIButton(title: 'ENTP'),
            MBTIButton(title: 'ESTJ'),
            MBTIButton(title: 'ESFJ'),
            MBTIButton(title: 'ENFJ'),
            MBTIButton(title: 'ENTJ'),
          ],
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
      onPressed: () {
        // 여기서 선택된 MBTI를 이용하여 원하는 작업을 수행할 수 있습니다.
        Navigator.pop(context);
      },
      child: Text(title),
    );
  }
}