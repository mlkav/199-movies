import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_event.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_state.dart';

import '../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTV])
void main() {
  late TopRatedTVBloc topRatedTVBloc;
  late MockGetTopRatedTV mockGetTopRatedTV;

  setUp(() {
    mockGetTopRatedTV = MockGetTopRatedTV();
    topRatedTVBloc = TopRatedTVBloc(getTopRatedTV: mockGetTopRatedTV);
  });

  test('initialState should be TopRatedTVEmpty', () {
    expect(topRatedTVBloc.state, TopRatedTVEmpty());
  });

  blocTest<TopRatedTVBloc, TopRatedTVState>(
    'Should emit [TopRatedTVLoading, TopRatedTVLoaded] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTV.execute())
          .thenAnswer((_) async => Right(testTVList));
      return topRatedTVBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTV()),
    expect: () => [
      TopRatedTVLoading(),
      TopRatedTVLoaded(testTVList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTV.execute());
    },
  );

  blocTest<TopRatedTVBloc, TopRatedTVState>(
    'Should emit [TopRatedTVLoading, TopRatedTVError] when get data is unsuccessful',
    build: () {
      when(mockGetTopRatedTV.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return topRatedTVBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTV()),
    expect: () => [
      TopRatedTVLoading(),
      const TopRatedTVError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTV.execute());
    },
  );
}
