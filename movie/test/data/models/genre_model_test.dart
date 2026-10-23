import 'package:flutter_test/flutter_test.dart';
import 'package:movie/data/models/genre_model.dart';
import 'package:movie/domain/entities/genre.dart';

void main() {
  const tGenreModel = GenreModel(id: 1, name: 'Action');
  const tGenre = Genre(id: 1, name: 'Action');

  test('should be a subclass of Genre entity', () {
    final result = tGenreModel.toEntity();
    expect(result, tGenre);
  });

  test('toJson should return valid json map', () {
    final result = tGenreModel.toJson();
    expect(result, {'id': 1, 'name': 'Action'});
  });
}
