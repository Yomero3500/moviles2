import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:product_list_app/features/auth/screens/register_view.dart';
import 'package:product_list_app/core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockAuthService extends Mock implements AuthService {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  Widget createRegisterView() {
    return MaterialApp(
      home: RegisterView(),
    );
  }

  testWidgets('renders registration form elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(createRegisterView());

    expect(find.text('Registro'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2)); // Email and password fields
    expect(find.byType(ElevatedButton), findsOneWidget); // Register button
  });

  testWidgets('shows error on empty form submission',
      (WidgetTester tester) async {
    await tester.pumpWidget(createRegisterView());

    await tester.tap(find.text('Registrar'));
    await tester.pump();

    expect(find.text('Ingrese email'), findsOneWidget);
    expect(find.text('Ingrese contraseña'), findsOneWidget);
  });

  testWidgets('shows loading indicator during registration',
      (WidgetTester tester) async {
    final mockUserCredential = MockUserCredential();
    final mockUser = MockUser();
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockAuthService.registerWithEmail(any, any))
        .thenAnswer((_) async => mockUser);

    await tester.pumpWidget(createRegisterView());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'test@test.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Contraseña'), 'password123');

    await tester.tap(find.text('Registrar'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows success message and navigates back on successful registration',
      (WidgetTester tester) async {
    final mockUser = MockUser();
    when(mockAuthService.registerWithEmail(any, any))
        .thenAnswer((_) async => mockUser);

    await tester.pumpWidget(createRegisterView());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'test@test.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Contraseña'), 'password123');

    await tester.tap(find.text('Registrar'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Usuario registrado exitosamente'), findsOneWidget);
  });

  testWidgets('shows error message on registration failure',
      (WidgetTester tester) async {
    when(mockAuthService.registerWithEmail(any, any))
        .thenThrow(Exception('Registration failed'));

    await tester.pumpWidget(createRegisterView());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'), 'test@test.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Contraseña'), 'password123');

    await tester.tap(find.text('Registrar'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Error al registrar: Exception: Registration failed'),
        findsOneWidget);
  });
  testWidgets('toggles password visibility', (WidgetTester tester) async {
    await tester.pumpWidget(createRegisterView());

    final passwordField = find.widgetWithText(TextFormField, 'Contraseña');
    final textFormField = tester.widget<TextFormField>(passwordField);
    expect(textFormField.obscureText, equals(true));

    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();

    final updatedTextField = tester.widget<TextFormField>(passwordField);
    expect(updatedTextField.obscureText, equals(false));
  });
}
