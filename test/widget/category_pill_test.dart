import 'package:bookshelf/core/widgets/category_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CategoryPill displays label and icon', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CategoryPill(
            label: 'Fantasy',
            icon: Icons.flash_on,
          ),
        ),
      ),
    );

    expect(find.text('Fantasy'), findsOneWidget);
    expect(find.byIcon(Icons.flash_on), findsOneWidget);
  });
}
