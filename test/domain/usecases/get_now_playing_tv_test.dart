import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTV usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetNowPlayingTV(mockTVRepository);
  });

  final tTVList = <TV>[testTV];

  test('should get list of TV series from repository', () async {
    // arrange
    when(mockTVRepository.getNowPlayingTV())
        .thenAnswer((_) async => Right(tTVList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTVList));
  });
}
