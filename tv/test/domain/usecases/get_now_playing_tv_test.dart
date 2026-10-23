import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';

import 'get_now_playing_tv_test.mocks.dart';

@GenerateMocks([TVRepository])
void main() {
  late GetNowPlayingTV usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetNowPlayingTV(mockTVRepository);
  });

  final tTVList = <TV>[];

  test('should get list of TV series from the repository', () async {
    when(mockTVRepository.getNowPlayingTV())
        .thenAnswer((_) async => Right(tTVList));

    final result = await usecase.execute();

    expect(result, Right(tTVList));
  });
}
