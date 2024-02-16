import 'package:flutter/material.dart';

class MBTIClassifier extends StatelessWidget {
  const MBTIClassifier({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: const Text("당신의 MBTI를 맞춰볼게요..."),
      ),
      body: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  List<Widget> messages = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length + 1,
      itemBuilder: (context, index) {
        if (index == messages.length) {
          return Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: BubbleMe(
                text: '????',
                textController: _textController,
                onSendMessage: (message) {
                  setState(() {
                    messages.add(
                      BubbleMe(
                        text: message,
                        textController: _textController,
                        onSendMessage: (message) {},
                      ),
                    );
                    messages.add(const BubbleYou());
                    _textController.clear;
                  });
                },
              ),
            ),
          );
        } else {
          return messages[index];
        }
      },
    );
  }
}
class BubbleMe extends StatelessWidget {
  final TextEditingController textController;
  final Function(String) onSendMessage;
  final String text;

  const BubbleMe({
    Key? key,
    required this.textController,
    required this.onSendMessage,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center( // 컨테이너를 수평, 수직 가운데로 정렬
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8), // 상하 여백 추가
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        width: MediaQuery.of(context).size.width * 0.8, // 화면 폭의 80%를 사용
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: InputBorder.none,
                alignLabelWithHint: true, // 힌트 텍스트를 가운데로 정렬
              ),
            ),
            SizedBox(height: 10), // 추가적인 여백
            ElevatedButton(
              onPressed: () {
                onSendMessage(textController.text);
                textController.clear(); // 입력 후 텍스트 필드를 지움
              },
              child: const Text('전송'),
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleYou extends StatelessWidget {
  const BubbleYou({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8), // 상하 여백 추가
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green, // 색상 변경
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      width: MediaQuery.of(context).size.width * 0.8, // 화면 폭의 80%를 사용
      child: const Text(
        "새로운 정보를 받았을 때, 이를 어떻게 처리하는지 설명해 주실 수 있나요?",
        style: TextStyle(fontSize: 20), 
      ),
    );
  }
}
