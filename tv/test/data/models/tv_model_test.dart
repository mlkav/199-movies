import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/domain/entities/tv.dart';

void main() {
  const tTVModel = TVModel(
    backdropPath: '/path.jpg',
    firstAirDate: '2021-01-01',
    genreIds: [1, 2],
    id: 1,
    name: 'Name',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    voteAverage: 1.0,
    voteCount: 1,
  );

  const tTV = TV(
    backdropPath: '/path.jpg',
    firstAirDate: '2021-01-01',
    genreIds: [1, 2],
    id: 1,
    name: 'Name',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    voteAverage: 1.0,
    voteCount: 1,
  );

  test('should be a subclass of TV entity', () async {
    final result = tTVModel.toEntity();
    expect(result, tTV);
  });

  test('should parse json correctly when genre_ids and origin_country are null',
      () {
    final jsonMap = {
      'backdrop_path': '/path.jpg',
      'first_air_date': '2021-01-01',
      'genre_ids': null,
      'id': 1,
      'name': 'Name',
      'origin_country': null,
      'original_language': 'en',
      'original_name': 'Original Name',
      'overview': 'Overview',
      'popularity': 1.0,
      'poster_path': '/path.jpg',
      'vote_average': 1.0,
      'vote_count': 1,
    };

    final result = TVModel.fromJson(jsonMap);
    expect(result.genreIds, isEmpty);
    expect(result.originCountry, isEmpty);
  });

  test('should return json map containing proper data', () {
    final result = tTVModel.toJson();
    final expectedJsonMap = {
      'backdrop_path': '/path.jpg',
      'first_air_date': '2021-01-01',
      'genre_ids': [1, 2],
      'id': 1,
      'name': 'Name',
      'origin_country': ['US'],
      'original_language': 'en',
      'original_name': 'Original Name',
      'overview': 'Overview',
      'popularity': 1.0,
      'poster_path': '/path.jpg',
      'vote_average': 1.0,
      'vote_count': 1,
    };
    expect(result, expectedJsonMap);
  });
}
