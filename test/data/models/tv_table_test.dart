import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tTVTable = TVTable(
    id: 1,
    name: 'Name',
    posterPath: '/path.jpg',
    overview: 'Overview',
  );

  final tTVMap = {
    'id': 1,
    'name': 'Name',
    'posterPath': '/path.jpg',
    'overview': 'Overview',
  };

  test('should return valid TVTable from map', () async {
    final result = TVTable.fromMap(tTVMap);
    expect(result, tTVTable);
  });

  test('should return valid TVTable from entity', () async {
    final result = TVTable.fromEntity(testTVDetail);
    expect(result, tTVTable);
  });

  test('should return json map from TVTable', () async {
    final result = tTVTable.toJson();
    expect(result, tTVMap);
  });

  test('should convert TVTable to TV watchlist entity', () async {
    final result = tTVTable.toEntity();
    final expectedTV = TV.watchlist(
      id: 1,
      name: 'Name',
      posterPath: '/path.jpg',
      overview: 'Overview',
    );
    expect(result, expectedTV);
  });
}
