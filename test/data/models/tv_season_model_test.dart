import 'package:ditonton/data/models/tv_season_model.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tSeasonModel = TVSeasonModel(
    airDate: '2021-01-01',
    episodeCount: 10,
    id: 1,
    name: 'Season 1',
    overview: 'Overview',
    posterPath: '/path.jpg',
    seasonNumber: 1,
  );

  final tSeason = Season(
    airDate: '2021-01-01',
    episodeCount: 10,
    id: 1,
    name: 'Season 1',
    overview: 'Overview',
    posterPath: '/path.jpg',
    seasonNumber: 1,
  );

  test('should be a subclass of Season entity', () async {
    final result = tSeasonModel.toEntity();
    expect(result, tSeason);
  });

  test('should return json map from model', () async {
    final result = tSeasonModel.toJson();
    final expectedMap = {
      'air_date': '2021-01-01',
      'episode_count': 10,
      'id': 1,
      'name': 'Season 1',
      'overview': 'Overview',
      'poster_path': '/path.jpg',
      'season_number': 1,
    };
    expect(result, expectedMap);
  });
}
