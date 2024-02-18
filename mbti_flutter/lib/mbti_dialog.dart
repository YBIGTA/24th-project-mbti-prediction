import 'package:flutter/material.dart';
import './intj_dialog.dart';

class MBTIDialog extends StatelessWidget {
  const MBTIDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('대화하고 싶은 MBTI를 선택하세요'),
      ),
      body: Container(
        // Container로 감싸서 배경색을 설정합니다.
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const MBTIButton(title: 'ISTJ'),
                  const MBTIButton(title: 'ISFJ'),
                  const MBTIButton(title: 'INFJ'),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.shade200,
                      fixedSize: const Size(100, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const INTJBot(),
                        ),
                      );
                    },
                    child: const Text(
                      "INTJ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MBTIButton(title: 'ISTP'),
                  MBTIButton(title: 'ISFP'),
                  MBTIButton(title: 'INFP'),
                  MBTIButton(title: 'INTP'),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MBTIButton(title: 'ESTP'),
                  MBTIButton(title: 'ESFP'),
                  MBTIButton(title: 'ENFP'),
                  MBTIButton(title: 'ENTP'),
                ],
              ),
              const Row(
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

  const MBTIButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange.shade200,
        fixedSize: const Size(100, 100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        // 여기서 선택된 MBTI를 이용하여 원하는 작업을 수행할 수 있습니다.
        Navigator.pop(context);
      },
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
