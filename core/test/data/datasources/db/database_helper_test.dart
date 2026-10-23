import 'package:core/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper_test.mocks.dart';

@GenerateMocks([Database])
void main() {
  late DatabaseHelper databaseHelper;
  late MockDatabase mockDatabase;

  const testMovieMap = {
    'id': 1,
    'title': 'title',
    'overview': 'overview',
    'posterPath': 'posterPath',
  };

  const testTVMap = {
    'id': 1,
    'name': 'Name',
    'overview': 'Overview',
    'posterPath': '/path.jpg',
  };

  setUp(() {
    mockDatabase = MockDatabase();
    DatabaseHelper.testDatabase = mockDatabase;
    databaseHelper = DatabaseHelper();
  });

  test('database getter returns testDatabase when set', () async {
    final db = await databaseHelper.database;
    expect(db, equals(mockDatabase));
  });

  test(
      '_initDb and _onCreate should initialize and execute table creation SQL statements',
      () async {
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
      when(mockDatabase.insert('watchlist', testMovieMap))
          .thenAnswer((_) async => 1);

      final result = await databaseHelper.insertWatchlist(testMovieMap);
      expect(result, 1);
    });

    test('removeWatchlist should delete movie from database', () async {
      when(mockDatabase.delete(
        'watchlist',
        where: 'id = ?',
        whereArgs: [1],
      )).thenAnswer((_) async => 1);

      final result = await databaseHelper.removeWatchlist(1);
      expect(result, 1);
    });

    test('getMovieById should return map when found', () async {
      when(mockDatabase.query(
        'watchlist',
        where: 'id = ?',
        whereArgs: [1],
      )).thenAnswer((_) async => [testMovieMap]);

      final result = await databaseHelper.getMovieById(1);
      expect(result, testMovieMap);
    });

    test('getMovieById should return null when not found', () async {
      when(mockDatabase.query(
        'watchlist',
        where: 'id = ?',
        whereArgs: [1],
      )).thenAnswer((_) async => []);

      final result = await databaseHelper.getMovieById(1);
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
      when(mockDatabase.insert('watchlist_tv', testTVMap))
          .thenAnswer((_) async => 1);

      final result = await databaseHelper.insertWatchlistTv(testTVMap);
      expect(result, 1);
    });

    test('removeWatchlistTv should delete tv from database', () async {
      when(mockDatabase.delete(
        'watchlist_tv',
        where: 'id = ?',
        whereArgs: [1],
      )).thenAnswer((_) async => 1);

      final result = await databaseHelper.removeWatchlistTv(1);
      expect(result, 1);
    });

    test('getTvById should return map when found', () async {
      when(mockDatabase.query(
        'watchlist_tv',
        where: 'id = ?',
        whereArgs: [1],
      )).thenAnswer((_) async => [testTVMap]);

      final result = await databaseHelper.getTvById(1);
      expect(result, testTVMap);
    });

    test('getTvById should return null when not found', () async {
      when(mockDatabase.query(
        'watchlist_tv',
        where: 'id = ?',
        whereArgs: [1],
      )).thenAnswer((_) async => []);

      final result = await databaseHelper.getTvById(1);
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
