import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/season_model.dart';
import 'package:tv/data/models/tv_detail_model.dart';

import '../../json_reader.dart';

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

  const tTVDetailResponse = TVDetailResponse(
    adult: false,
    backdropPath: "/path.jpg",
    firstAirDate: "2021-01-01",
    genres: [],
    id: 1,
    name: "Name",
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originalName: "Original Name",
    overview: "Overview",
    posterPath: "/path.jpg",
    seasons: [tSeasonModel],
    voteAverage: 1.0,
    voteCount: 1,
  );

  group('TVDetailResponse', () {
    test('should parse JSON correctly and convert to entity', () {
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_detail.json'));

      final result = TVDetailResponse.fromJson(jsonMap);

      expect(result.id, 1);
      expect(result.name, 'Name');
      expect(result.toEntity().id, 1);

      final jsonOutput = tTVDetailResponse.toJson();
      expect(jsonOutput['id'], 1);
      expect(tTVDetailResponse.props, isNotEmpty);
    });
  });
}
