import 'package:bookshelf/core/widgets/book_card.dart';
import 'package:bookshelf/features/book_catalog/domain/entities/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../l10n_mock.dart';

void main() {
  testWidgets('BookCard displays book details', (tester) async {
    const book = Book(
      workId: '1',
      title: 'Harry Potter',
      authorNames: ['J.K. Rowling'],
      firstPublishYear: 1997,
      coverId: null,
    );

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [MockAppLocalizationsDelegate()],
        home: Scaffold(
          body: BookCard(book: book),
        ),
      ),
    );

    expect(find.text('Harry Potter'), findsOneWidget);
    expect(find.text('J.K. Rowling'), findsOneWidget);
  });
}
