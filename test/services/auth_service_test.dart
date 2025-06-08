import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:product_list_app/core/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import '../test_helper.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseAuth>(),
  MockSpec<GoogleSignIn>(),
  MockSpec<UserCredential>(),
  MockSpec<User>(),
  MockSpec<GoogleSignInAccount>(),
  MockSpec<GoogleSignInAuthentication>()
])
import 'auth_service_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late AuthService authService;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;

  setUpAll(() async {
    await TestHelper.setupFirebaseForTesting();
  });

  tearDownAll(() async {
    await TestHelper.tearDownFirebaseForTesting();
  });

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    
    authService = AuthService(auth: mockFirebaseAuth, googleSignIn: mockGoogleSignIn);
  });

  group('AuthService', () {
    test('signInWithEmailAndPassword returns UserCredential on success', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@test.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);

      final result = await authService.signInWithEmailAndPassword('test@test.com', 'password123');

      expect(result, equals(mockUserCredential));
    });

    test('signInWithGoogle returns User on success', () async {
      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(mockGoogleSignInAuthentication.accessToken)
          .thenReturn('fake-access-token');
      when(mockGoogleSignInAuthentication.idToken)
          .thenReturn('fake-id-token');
      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);

      final result = await authService.signInWithGoogle();

      expect(result, equals(mockUser));
    });

    test('signInWithGoogle returns null when google sign in is cancelled', () async {
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      final result = await authService.signInWithGoogle();

      expect(result, isNull);
    });

    test('signOut signs out from both Firebase and Google', () async {
      when(mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      await authService.signOut();

      verify(mockGoogleSignIn.signOut()).called(1);
      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });
}
