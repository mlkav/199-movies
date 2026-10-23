import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/tv_table.dart';
import 'package:tv/domain/entities/tv.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  const tTVTable = TVTable(
    id: 1,
    name: 'Name',
    posterPath: '/path.jpg',
    overview: 'Overview',
  );

  const tTVMap = {
    'id': 1,
    'name': 'Name',
    'posterPath': '/path.jpg',
    'overview': 'Overview',
  };

  test('should return a valid TVTable from map', () {
    final result = TVTable.fromMap(tTVMap);
    expect(result, tTVTable);
  });

  test('should return a valid TVTable from entity', () {
    final result = TVTable.fromEntity(testTVDetail);
    expect(result, tTVTable);
  });

  test('should return a map containing proper data', () {
    final result = tTVTable.toJson();
    expect(result, tTVMap);
  });

  test('should return a watchlist TV entity', () {
    final result = tTVTable.toEntity();
    const expected = TV.watchlist(
      id: 1,
      name: 'Name',
      posterPath: '/path.jpg',
      overview: 'Overview',
    );
    expect(result, expected);
  });
}
