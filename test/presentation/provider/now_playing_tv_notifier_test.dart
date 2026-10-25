import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/presentation/provider/now_playing_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'now_playing_tv_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTV])
void main() {
  late NowPlayingTVNotifier notifier;
  late MockGetNowPlayingTV mockGetNowPlayingTV;

  setUp(() {
    mockGetNowPlayingTV = MockGetNowPlayingTV();
    notifier = NowPlayingTVNotifier(mockGetNowPlayingTV);
  });

  final tTVList = <TV>[testTV];

  test('should change state to Loading when usecase is called', () async {
    // arrange
    when(mockGetNowPlayingTV.execute())
        .thenAnswer((_) async => Right(tTVList));
    // act
    notifier.fetchNowPlayingTV();
    // assert
    expect(notifier.state, RequestState.loading);
  });

  test('should change tv list when data is gotten successfully', () async {
    // arrange
    when(mockGetNowPlayingTV.execute())
        .thenAnswer((_) async => Right(tTVList));
    // act
    await notifier.fetchNowPlayingTV();
    // assert
    expect(notifier.state, RequestState.loaded);
    expect(notifier.tvList, tTVList);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetNowPlayingTV.execute())
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchNowPlayingTV();
    // assert
    expect(notifier.state, RequestState.error);
    expect(notifier.message, 'Server Failure');
  });
}
