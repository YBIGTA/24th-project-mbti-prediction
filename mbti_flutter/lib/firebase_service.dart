import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAZwYA9LCCtr-r7lZQ8iLJyroWATupiiT4',
        authDomain: 'ybigta-newbiepj-mbti.firebaseapp.com',
        projectId: 'ybigta-newbiepj-mbti',
        databaseURL:
            'https://ybigta-newbiepj-mbti-default-rtdb.firebaseio.com/',
        storageBucket: 'ybigta-newbiepj-mbti.appspot.com',
        messagingSenderId: '1083913322405',
        appId: '1:1083913322405:web:2c7711ec4949c8dd34324c',
      ),
    );
  }
}
