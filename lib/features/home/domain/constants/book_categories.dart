import 'package:flutter/material.dart';

enum BookCategoryKey {
  fiction,
  science,
  history,
  romance,
  fantasy,
  mystery,
  biography,
  children,
}

class BookCategory {
  const BookCategory({
    required this.key,
    required this.searchQuery,
    required this.icon,
  });

  final BookCategoryKey key;
  final String searchQuery;
  final IconData icon;
}

const List<BookCategory> popularBookCategories = <BookCategory>[
  BookCategory(
    key: BookCategoryKey.fiction,
    searchQuery: 'subject:fiction',
    icon: Icons.auto_stories_outlined,
  ),
  BookCategory(
    key: BookCategoryKey.science,
    searchQuery: 'subject:science',
    icon: Icons.biotech_outlined,
  ),
  BookCategory(
    key: BookCategoryKey.history,
    searchQuery: 'subject:history',
    icon: Icons.history_edu_outlined,
  ),
  BookCategory(
    key: BookCategoryKey.romance,
    searchQuery: 'subject:romance',
    icon: Icons.favorite_border,
  ),
  BookCategory(
    key: BookCategoryKey.fantasy,
    searchQuery: 'subject:fantasy',
    icon: Icons.auto_fix_high_outlined,
  ),
  BookCategory(
    key: BookCategoryKey.mystery,
    searchQuery: 'subject:mystery',
    icon: Icons.search_outlined,
  ),
  BookCategory(
    key: BookCategoryKey.biography,
    searchQuery: 'subject:biography',
    icon: Icons.person_outline,
  ),
  BookCategory(
    key: BookCategoryKey.children,
    searchQuery: 'subject:children',
    icon: Icons.child_care_outlined,
  ),
];
