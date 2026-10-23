import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie/data/models/movie_detail_model.dart';

import '../../json_reader.dart';

void main() {
  const tMovieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: "/path.jpg",
    budget: 100,
    genres: [],
    homepage: "https://google.com",
    id: 1,
    imdbId: "imdb1",
    originalLanguage: "en",
    originalTitle: "Original Title",
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    releaseDate: "2020-05-05",
    revenue: 12000,
    runtime: 120,
    status: "Status",
    tagline: "Tagline",
    title: "Title",
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  group('MovieDetailResponse', () {
    test('should parse JSON correctly and convert to entity', () {
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/movie_detail.json'));

      final result = MovieDetailResponse.fromJson(jsonMap);

      expect(result.id, 1);
      expect(result.title, 'Title');
      expect(result.toEntity().id, 1);

      final jsonOutput = tMovieDetailResponse.toJson();
      expect(jsonOutput['id'], 1);
      expect(tMovieDetailResponse.props, isNotEmpty);
    });
  });
}
