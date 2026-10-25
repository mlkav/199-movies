import 'dart:convert';

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_season_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTVDetailResponse = TVDetailResponse(
    adult: false,
    backdropPath: '/path.jpg',
    firstAirDate: '2021-01-01',
    genres: [GenreModel(id: 1, name: 'Action')],
    homepage: 'https://google.com',
    id: 1,
    name: 'Name',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    seasons: [
      TVSeasonModel(
        airDate: '2021-01-01',
        episodeCount: 10,
        id: 1,
        name: 'Season 1',
        overview: 'Overview',
        posterPath: '/path.jpg',
        seasonNumber: 1,
      )
    ],
    status: 'Status',
    tagline: 'Tagline',
    type: 'Scripted',
    voteAverage: 1.0,
    voteCount: 1,
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_detail.json'));
      // act
      final result = TVDetailResponse.fromJson(jsonMap);
      // assert
      expect(result, tTVDetailResponse);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // act
      final result = tTVDetailResponse.toJson();
      // assert
      final expectedJsonMap = {
        "adult": false,
        "backdrop_path": "/path.jpg",
        "first_air_date": "2021-01-01",
        "genres": [
          {"id": 1, "name": "Action"}
        ],
        "homepage": "https://google.com",
        "id": 1,
        "name": "Name",
        "number_of_episodes": 10,
        "number_of_seasons": 1,
        "original_language": "en",
        "original_name": "Original Name",
        "overview": "Overview",
        "popularity": 1.0,
        "poster_path": "/path.jpg",
        "seasons": [
          {
            "air_date": "2021-01-01",
            "episode_count": 10,
            "id": 1,
            "name": "Season 1",
            "overview": "Overview",
            "poster_path": "/path.jpg",
            "season_number": 1
          }
        ],
        "status": "Status",
        "tagline": "Tagline",
        "type": "Scripted",
        "vote_average": 1.0,
        "vote_count": 1
      };
      expect(result, expectedJsonMap);
    });
  });
}
