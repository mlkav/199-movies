import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/domain/usecases/search_tv.dart';

import 'search_tv_test.mocks.dart';

@GenerateMocks([TVRepository])
void main() {
  late SearchTV usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = SearchTV(mockTVRepository);
  });

  final tTVList = <TV>[];
  const tQuery = 'Game of Thrones';

  test('should get list of TV series from the repository', () async {
    when(mockTVRepository.searchTV(tQuery))
        .thenAnswer((_) async => Right(tTVList));

    final result = await usecase.execute(tQuery);

    expect(result, Right(tTVList));
  });
}
