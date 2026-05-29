import 'package:bookshelf/core/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppCard displays child and handles tap', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppCard(
            onTap: () => tapped = true,
            child: const Text('Test Content'),
          ),
        ),
      ),
    );

    expect(find.text('Test Content'), findsOneWidget);
    await tester.tap(find.text('Test Content'));
    expect(tapped, true);
  });
}
