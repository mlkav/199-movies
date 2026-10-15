import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTV])
void main() {
  late WatchlistTVNotifier notifier;
  late MockGetWatchlistTV mockGetWatchlistTV;

  setUp(() {
    mockGetWatchlistTV = MockGetWatchlistTV();
    notifier = WatchlistTVNotifier(getWatchlistTV: mockGetWatchlistTV);
  });

  test('should change state to Loading when usecase is called', () async {
    // arrange
    when(mockGetWatchlistTV.execute())
        .thenAnswer((_) async => Right([testWatchlistTV]));
    // act
    notifier.fetchWatchlistTV();
    // assert
    expect(notifier.watchlistState, RequestState.loading);
  });

  test('should change watchlist TV list when data is gotten successfully',
      () async {
    // arrange
    when(mockGetWatchlistTV.execute())
        .thenAnswer((_) async => Right([testWatchlistTV]));
    // act
    await notifier.fetchWatchlistTV();
    // assert
    expect(notifier.watchlistState, RequestState.loaded);
    expect(notifier.watchlistTV, [testWatchlistTV]);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetWatchlistTV.execute())
        .thenAnswer((_) async => const Left(DatabaseFailure('Database Failure')));
    // act
    await notifier.fetchWatchlistTV();
    // assert
    expect(notifier.watchlistState, RequestState.error);
    expect(notifier.message, 'Database Failure');
  });
}
