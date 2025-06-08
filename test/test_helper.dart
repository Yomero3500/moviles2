import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestHelper {
  static Future<void> setupFirebaseForTesting() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  static Future<void> tearDownFirebaseForTesting() async {
    await Firebase.instance.delete();
  }
}
