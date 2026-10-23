import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_event.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_state.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTVDetail])
void main() {
  late TVDetailBloc tvDetailBloc;
  late MockGetTVDetail mockGetTVDetail;

  setUp(() {
    mockGetTVDetail = MockGetTVDetail();
    tvDetailBloc = TVDetailBloc(mockGetTVDetail);
  });

  const tId = 1;

  test('initialState should be TVDetailEmpty', () {
    expect(tvDetailBloc.state, TVDetailEmpty());
  });

  blocTest<TVDetailBloc, TVDetailState>(
    'Should emit [TVDetailLoading, TVDetailLoaded] when data is gotten successfully',
    build: () {
      when(mockGetTVDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVDetail));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTVDetail(tId)),
    expect: () => [
      TVDetailLoading(),
      const TVDetailLoaded(testTVDetail),
    ],
    verify: (bloc) {
      verify(mockGetTVDetail.execute(tId));
    },
  );

  blocTest<TVDetailBloc, TVDetailState>(
    'Should emit [TVDetailLoading, TVDetailError] when get data is unsuccessful',
    build: () {
      when(mockGetTVDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(const FetchTVDetail(tId)),
    expect: () => [
      TVDetailLoading(),
      const TVDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTVDetail.execute(tId));
    },
  );
}
