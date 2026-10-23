import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_watchlist_tv.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_event.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_state.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTV])
void main() {
  late WatchlistTVBloc watchlistTVBloc;
  late MockGetWatchlistTV mockGetWatchlistTV;

  setUp(() {
    mockGetWatchlistTV = MockGetWatchlistTV();
    watchlistTVBloc = WatchlistTVBloc(mockGetWatchlistTV);
  });

  test('initialState should be WatchlistTVEmpty', () {
    expect(watchlistTVBloc.state, WatchlistTVEmpty());
  });

  blocTest<WatchlistTVBloc, WatchlistTVState>(
    'Should emit [WatchlistTVLoading, WatchlistTVLoaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTV.execute())
          .thenAnswer((_) async => Right([testWatchlistTV]));
      return watchlistTVBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTV()),
    expect: () => [
      WatchlistTVLoading(),
      const WatchlistTVLoaded([testWatchlistTV]),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTV.execute());
    },
  );

  blocTest<WatchlistTVBloc, WatchlistTVState>(
    'Should emit [WatchlistTVLoading, WatchlistTVError] when get data is unsuccessful',
    build: () {
      when(mockGetWatchlistTV.execute()).thenAnswer(
          (_) async => const Left(DatabaseFailure('Database Failure')));
      return watchlistTVBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTV()),
    expect: () => [
      WatchlistTVLoading(),
      const WatchlistTVError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTV.execute());
    },
  );
}
