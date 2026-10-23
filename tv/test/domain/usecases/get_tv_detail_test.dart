import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_tv_detail_test.mocks.dart';

@GenerateMocks([TVRepository])
void main() {
  late GetTVDetail usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVDetail(mockTVRepository);
  });

  const tId = 1;

  test('should get TV detail from the repository', () async {
    when(mockTVRepository.getTVDetail(tId))
        .thenAnswer((_) async => const Right(testTVDetail));

    final result = await usecase.execute(tId);

    expect(result, const Right(testTVDetail));
  });
}
