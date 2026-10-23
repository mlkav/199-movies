import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';
import 'package:tv/presentation/bloc/now_playing_tv/now_playing_tv_bloc.dart';
import 'package:tv/presentation/bloc/now_playing_tv/now_playing_tv_event.dart';
import 'package:tv/presentation/bloc/now_playing_tv/now_playing_tv_state.dart';

import '../../dummy_data/dummy_objects.dart';
import 'now_playing_tv_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTV])
void main() {
  late NowPlayingTVBloc nowPlayingTVBloc;
  late MockGetNowPlayingTV mockGetNowPlayingTV;

  setUp(() {
    mockGetNowPlayingTV = MockGetNowPlayingTV();
    nowPlayingTVBloc = NowPlayingTVBloc(mockGetNowPlayingTV);
  });

  test('initialState should be NowPlayingTVEmpty', () {
    expect(nowPlayingTVBloc.state, NowPlayingTVEmpty());
  });

  blocTest<NowPlayingTVBloc, NowPlayingTVState>(
    'Should emit [NowPlayingTVLoading, NowPlayingTVLoaded] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => Right(testTVList));
      return nowPlayingTVBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTV()),
    expect: () => [
      NowPlayingTVLoading(),
      NowPlayingTVLoaded(testTVList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingTV.execute());
    },
  );

  blocTest<NowPlayingTVBloc, NowPlayingTVState>(
    'Should emit [NowPlayingTVLoading, NowPlayingTVError] when get data is unsuccessful',
    build: () {
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return nowPlayingTVBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTV()),
    expect: () => [
      NowPlayingTVLoading(),
      const NowPlayingTVError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingTV.execute());
    },
  );
}
