import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';

import '../../dummy_data/dummy_objects.dart';
import 'remove_watchlist_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late RemoveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveWatchlist(mockMovieRepository);
  });

  test('should remove watchlist movie from repository', () async {
    when(mockMovieRepository.removeWatchlist(testMovieDetail))
        .thenAnswer((_) async => const Right('Removed from Watchlist'));

    final result = await usecase.execute(testMovieDetail);

    expect(result, const Right('Removed from Watchlist'));
  });
}
