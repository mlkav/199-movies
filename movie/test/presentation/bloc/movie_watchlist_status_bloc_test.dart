import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/analytics_service.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/bloc/movie_watchlist_status/movie_watchlist_status_bloc.dart';
import 'package:movie/presentation/bloc/movie_watchlist_status/movie_watchlist_status_event.dart';
import 'package:movie/presentation/bloc/movie_watchlist_status/movie_watchlist_status_state.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_watchlist_status_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
  AnalyticsService,
])
void main() {
  late MovieWatchlistStatusBloc movieWatchlistStatusBloc;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MockAnalyticsService mockAnalyticsService;

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockAnalyticsService = MockAnalyticsService();
    movieWatchlistStatusBloc = MovieWatchlistStatusBloc(
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
      analyticsService: mockAnalyticsService,
    );
  });

  const tId = 1;

  test('initialState should be initial MovieWatchlistStatusState', () {
    expect(movieWatchlistStatusBloc.state, MovieWatchlistStatusState.initial());
  });

  blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
    'Should emit updated isAddedToWatchlist when LoadMovieWatchlistStatus is called',
    build: () {
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
      return movieWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(const LoadMovieWatchlistStatus(tId)),
    expect: () => [
      const MovieWatchlistStatusState(isAddedToWatchlist: true, message: ''),
    ],
  );

  blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
    'Should emit updated message and status when AddMovieWatchlist is successful',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      when(mockAnalyticsService.logAddToWatchlist(
        contentType: 'movie',
        itemId: testMovieDetail.id.toString(),
        title: testMovieDetail.title,
      )).thenAnswer((_) async {});
      return movieWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(const AddMovieWatchlist(testMovieDetail)),
    expect: () => [
      const MovieWatchlistStatusState(
          isAddedToWatchlist: true, message: 'Added to Watchlist'),
    ],
    verify: (bloc) {
      verify(mockAnalyticsService.logAddToWatchlist(
        contentType: 'movie',
        itemId: testMovieDetail.id.toString(),
        title: testMovieDetail.title,
      ));
    },
  );

  blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
    'Should emit failure message when AddMovieWatchlist fails',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      return movieWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(const AddMovieWatchlist(testMovieDetail)),
    expect: () => [
      const MovieWatchlistStatusState(
          isAddedToWatchlist: false, message: 'Failed'),
    ],
  );

  blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
    'Should emit updated message and status when RemoveMovieWatchlist is successful',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      when(mockAnalyticsService.logRemoveFromWatchlist(
        contentType: 'movie',
        itemId: testMovieDetail.id.toString(),
        title: testMovieDetail.title,
      )).thenAnswer((_) async {});
      return movieWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(const RemoveMovieWatchlist(testMovieDetail)),
    expect: () => [
      const MovieWatchlistStatusState(
          isAddedToWatchlist: false, message: 'Removed from Watchlist'),
    ],
    verify: (bloc) {
      verify(mockAnalyticsService.logRemoveFromWatchlist(
        contentType: 'movie',
        itemId: testMovieDetail.id.toString(),
        title: testMovieDetail.title,
      ));
    },
  );

  blocTest<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
    'Should emit failure message when RemoveMovieWatchlist fails',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      return movieWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(const RemoveMovieWatchlist(testMovieDetail)),
    expect: () => [
      const MovieWatchlistStatusState(
          isAddedToWatchlist: false, message: 'Failed'),
    ],
  );
}
