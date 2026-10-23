import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';

import '../../dummy_data/dummy_objects.dart';
import 'remove_watchlist_tv_test.mocks.dart';

@GenerateMocks([TVRepository])
void main() {
  late RemoveWatchlistTV usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = RemoveWatchlistTV(mockTVRepository);
  });

  test('should remove watchlist TV show from repository', () async {
    when(mockTVRepository.removeWatchlistTV(testTVDetail))
        .thenAnswer((_) async => const Right('Removed from Watchlist'));

    final result = await usecase.execute(testTVDetail);

    expect(result, const Right('Removed from Watchlist'));
  });
}
