class ReadingStats {
  const ReadingStats({
    required this.booksRead,
    this.averageRating,
    this.favoriteGenre,
  });

  final int booksRead;
  final double? averageRating;
  final String? favoriteGenre;
}
