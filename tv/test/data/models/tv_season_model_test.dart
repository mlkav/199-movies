import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/season_model.dart';
import 'package:tv/domain/entities/season.dart';

void main() {
  const tSeasonModel = SeasonModel(
    airDate: '2021-01-01',
    episodeCount: 10,
    id: 1,
    name: 'Season 1',
    overview: 'Overview',
    posterPath: '/path.jpg',
    seasonNumber: 1,
  );

  const tSeason = Season(
    airDate: '2021-01-01',
    episodeCount: 10,
    id: 1,
    name: 'Season 1',
    overview: 'Overview',
    posterPath: '/path.jpg',
    seasonNumber: 1,
  );

  test('should be a subclass of Season entity', () {
    final result = tSeasonModel.toEntity();
    expect(result, tSeason);
  });
}
