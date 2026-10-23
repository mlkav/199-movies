import 'package:core/common/exception.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_local_data_source_test.mocks.dart';

@GenerateMocks([DatabaseHelper])
void main() {
  late MovieLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      when(mockDatabaseHelper.insertWatchlist(testMovieTable.toJson()))
          .thenAnswer((_) async => 1);

      final result = await dataSource.insertWatchlist(testMovieTable);

      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database fails',
        () async {
      when(mockDatabaseHelper.insertWatchlist(testMovieTable.toJson()))
          .thenThrow(Exception());

      final call = dataSource.insertWatchlist(testMovieTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      when(mockDatabaseHelper.removeWatchlist(testMovieTable.id))
          .thenAnswer((_) async => 1);

      final result = await dataSource.removeWatchlist(testMovieTable);

      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database fails',
        () async {
      when(mockDatabaseHelper.removeWatchlist(testMovieTable.id))
          .thenThrow(Exception());

      final call = dataSource.removeWatchlist(testMovieTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get Movie Detail By Id', () {
    const tId = 1;

    test('should return Movie Detail Table when data is found', () async {
      when(mockDatabaseHelper.getMovieById(tId))
          .thenAnswer((_) async => testMovieMap);

      final result = await dataSource.getMovieById(tId);

      expect(result, testMovieTable);
    });

    test('should return null when data is not found', () async {
      when(mockDatabaseHelper.getMovieById(tId)).thenAnswer((_) async => null);

      final result = await dataSource.getMovieById(tId);

      expect(result, null);
    });
  });

  group('get watchlist movies', () {
    test('should return list of MovieTable from database', () async {
      when(mockDatabaseHelper.getWatchlistMovies())
          .thenAnswer((_) async => [testMovieMap]);

      final result = await dataSource.getWatchlistMovies();

      expect(result, [testMovieTable]);
    });
  });
}
