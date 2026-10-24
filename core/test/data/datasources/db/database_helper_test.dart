import 'package:core/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    databaseHelper = DatabaseHelper();
    final db = await databaseHelper.database;
    await db?.delete('watchlist');
    await db?.delete('watchlist_tv');
  });

  const testMovieMap = {
    'id': 1,
    'title': 'Spider-Man',
    'overview': 'Overview',
    'posterPath': '/path.jpg',
  };

  const testTVMap = {
    'id': 1,
    'name': 'Game of Thrones',
    'overview': 'Overview',
    'posterPath': '/path.jpg',
  };

  group('Movie Watchlist Database Tests', () {
    test('insertWatchlist should insert movie map to database', () async {
      final result = await databaseHelper.insertWatchlist(testMovieMap);
      expect(result, equals(1));
    });

    test('removeWatchlist should delete movie from database', () async {
      await databaseHelper.insertWatchlist(testMovieMap);
      final result = await databaseHelper.removeWatchlist(1);
      expect(result, equals(1));
    });

    test('getMovieById should return map when found', () async {
      await databaseHelper.insertWatchlist(testMovieMap);
      final result = await databaseHelper.getMovieById(1);
      expect(result, equals(testMovieMap));
    });

    test('getMovieById should return null when not found', () async {
      final result = await databaseHelper.getMovieById(1);
      expect(result, isNull);
    });

    test('getWatchlistMovies should return list of map', () async {
      await databaseHelper.insertWatchlist(testMovieMap);
      final result = await databaseHelper.getWatchlistMovies();
      expect(result, equals([testMovieMap]));
    });
  });

  group('TV Watchlist Database Tests', () {
    test('insertWatchlistTV should insert tv map to database', () async {
      final result = await databaseHelper.insertWatchlistTV(testTVMap);
      expect(result, equals(1));
    });

    test('removeWatchlistTV should delete tv from database', () async {
      await databaseHelper.insertWatchlistTV(testTVMap);
      final result = await databaseHelper.removeWatchlistTV(1);
      expect(result, equals(1));
    });

    test('getTVById should return map when found', () async {
      await databaseHelper.insertWatchlistTV(testTVMap);
      final result = await databaseHelper.getTVById(1);
      expect(result, equals(testTVMap));
    });

    test('getTVById should return null when not found', () async {
      final result = await databaseHelper.getTVById(1);
      expect(result, isNull);
    });

    test('getWatchlistTV should return list of map', () async {
      await databaseHelper.insertWatchlistTV(testTVMap);
      final result = await databaseHelper.getWatchlistTV();
      expect(result, equals([testTVMap]));
    });
  });
}
