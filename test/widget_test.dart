import 'package:flutter_test/flutter_test.dart';
import 'package:mkeparkapp_flutter/main.dart';

void main() {
  testWidgets('App renders WelcomeScreen and navigates to Landing', (
    tester,
  ) async {
    // Build the app
    await tester.pumpWidget(const MKEParkApp());

    // Verify WelcomeScreen content
    expect(find.text('Welcome to MKEPark'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);

    // Navigate to Landing
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Verify LandingScreen content
    expect(find.text('MKEPark'), findsOneWidget);
    expect(find.text('Welcome to MKEPark'), findsOneWidget);
    expect(find.text('Monitor parking regulations in your area'), findsOneWidget);
  });
}
