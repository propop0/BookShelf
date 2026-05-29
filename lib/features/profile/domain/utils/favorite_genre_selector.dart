import '../../../library/domain/entities/library_entry.dart';
import '../../../library/domain/entities/reading_status.dart';

/// Picks the user's favorite genre from library entries using a taste model,
/// not a raw book count.
///
/// Each book contributes an **engagement** weight (finished > in progress;
/// want-to-read is ignored) and a **satisfaction** score from the 1–10 rating.
/// Per-genre affinity uses a Bayesian-style blend with the library-wide average
/// so one lucky 10/10 does not beat a genre the user consistently enjoys.
class FavoriteGenreSelector {
  const FavoriteGenreSelector._();

  /// Prior "virtual books" — stabilizes genres with few entries.
  static const double _priorBookCount = 2.0;

  /// Finished books count fully toward taste; in-progress counts partially.
  static const double _readingEngagement = 0.35;

  /// Assumed satisfaction (1–10 scale) when a finished book has no rating.
  static const double _unratedReadDefault = 6.0;

  /// Neutral satisfaction for in-progress books without a rating.
  static const double _unratedReadingDefault = 5.0;

  static String? fromEntries(List<LibraryEntry> entries) {
    final List<_GenreSignal> signals = <_GenreSignal>[];
    for (final LibraryEntry entry in entries) {
      final String? genre = _normalizeGenre(entry.primarySubject);
      if (genre == null) {
        continue;
      }

      final double? engagement = _engagementFor(entry.status);
      if (engagement == null || engagement <= 0) {
        continue;
      }

      final double? satisfaction = _satisfactionFor(entry);
      if (satisfaction == null) {
        continue;
      }

      signals.add(
        _GenreSignal(
          genre: genre,
          engagement: engagement,
          satisfaction: satisfaction,
        ),
      );
    }

    if (signals.isEmpty) {
      return null;
    }

    final double globalMean = _weightedMean(signals);
    final Map<String, _GenreAggregate> byGenre = <String, _GenreAggregate>{};

    for (final _GenreSignal signal in signals) {
      byGenre.update(
        signal.genre,
        (_GenreAggregate aggregate) {
          aggregate.add(signal);
          return aggregate;
        },
        ifAbsent: () => _GenreAggregate()..add(signal),
      );
    }

    String? bestGenre;
    double bestAffinity = double.negativeInfinity;
    double bestEngagement = -1;
    double bestMeanSatisfaction = -1;

    for (final MapEntry<String, _GenreAggregate> entry in byGenre.entries) {
      final _GenreAggregate aggregate = entry.value;
      final double affinity = _bayesianAffinity(
        engagement: aggregate.totalEngagement,
        meanSatisfaction: aggregate.meanSatisfaction,
        globalMean: globalMean,
      );

      final bool beatsCurrent = affinity > bestAffinity ||
          (affinity == bestAffinity &&
              (aggregate.totalEngagement > bestEngagement ||
                  (aggregate.totalEngagement == bestEngagement &&
                      aggregate.meanSatisfaction > bestMeanSatisfaction)));

      if (beatsCurrent) {
        bestGenre = entry.key;
        bestAffinity = affinity;
        bestEngagement = aggregate.totalEngagement;
        bestMeanSatisfaction = aggregate.meanSatisfaction;
      }
    }

    return bestGenre;
  }

  /// Open Library subjects are often hierarchical (`Fiction : Science fiction`).
  /// We group by the most specific segment for fair comparison.
  static String? _normalizeGenre(String? raw) {
    if (raw == null) {
      return null;
    }
    final String trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final List<String> parts = trimmed
        .split(':')
        .map((String part) => part.trim())
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return null;
    }
    return parts.last;
  }

  static double? _engagementFor(ReadingStatus status) {
    return switch (status) {
      ReadingStatus.read => 1.0,
      ReadingStatus.reading => _readingEngagement,
      ReadingStatus.wantToRead => null,
    };
  }

  static double? _satisfactionFor(LibraryEntry entry) {
    final int? rating = entry.rating;
    if (rating != null) {
      if (rating < 1 || rating > 10) {
        return null;
      }
      return rating.toDouble();
    }

    return switch (entry.status) {
      ReadingStatus.read => _unratedReadDefault,
      ReadingStatus.reading => _unratedReadingDefault,
      ReadingStatus.wantToRead => null,
    };
  }

  static double _weightedMean(List<_GenreSignal> signals) {
    double weightedSum = 0;
    double totalWeight = 0;
    for (final _GenreSignal signal in signals) {
      weightedSum += signal.engagement * signal.satisfaction;
      totalWeight += signal.engagement;
    }
    return totalWeight == 0 ? _unratedReadDefault : weightedSum / totalWeight;
  }

  /// `(v * R + m * C) / (v + m)` on the 1–10 satisfaction scale.
  static double _bayesianAffinity({
    required double engagement,
    required double meanSatisfaction,
    required double globalMean,
  }) {
    return (engagement * meanSatisfaction + _priorBookCount * globalMean) /
        (engagement + _priorBookCount);
  }
}

class _GenreSignal {
  const _GenreSignal({
    required this.genre,
    required this.engagement,
    required this.satisfaction,
  });

  final String genre;
  final double engagement;
  final double satisfaction;
}

class _GenreAggregate {
  double totalEngagement = 0;
  double weightedSatisfactionSum = 0;

  void add(_GenreSignal signal) {
    totalEngagement += signal.engagement;
    weightedSatisfactionSum += signal.engagement * signal.satisfaction;
  }

  double get meanSatisfaction =>
      totalEngagement == 0 ? 0 : weightedSatisfactionSum / totalEngagement;
}
