import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/episode_model.dart';
import 'package:tv/data/models/season_detail_model.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  const tSeasonDetailResponse = SeasonDetailResponse(
    airDate: '2021-01-01',
    episodes: [
      EpisodeModel(
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
      )
    ],
    id: 1,
    name: 'Season 1',
    overview: 'Overview',
    posterPath: '/path.jpg',
    seasonNumber: 1,
  );

  test('should convert to entity', () {
    final result = tSeasonDetailResponse.toEntity();
    expect(result, testSeasonDetail);
  });

  test('should return json map', () {
    final result = tSeasonDetailResponse.toJson();
    expect(result['id'], 1);
    expect(result['name'], 'Season 1');
  });
}
