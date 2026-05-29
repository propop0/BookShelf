import 'package:flutter/material.dart';

class BookCategory {
  const BookCategory({
    required this.label,
    required this.searchQuery,
    required this.icon,
  });

  final String label;
  final String searchQuery;
  final IconData icon;
}

const List<BookCategory> popularBookCategories = <BookCategory>[
  BookCategory(
    label: 'Fiction',
    searchQuery: 'subject:fiction',
    icon: Icons.auto_stories_outlined,
  ),
  BookCategory(
    label: 'Science',
    searchQuery: 'subject:science',
    icon: Icons.biotech_outlined,
  ),
  BookCategory(
    label: 'History',
    searchQuery: 'subject:history',
    icon: Icons.history_edu_outlined,
  ),
  BookCategory(
    label: 'Romance',
    searchQuery: 'subject:romance',
    icon: Icons.favorite_border,
  ),
  BookCategory(
    label: 'Fantasy',
    searchQuery: 'subject:fantasy',
    icon: Icons.auto_fix_high_outlined,
  ),
  BookCategory(
    label: 'Mystery',
    searchQuery: 'subject:mystery',
    icon: Icons.search_outlined,
  ),
  BookCategory(
    label: 'Biography',
    searchQuery: 'subject:biography',
    icon: Icons.person_outline,
  ),
  BookCategory(
    label: 'Children',
    searchQuery: 'subject:children',
    icon: Icons.child_care_outlined,
  ),
];
