import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/domain/usecases/get_tv_season_detail.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_tv_season_detail_test.mocks.dart';

@GenerateMocks([TVRepository])
void main() {
  late GetTVSeasonDetail usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVSeasonDetail(mockTVRepository);
  });

  const tTvId = 1;
  const tSeasonNumber = 1;

  test('should get TV season detail from the repository', () async {
    when(mockTVRepository.getTVSeasonDetail(tTvId, tSeasonNumber))
        .thenAnswer((_) async => const Right(testSeasonDetail));

    final result = await usecase.execute(tTvId, tSeasonNumber);

    expect(result, const Right(testSeasonDetail));
  });
}
