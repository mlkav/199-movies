import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';

import 'get_tv_recommendations_test.mocks.dart';

@GenerateMocks([TVRepository])
void main() {
  late GetTVRecommendations usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVRecommendations(mockTVRepository);
  });

  const tId = 1;
  final tTVList = <TV>[];

  test('should get list of TV recommendations from the repository', () async {
    when(mockTVRepository.getTVRecommendations(tId))
        .thenAnswer((_) async => Right(tTVList));

    final result = await usecase.execute(tId);

    expect(result, Right(tTVList));
  });
}
