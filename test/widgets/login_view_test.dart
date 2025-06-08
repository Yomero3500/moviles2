import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:product_list_app/features/auth/screens/login_view.dart';
import 'package:product_list_app/core/services/auth_service.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class MockAuthService extends Mock implements AuthService {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthService mockAuthService;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockAuthService = MockAuthService();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  Widget createLoginView() {
    return MaterialApp(
      home: LoginView(),
      navigatorObservers: [mockNavigatorObserver],
    );
  }

  testWidgets('renders login form elements', (WidgetTester tester) async {
    await tester.pumpWidget(createLoginView());

    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsNWidgets(2));
    expect(find.text('Crear una cuenta'), findsOneWidget);
    expect(find.text('Iniciar sesión con Google'), findsOneWidget);
  });

  testWidgets('shows error on empty form submission',
      (WidgetTester tester) async {
    await tester.pumpWidget(createLoginView());

    await tester.tap(find.text('Ingresar'));
    await tester.pump();

    expect(find.text('Ingrese email'), findsOneWidget);
    expect(find.text('Ingrese contraseña'), findsOneWidget);
  });

  testWidgets('shows loading indicator during authentication',
      (WidgetTester tester) async {
    final mockUserCredential = MockUserCredential();
    final mockUser = MockUser();
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockAuthService.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) async => mockUserCredential);

    await tester.pumpWidget(createLoginView());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'test@test.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Contraseña'), 'password123');

    await tester.tap(find.text('Ingresar'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('navigates to home on successful login',
      (WidgetTester tester) async {
    final mockUserCredential = MockUserCredential();
    final mockUser = MockUser();
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockAuthService.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) async => mockUserCredential);

    await tester.pumpWidget(createLoginView());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'test@test.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Contraseña'), 'password123');

    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();

    verify(mockNavigatorObserver.didPush(any, any));
  });

  testWidgets('shows error message on login failure',
      (WidgetTester tester) async {
    when(mockAuthService.signInWithEmailAndPassword(any, any))
        .thenThrow(Exception('Login failed'));

    await tester.pumpWidget(createLoginView());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'test@test.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Contraseña'), 'password123');

    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Error al iniciar sesión: Exception: Login failed'),
        findsOneWidget);
  });

  testWidgets('toggles password visibility', (WidgetTester tester) async {
    await tester.pumpWidget(createLoginView());

    final passwordField = find.widgetWithText(TextFormField, 'Contraseña');
    expect(
        tester.widget<TextFormField>(passwordField).obscureText, equals(true));

    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();

    expect(
        tester.widget<TextFormField>(passwordField).obscureText, equals(false));
  });

  testWidgets('navigates to register screen', (WidgetTester tester) async {
    await tester.pumpWidget(createLoginView());

    await tester.tap(find.text('Crear una cuenta'));
    await tester.pumpAndSettle();

    verify(mockNavigatorObserver.didPush(any, any));
  });
}
