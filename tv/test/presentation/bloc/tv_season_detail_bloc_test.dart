import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_season_detail.dart';
import 'package:tv/presentation/bloc/tv_season_detail/tv_season_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_season_detail/tv_season_detail_event.dart';
import 'package:tv/presentation/bloc/tv_season_detail/tv_season_detail_state.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_season_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTVSeasonDetail])
void main() {
  late TVSeasonDetailBloc tvSeasonDetailBloc;
  late MockGetTVSeasonDetail mockGetTVSeasonDetail;

  setUp(() {
    mockGetTVSeasonDetail = MockGetTVSeasonDetail();
    tvSeasonDetailBloc = TVSeasonDetailBloc(mockGetTVSeasonDetail);
  });

  const tTvId = 1;
  const tSeasonNumber = 1;

  test('initialState should be TVSeasonDetailEmpty', () {
    expect(tvSeasonDetailBloc.state, TVSeasonDetailEmpty());
  });

  blocTest<TVSeasonDetailBloc, TVSeasonDetailState>(
    'Should emit [TVSeasonDetailLoading, TVSeasonDetailLoaded] when data is gotten successfully',
    build: () {
      when(mockGetTVSeasonDetail.execute(tTvId, tSeasonNumber))
          .thenAnswer((_) async => const Right(testSeasonDetail));
      return tvSeasonDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTVSeasonDetail(tTvId, tSeasonNumber)),
    expect: () => [
      TVSeasonDetailLoading(),
      const TVSeasonDetailLoaded(testSeasonDetail),
    ],
    verify: (bloc) {
      verify(mockGetTVSeasonDetail.execute(tTvId, tSeasonNumber));
    },
  );

  blocTest<TVSeasonDetailBloc, TVSeasonDetailState>(
    'Should emit [TVSeasonDetailLoading, TVSeasonDetailError] when get data is unsuccessful',
    build: () {
      when(mockGetTVSeasonDetail.execute(tTvId, tSeasonNumber))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvSeasonDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTVSeasonDetail(tTvId, tSeasonNumber)),
    expect: () => [
      TVSeasonDetailLoading(),
      const TVSeasonDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTVSeasonDetail.execute(tTvId, tSeasonNumber));
    },
  );
}
