import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/presentation/bloc/tv_recommendations/tv_recommendations_bloc.dart';
import 'package:tv/presentation/bloc/tv_recommendations/tv_recommendations_event.dart';
import 'package:tv/presentation/bloc/tv_recommendations/tv_recommendations_state.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetTVRecommendations])
void main() {
  late TVRecommendationsBloc tvRecommendationsBloc;
  late MockGetTVRecommendations mockGetTVRecommendations;

  setUp(() {
    mockGetTVRecommendations = MockGetTVRecommendations();
    tvRecommendationsBloc = TVRecommendationsBloc(mockGetTVRecommendations);
  });

  const tId = 1;

  test('initialState should be TVRecommendationsEmpty', () {
    expect(tvRecommendationsBloc.state, TVRecommendationsEmpty());
  });

  blocTest<TVRecommendationsBloc, TVRecommendationsState>(
    'Should emit [TVRecommendationsLoading, TVRecommendationsLoaded] when data is gotten successfully',
    build: () {
      when(mockGetTVRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testTVList));
      return tvRecommendationsBloc;
    },
    act: (bloc) => bloc.add(const FetchTVRecommendations(tId)),
    expect: () => [
      TVRecommendationsLoading(),
      TVRecommendationsLoaded(testTVList),
    ],
    verify: (bloc) {
      verify(mockGetTVRecommendations.execute(tId));
    },
  );

  blocTest<TVRecommendationsBloc, TVRecommendationsState>(
    'Should emit [TVRecommendationsLoading, TVRecommendationsError] when get data is unsuccessful',
    build: () {
      when(mockGetTVRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvRecommendationsBloc;
    },
    act: (bloc) => bloc.add(const FetchTVRecommendations(tId)),
    expect: () => [
      TVRecommendationsLoading(),
      const TVRecommendationsError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTVRecommendations.execute(tId));
    },
  );
}
