import 'package:flutter/material.dart';

class MBTIClassifier extends StatelessWidget {
  const MBTIClassifier({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: const Text("나의 MBTI를 예측해보자!"),
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
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Type your mesage...',
              border: InputBorder.none,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onSendMessage(textController.text);
              textController.clear(); // 입력 후 텍스트 필드를 지움
            },
            child: const Text('전송'),
          ),
        ],
      ),
    );
  }
}

class BubbleYou extends StatelessWidget {
  const BubbleYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.2)),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      width: 250,
      child: const Text(
        "새로운 정보를 받았을 때, 이를 어떻게 처리하는지 설명해 주실 수 있나요?",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
