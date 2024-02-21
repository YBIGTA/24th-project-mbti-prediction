import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class INTJBot extends StatelessWidget {
  const INTJBot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red.shade50,
        title: const Text("INTJ와 대화해보기!"),
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
  List<String> answerList = [];
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  bool isGetAnswerButtonVisible = true;
  // String formattedDate = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

  Future<String?> _loadAnswer(String id) async {
    DatabaseEvent databaseEvent = await _databaseReference
        .child('task2')
        .child('Answer')
        .child(id)
        .child('mbti')
        .once();

    if (databaseEvent.snapshot.value != null) {
      String answer = (databaseEvent.snapshot.value as String);
      if (answer.isNotEmpty) {
        String answerModified = answer.substring(0, answer.length - 4);
        return answerModified;
      }
    }
    return "$id null null 해요";
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      _firstMessage();
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: false,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return messages[index];
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                        hintText: 'Type your message...',
                        filled: true,
                        fillColor: Colors.red[50],
                        border: InputBorder.none),
                    maxLines: null,
                  ),
                ),
                isGetAnswerButtonVisible
                    ? TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1),
                          ),
                          fixedSize: const Size(80, 48),
                        ),
                        onPressed: () {
                          debugPrint('send');
                          String userMessage = _textController.text;
                          answerList.add(userMessage);
                          setState(
                            () {
                              messages.add(
                                BubbleMe(
                                  answer: userMessage,
                                ),
                              );
                              if (userMessage == "quit" ||
                                  userMessage == "나가기") {
                                Navigator.pop(context);
                              } else {
                                String id = uploadData(userMessage).toString();
                                messages.add(
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(30),
                                      child: TextButton(
                                        child: const Text('Get Answer',
                                            style:
                                                TextStyle(color: Colors.black)),
                                        onPressed: () async {
                                          debugPrint('get answer');
                                          String? intjAnswer =
                                              await _loadAnswer(id);

                                          if (intjAnswer != null) {
                                            messages.add(
                                              BubbleYou(
                                                answer: intjAnswer,
                                              ),
                                            );
                                          } else {
                                            messages.add(
                                              const BubbleYou(
                                                answer: 'Error',
                                              ),
                                            );
                                          }
                                          setState(() {
                                            // 이상하면 이거 편집
                                            isGetAnswerButtonVisible = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              }
                              _textController.clear();
                            },
                          );
                        },
                        child: const Text(
                          'send',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      )
                    : Container(),
              ],
            )),
      ],
    );
  }

  // 함수들
  Future<void> _firstMessage() async {
    setState(() {
      messages
          .add(const BubbleYou(answer: "Instruction:\nINTJ에게 아무 말이나 해보세요!"));
    });
  }

  Future<String> uploadData(String userMessage) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref();
    String formattedDate = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    await reference
        .child('task2')
        .child("questions")
        .child(formattedDate)
        .set(userMessage);

    return formattedDate;
  }

  // Future<void> _getMessage() async {}
}

class BubbleMe extends StatelessWidget {
  final String? answer;

  const BubbleMe({
    super.key,
    this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.redAccent.shade100,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        margin: const EdgeInsets.only(
          right: 10,
          bottom: 10,
          top: 10,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        // width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              answer ?? "",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleYou extends StatelessWidget {
  final String? answer;

  const BubbleYou({
    super.key,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black.withOpacity(0.2)),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        margin: const EdgeInsets.only(
          left: 10,
          bottom: 10,
          top: 10,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
          answer.toString(),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
