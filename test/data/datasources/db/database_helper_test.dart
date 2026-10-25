import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'database_helper_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  late DatabaseHelper databaseHelper;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
    DatabaseHelper.testDatabase = mockDatabase;
    databaseHelper = DatabaseHelper();
  });

  test('database getter returns testDatabase when set', () async {
    final db = await databaseHelper.database;
    expect(db, equals(mockDatabase));
  });

  test('_initDb and _onCreate should initialize and execute table creation SQL statements', () async {
    DatabaseHelper.testDatabase = null;
    DatabaseHelper.getDatabasesPathFunction = () async => '/test/path';
    DatabaseHelper.openDatabaseFunction = (path, {version, onCreate}) async {
      onCreate!(mockDatabase, version!);
      return mockDatabase;
    };

    final db = await databaseHelper.database;
    expect(db, equals(mockDatabase));
    verify(mockDatabase.execute(any)).called(2);
  });

  group('DatabaseHelper Movie Watchlist Operations', () {
    test('insertWatchlist should insert movie map to database', () async {
      when(mockDatabase.insert('watchlist', testMovieTable.toJson()))
          .thenAnswer((_) async => 1);

      final result = await databaseHelper.insertWatchlist(testMovieTable);
      expect(result, 1);
    });

    test('removeWatchlist should delete movie from database', () async {
      when(mockDatabase.delete(
        'watchlist',
        where: 'id = ?',
        whereArgs: [testMovieTable.id],
      )).thenAnswer((_) async => 1);

      final result = await databaseHelper.removeWatchlist(testMovieTable);
      expect(result, 1);
    });

    test('getMovieById should return map when found', () async {
      when(mockDatabase.query(
        'watchlist',
        where: 'id = ?',
        whereArgs: [testMovieTable.id],
      )).thenAnswer((_) async => [testMovieMap]);

      final result = await databaseHelper.getMovieById(testMovieTable.id);
      expect(result, testMovieMap);
    });

    test('getMovieById should return null when not found', () async {
      when(mockDatabase.query(
        'watchlist',
        where: 'id = ?',
        whereArgs: [testMovieTable.id],
      )).thenAnswer((_) async => []);

      final result = await databaseHelper.getMovieById(testMovieTable.id);
      expect(result, isNull);
    });

    test('getWatchlistMovies should return list of map', () async {
      when(mockDatabase.query('watchlist'))
          .thenAnswer((_) async => [testMovieMap]);

      final result = await databaseHelper.getWatchlistMovies();
      expect(result, [testMovieMap]);
    });
  });

  group('DatabaseHelper TV Watchlist Operations', () {
    test('insertWatchlistTv should insert tv map to database', () async {
      when(mockDatabase.insert('watchlist_tv', testTVTable.toJson()))
          .thenAnswer((_) async => 1);

      final result = await databaseHelper.insertWatchlistTv(testTVTable);
      expect(result, 1);
    });

    test('removeWatchlistTv should delete tv from database', () async {
      when(mockDatabase.delete(
        'watchlist_tv',
        where: 'id = ?',
        whereArgs: [testTVTable.id],
      )).thenAnswer((_) async => 1);

      final result = await databaseHelper.removeWatchlistTv(testTVTable);
      expect(result, 1);
    });

    test('getTvById should return map when found', () async {
      when(mockDatabase.query(
        'watchlist_tv',
        where: 'id = ?',
        whereArgs: [testTVTable.id],
      )).thenAnswer((_) async => [testTVMap]);

      final result = await databaseHelper.getTvById(testTVTable.id);
      expect(result, testTVMap);
    });

    test('getTvById should return null when not found', () async {
      when(mockDatabase.query(
        'watchlist_tv',
        where: 'id = ?',
        whereArgs: [testTVTable.id],
      )).thenAnswer((_) async => []);

      final result = await databaseHelper.getTvById(testTVTable.id);
      expect(result, isNull);
    });

    test('getWatchlistTv should return list of map', () async {
      when(mockDatabase.query('watchlist_tv'))
          .thenAnswer((_) async => [testTVMap]);

      final result = await databaseHelper.getWatchlistTv();
      expect(result, [testTVMap]);
    });
  });
}
