import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';

import 'get_popular_tv_test.mocks.dart';

@GenerateMocks([TVRepository])
void main() {
  late GetPopularTV usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetPopularTV(mockTVRepository);
  });

  final tTVList = <TV>[];

  test('should get list of TV series from the repository', () async {
    when(mockTVRepository.getPopularTV())
        .thenAnswer((_) async => Right(tTVList));

    final result = await usecase.execute();

    expect(result, Right(tTVList));
  });
}
