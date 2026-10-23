import 'package:flutter_test/flutter_test.dart';
import 'package:movie/data/models/movie_table.dart';
import 'package:movie/domain/entities/movie.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  const tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  const tMovieMap = {
    'id': 1,
    'title': 'title',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  test('should return a valid MovieTable from map', () {
    final result = MovieTable.fromMap(tMovieMap);
    expect(result, tMovieTable);
  });

  test('should return a valid MovieTable from entity', () {
    final result = MovieTable.fromEntity(testMovieDetail);
    expect(result, tMovieTable);
  });

  test('should return a map containing proper data', () {
    final result = tMovieTable.toJson();
    expect(result, tMovieMap);
  });

  test('should return a watchlist Movie entity', () {
    final result = tMovieTable.toEntity();
    const expected = Movie.watchlist(
      id: 1,
      title: 'title',
      posterPath: 'posterPath',
      overview: 'overview',
    );
    expect(result, expected);
  });
}
