// This line brings in the tools we need to create a nice-looking app.
import 'package:flutter/material.dart';

// This line brings in the tools we need to test the app.
import 'package:flutter_test/flutter_test.dart';

// This line brings in the main part of our BMI Calculator app to test it.
import 'package:bmi_calculator/main.dart';

// This line starts the group of tests for our app.
void main() {
  // This line creates a test to check if the BMI Calculator works correctly.
  testWidgets('BMI Calculator calculates and displays result',
      (WidgetTester tester) async {
    // This line builds the app and shows it on the screen for testing.
    await tester.pumpWidget(const BMICalculatorApp());

    // This line checks if the app shows the "BMI Calculator" title at the top.
    expect(find.text('BMI Calculator'), findsOneWidget);

    // This line checks if the weight input field is on the screen.
    expect(find.widgetWithText(TextFormField, 'Weight (kg)'), findsOneWidget);

    // This line checks if the height input field is on the screen.
    expect(find.widgetWithText(TextFormField, 'Height (cm)'), findsOneWidget);

    // This line checks if the "Calculate BMI" button is on the screen.
    expect(
        find.widgetWithText(ElevatedButton, 'Calculate BMI'), findsOneWidget);

    // This line checks that the result is not shown yet (because we haven't calculated).
    expect(find.textContaining('BMI:'), findsNothing);
    expect(find.textContaining('Category:'), findsNothing);

    // This line types "70" into the weight input field.
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Weight (kg)'), '70');

    // This line types "170" into the height input field.
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Height (cm)'), '170');

    // This line updates the screen to show the typed text.
    await tester.pump();

    // This line taps the "Calculate BMI" button.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Calculate BMI'));

    // This line waits for the app to finish animations (like the fading result).
    await tester.pumpAndSettle();

    // This line checks if the BMI result is shown (BMI = 70 / (1.7 * 1.7) ≈ 24.2).
    expect(find.text('BMI: 24.2'), findsOneWidget);

    // This line checks if the category is shown as "Normal" (since 24.2 is in the Normal range).
    expect(find.text('Category: Normal'), findsOneWidget);

    // This line checks if the category text is green (since "Normal" should be green).
    final categoryText = tester.widget<Text>(find.text('Category: Normal'));
    expect(categoryText.style!.color, Colors.green);
  });

  // This line creates a test to check if the app shows an error for invalid inputs.
  testWidgets('BMI Calculator shows validation error for invalid inputs',
      (WidgetTester tester) async {
    // This line builds the app and shows it on the screen for testing.
    await tester.pumpWidget(const BMICalculatorApp());

    // This line types "0" into the weight input field (which is invalid).
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Weight (kg)'), '0');

    // This line types "-10" into the height input field (which is invalid).
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Height (cm)'), '-10');

    // This line updates the screen to show the typed text.
    await tester.pump();

    // This line taps the "Calculate BMI" button.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Calculate BMI'));

    // This line waits for the app to show any error messages.
    await tester.pump();

    // This line checks if the app shows an error message for the weight.
    expect(find.text('Enter valid weight'), findsOneWidget);

    // This line checks if the app shows an error message for the height.
    expect(find.text('Enter valid height'), findsOneWidget);

    // This line checks that the result is not shown (because the inputs were invalid).
    expect(find.textContaining('BMI:'), findsNothing);
    expect(find.textContaining('Category:'), findsNothing);
  });
}
