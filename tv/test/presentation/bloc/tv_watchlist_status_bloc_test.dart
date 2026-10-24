import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/analytics_service.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/presentation/bloc/tv_watchlist_status/tv_watchlist_status_bloc.dart';
import 'package:tv/presentation/bloc/tv_watchlist_status/tv_watchlist_status_event.dart';
import 'package:tv/presentation/bloc/tv_watchlist_status/tv_watchlist_status_state.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_watchlist_status_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchListTVStatus,
  SaveWatchlistTV,
  RemoveWatchlistTV,
  AnalyticsService,
])
void main() {
  late TVWatchlistStatusBloc tvWatchlistStatusBloc;
  late MockGetWatchListTVStatus mockGetWatchListTVStatus;
  late MockSaveWatchlistTV mockSaveWatchlistTV;
  late MockRemoveWatchlistTV mockRemoveWatchlistTV;
  late MockAnalyticsService mockAnalyticsService;

  setUp(() {
    mockGetWatchListTVStatus = MockGetWatchListTVStatus();
    mockSaveWatchlistTV = MockSaveWatchlistTV();
    mockRemoveWatchlistTV = MockRemoveWatchlistTV();
    mockAnalyticsService = MockAnalyticsService();
    tvWatchlistStatusBloc = TVWatchlistStatusBloc(
      getWatchListTVStatus: mockGetWatchListTVStatus,
      saveWatchlistTV: mockSaveWatchlistTV,
      removeWatchlistTV: mockRemoveWatchlistTV,
      analyticsService: mockAnalyticsService,
    );
  });

  const tId = 1;

  test('initialState should be initial TVWatchlistStatusState', () {
    expect(tvWatchlistStatusBloc.state, TVWatchlistStatusState.initial());
  });

  blocTest<TVWatchlistStatusBloc, TVWatchlistStatusState>(
    'Should emit updated isAddedToWatchlist when LoadTVWatchlistStatus is called',
    build: () {
      when(mockGetWatchListTVStatus.execute(tId)).thenAnswer((_) async => true);
      return tvWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(const LoadTVWatchlistStatus(tId)),
    expect: () => [
      const TVWatchlistStatusState(isAddedToWatchlist: true, message: ''),
    ],
  );

  blocTest<TVWatchlistStatusBloc, TVWatchlistStatusState>(
    'Should emit updated message and status when AddTVWatchlist is successful',
    build: () {
      when(mockSaveWatchlistTV.execute(testTVDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockGetWatchListTVStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => true);
      when(mockAnalyticsService.logAddToWatchlist(
        contentType: 'tv',
        itemId: testTVDetail.id.toString(),
        title: testTVDetail.name,
      )).thenAnswer((_) async {});
      return tvWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(const AddTVWatchlist(testTVDetail)),
    expect: () => [
      const TVWatchlistStatusState(
          isAddedToWatchlist: true, message: 'Added to Watchlist'),
    ],
    verify: (bloc) {
      verify(mockAnalyticsService.logAddToWatchlist(
        contentType: 'tv',
        itemId: testTVDetail.id.toString(),
        title: testTVDetail.name,
      ));
    },
  );

  blocTest<TVWatchlistStatusBloc, TVWatchlistStatusState>(
    'Should emit failure message when AddTVWatchlist fails',
    build: () {
      when(mockSaveWatchlistTV.execute(testTVDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      return tvWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(const AddTVWatchlist(testTVDetail)),
    expect: () => [
      const TVWatchlistStatusState(
          isAddedToWatchlist: false, message: 'Failed'),
    ],
  );

  blocTest<TVWatchlistStatusBloc, TVWatchlistStatusState>(
    'Should emit updated message and status when RemoveTVWatchlist is successful',
    build: () {
      when(mockRemoveWatchlistTV.execute(testTVDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockGetWatchListTVStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => false);
      when(mockAnalyticsService.logRemoveFromWatchlist(
        contentType: 'tv',
        itemId: testTVDetail.id.toString(),
        title: testTVDetail.name,
      )).thenAnswer((_) async {});
      return tvWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(const RemoveTVWatchlist(testTVDetail)),
    expect: () => [
      const TVWatchlistStatusState(
          isAddedToWatchlist: false, message: 'Removed from Watchlist'),
    ],
    verify: (bloc) {
      verify(mockAnalyticsService.logRemoveFromWatchlist(
        contentType: 'tv',
        itemId: testTVDetail.id.toString(),
        title: testTVDetail.name,
      ));
    },
  );

  blocTest<TVWatchlistStatusBloc, TVWatchlistStatusState>(
    'Should emit failure message when RemoveTVWatchlist fails',
    build: () {
      when(mockRemoveWatchlistTV.execute(testTVDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      return tvWatchlistStatusBloc;
    },
    act: (bloc) => bloc.add(const RemoveTVWatchlist(testTVDetail)),
    expect: () => [
      const TVWatchlistStatusState(
          isAddedToWatchlist: false, message: 'Failed'),
    ],
  );
}
