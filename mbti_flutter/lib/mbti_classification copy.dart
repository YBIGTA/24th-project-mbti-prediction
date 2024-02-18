// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class MBTIClassifier extends StatelessWidget {
  const MBTIClassifier({super.key});

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
  List<String> answerList = [];
  int conversationCount = 0;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String formattedDate = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

  void uploadData() async {
    DatabaseReference reference = FirebaseDatabase.instance.ref();
    await reference
        .child('task1')
        // .child(ServerValue.timestamp.toString())
        .child('UserAnswer')
        .child(formattedDate)
        .set(answerList);
    debugPrint('Data uploaded successfully');
  }

  Future<void> _loadRandomCommonQ() async {
    DatabaseEvent databaseEvent = await _databaseReference
        .child('task1')
        .child('QuestionList')
        .child('commonQ')
        .once();

    List<dynamic> commonQuestions =
        (databaseEvent.snapshot.value as List<dynamic>);

    Random random = Random();
    int randomIndex = random.nextInt(commonQuestions.length);
    String commonQuestion = commonQuestions[randomIndex];

    setState(() {
      messages.add(BubbleYou(answer: commonQuestion));
    });
  }

  Future<void> _loadRandomEIQ() async {
    DatabaseEvent databaseEvent = await _databaseReference
        .child('task1')
        .child('QuestionList')
        .child('EandIQ')
        .once();

    List<dynamic> questions = (databaseEvent.snapshot.value as List<dynamic>);

    Random random = Random();
    int randomIndex = random.nextInt(questions.length);
    String question = questions[randomIndex];

    setState(() {
      messages.add(BubbleYou(answer: question));
    });
  }

  Future<void> _loadRandomSNQ() async {
    DatabaseEvent databaseEvent = await _databaseReference
        .child('task1')
        .child('QuestionList')
        .child('SandNQ')
        .once();

    List<dynamic> questions = (databaseEvent.snapshot.value as List<dynamic>);

    Random random = Random();
    int randomIndex = random.nextInt(questions.length);
    String question = questions[randomIndex];

    setState(() {
      messages.add(BubbleYou(answer: question));
    });
  }

  Future<void> _loadRandomTFQ() async {
    DatabaseEvent databaseEvent = await _databaseReference
        .child('task1')
        .child('QuestionList')
        .child('TandFQ')
        .once();

    List<dynamic> questions = (databaseEvent.snapshot.value as List<dynamic>);

    Random random = Random();
    int randomIndex = random.nextInt(questions.length);
    String question = questions[randomIndex];

    setState(() {
      messages.add(BubbleYou(answer: question));
    });
  }

  Future<void> _loadRandomJPQ() async {
    DatabaseEvent databaseEvent = await _databaseReference
        .child('task1')
        .child('QuestionList')
        .child('JandPQ')
        .once();

    List<dynamic> questions = (databaseEvent.snapshot.value as List<dynamic>);

    Random random = Random();
    int randomIndex = random.nextInt(questions.length);
    String question = questions[randomIndex];

    setState(() {
      messages.add(BubbleYou(answer: question));
    });
  }

  Future<String> _loadMBTI() async {
    DatabaseEvent databaseEvent = await _databaseReference
        .child('task1')
        .child('UserAnswer')
        .child(formattedDate)
        .child('mbti')
        .once();

    List<dynamic> finalMBTI = (databaseEvent.snapshot.value as List<dynamic>);

    String mbti = finalMBTI[0];

    return mbti;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      _loadRandomCommonQ();
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
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(80, 50),
                  maximumSize: const Size(80, 50),
                ),
                onPressed: () {
                  String userMessage = _textController.text;
                  answerList.add(userMessage);
                  // _textController.clear();
                  setState(() {
                    messages.add(
                      BubbleMe(
                        answer: userMessage,
                      ),
                    );

                    conversationCount++;

                    if (conversationCount == 1) {
                      _loadRandomEIQ();
                    } else if (conversationCount == 2) {
                      _loadRandomSNQ();
                    } else if (conversationCount == 3) {
                      _loadRandomTFQ();
                    } else if (conversationCount == 4) {
                      _loadRandomJPQ();
                    } else {
                      debugPrint(answerList.toString());
                      uploadData();
                      // 여기서 업로드.
                      messages.add(
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue.shade300,
                              ),
                              onPressed: () {},
                              child: const Text(
                                '분석하기',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );

                      messages.add(
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              const SizedBox(height: 80),
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red.withOpacity(0.1),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 80,
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        '당신의 MBTI는..',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        '$_loadMBTI인 것 같습니다.',
                                        style: const TextStyle(fontSize: 30),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      );
                    }

                    _textController.clear();
                  });
                },
                child: const Text(
                  'Send',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
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
          color: Colors.blue,
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
        width: MediaQuery.of(context).size.width * 0.7,
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
        width: MediaQuery.of(context).size.width * 0.7,
        child: Text(
          answer.toString(),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
