import 'package:firebase_core/firebase_core.dart';

Future<void> initializeFirebase() async {
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: 'your-api-key',
      appId: 'your-app-id',
      messagingSenderId: 'your-messaging-sender-id',
      projectId: 'your-project-id',
    );
  }
}