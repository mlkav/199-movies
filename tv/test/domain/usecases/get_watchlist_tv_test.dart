import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/domain/usecases/get_watchlist_tv.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_watchlist_tv_test.mocks.dart';

@GenerateMocks([TVRepository])
void main() {
  late GetWatchlistTV usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetWatchlistTV(mockTVRepository);
  });

  test('should get list of TV series from the repository', () async {
    when(mockTVRepository.getWatchlistTV())
        .thenAnswer((_) async => Right(testTVList));

    final result = await usecase.execute();

    expect(result, Right(testTVList));
  });
}
