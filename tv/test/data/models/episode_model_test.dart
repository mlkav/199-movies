import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/episode_model.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  const tEpisodeModel = EpisodeModel(
    airDate: '2021-01-01',
    episodeNumber: 1,
    id: 1,
    name: 'Episode 1',
    overview: 'Overview',
    runtime: 60,
    seasonNumber: 1,
    stillPath: '/path.jpg',
    voteAverage: 8.0,
    voteCount: 10,
  );

  final tEpisodeJson = {
    'air_date': '2021-01-01',
    'episode_number': 1,
    'id': 1,
    'name': 'Episode 1',
    'overview': 'Overview',
    'runtime': 60,
    'season_number': 1,
    'still_path': '/path.jpg',
    'vote_average': 8.0,
    'vote_count': 10,
  };

  test('should be a subclass of Episode entity', () {
    final result = tEpisodeModel.toEntity();
    expect(result, testEpisode);
  });

  test('fromJson should return valid EpisodeModel', () {
    final result = EpisodeModel.fromJson(tEpisodeJson);
    expect(result, tEpisodeModel);
  });

  test('toJson should return valid json map', () {
    final result = tEpisodeModel.toJson();
    expect(result, tEpisodeJson);
  });

  test('fromJson should handle null fields gracefully', () {
    final jsonMap = <String, dynamic>{};
    final result = EpisodeModel.fromJson(jsonMap);
    expect(result.episodeNumber, 0);
    expect(result.id, 0);
    expect(result.name, '');
    expect(result.overview, '');
    expect(result.voteAverage, 0.0);
    expect(result.voteCount, 0);
  });
}
