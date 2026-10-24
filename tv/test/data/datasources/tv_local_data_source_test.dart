import 'package:core/common/exception.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_local_data_source_test.mocks.dart';

@GenerateMocks([DatabaseHelper])
void main() {
  late TVLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TVLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      when(mockDatabaseHelper.insertWatchlistTV(testTVTable.toJson()))
          .thenAnswer((_) async => 1);

      final result = await dataSource.insertWatchlist(testTVTable);

      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database fails',
        () async {
      when(mockDatabaseHelper.insertWatchlistTV(testTVTable.toJson()))
          .thenThrow(Exception());

      final call = dataSource.insertWatchlist(testTVTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      when(mockDatabaseHelper.removeWatchlistTV(testTVTable.id))
          .thenAnswer((_) async => 1);

      final result = await dataSource.removeWatchlist(testTVTable);

      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database fails',
        () async {
      when(mockDatabaseHelper.removeWatchlistTV(testTVTable.id))
          .thenThrow(Exception());

      final call = dataSource.removeWatchlist(testTVTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get TV Detail By Id', () {
    const tId = 1;

    test('should return TV Detail Table when data is found', () async {
      when(mockDatabaseHelper.getTVById(tId))
          .thenAnswer((_) async => testTVMap);

      final result = await dataSource.getTVById(tId);

      expect(result, testTVTable);
    });

    test('should return null when data is not found', () async {
      when(mockDatabaseHelper.getTVById(tId)).thenAnswer((_) async => null);

      final result = await dataSource.getTVById(tId);

      expect(result, null);
    });
  });

  group('get watchlist TV', () {
    test('should return list of TVTable from database', () async {
      when(mockDatabaseHelper.getWatchlistTV())
          .thenAnswer((_) async => [testTVMap]);

      final result = await dataSource.getWatchlistTV();

      expect(result, [testTVTable]);
    });
  });
}
