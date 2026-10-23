import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_event.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_state.dart';

import '../../dummy_data/dummy_objects.dart';
import 'popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTV])
void main() {
  late PopularTVBloc popularTVBloc;
  late MockGetPopularTV mockGetPopularTV;

  setUp(() {
    mockGetPopularTV = MockGetPopularTV();
    popularTVBloc = PopularTVBloc(mockGetPopularTV);
  });

  test('initialState should be PopularTVEmpty', () {
    expect(popularTVBloc.state, PopularTVEmpty());
  });

  blocTest<PopularTVBloc, PopularTVState>(
    'Should emit [PopularTVLoading, PopularTVLoaded] when data is gotten successfully',
    build: () {
      when(mockGetPopularTV.execute())
          .thenAnswer((_) async => Right(testTVList));
      return popularTVBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTV()),
    expect: () => [
      PopularTVLoading(),
      PopularTVLoaded(testTVList),
    ],
    verify: (bloc) {
      verify(mockGetPopularTV.execute());
    },
  );

  blocTest<PopularTVBloc, PopularTVState>(
    'Should emit [PopularTVLoading, PopularTVError] when get data is unsuccessful',
    build: () {
      when(mockGetPopularTV.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return popularTVBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTV()),
    expect: () => [
      PopularTVLoading(),
      const PopularTVError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularTV.execute());
    },
  );
}
