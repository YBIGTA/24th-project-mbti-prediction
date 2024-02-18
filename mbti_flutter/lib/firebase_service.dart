import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: '',
        authDomain: '',
        projectId: '',
        databaseURL: '',
        storageBucket: '',
        messagingSenderId: '',
        appId: '',
      ),
    );
  }
}
