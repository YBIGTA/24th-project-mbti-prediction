import 'package:flutter/material.dart';
import 'firebase_service.dart';
import 'mbti_classification.dart';
import 'mbti_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Test",
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 180),
                  const Text(
                    'YBIGTA 신입기수 프로젝트',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Text(
                    'TBDTBDTBD',
                    style: TextStyle(fontSize: 40),
                  ),
                  const Text(
                    '😎😎',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.94, 90),
                      maximumSize:
                          Size(MediaQuery.of(context).size.width * 0.94, 90),
                    ),
                    child: const Text(
                      '당신의 MBTI를 맞춰볼게요!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MBTIClassifier(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.94, 90),
                      maximumSize:
                          Size(MediaQuery.of(context).size.width * 0.94, 90),
                    ),
                    child: const Text(
                      '특정 MBTI와 대화해보세요!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MBTIDialog(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    '24기 김채현, 김예진, 김무현, 김종진, 이승준',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
