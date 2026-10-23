import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';

import '../../dummy_data/dummy_objects.dart';
import 'save_watchlist_tv_test.mocks.dart';

@GenerateMocks([TVRepository])
void main() {
  late SaveWatchlistTV usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = SaveWatchlistTV(mockTVRepository);
  });

  test('should save TV show to the repository', () async {
    when(mockTVRepository.saveWatchlistTV(testTVDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));

    final result = await usecase.execute(testTVDetail);

    expect(result, const Right('Added to Watchlist'));
  });
}
