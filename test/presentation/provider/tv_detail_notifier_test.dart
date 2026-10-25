import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  GetWatchListTVStatus,
  SaveWatchlistTV,
  RemoveWatchlistTV,
])
void main() {
  late TVDetailNotifier notifier;
  late MockGetTVDetail mockGetTVDetail;
  late MockGetTVRecommendations mockGetTVRecommendations;
  late MockGetWatchListTVStatus mockGetWatchListTVStatus;
  late MockSaveWatchlistTV mockSaveWatchlistTV;
  late MockRemoveWatchlistTV mockRemoveWatchlistTV;

  setUp(() {
    mockGetTVDetail = MockGetTVDetail();
    mockGetTVRecommendations = MockGetTVRecommendations();
    mockGetWatchListTVStatus = MockGetWatchListTVStatus();
    mockSaveWatchlistTV = MockSaveWatchlistTV();
    mockRemoveWatchlistTV = MockRemoveWatchlistTV();
    notifier = TVDetailNotifier(
      getTVDetail: mockGetTVDetail,
      getTVRecommendations: mockGetTVRecommendations,
      getWatchListTVStatus: mockGetWatchListTVStatus,
      saveWatchlistTV: mockSaveWatchlistTV,
      removeWatchlistTV: mockRemoveWatchlistTV,
    );
  });

  const tId = 1;
  final tTVList = <TV>[testTV];

  group('Get TV Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      when(mockGetTVDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVDetail));
      when(mockGetTVRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTVList));
      // act
      await notifier.fetchTVDetail(tId);
      // assert
      verify(mockGetTVDetail.execute(tId));
      verify(mockGetTVRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () async {
      // arrange
      when(mockGetTVDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVDetail));
      when(mockGetTVRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTVList));
      // act
      notifier.fetchTVDetail(tId);
      // assert
      expect(notifier.tvState, RequestState.loading);
    });

    test('should change tv when data is gotten successfully', () async {
      // arrange
      when(mockGetTVDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVDetail));
      when(mockGetTVRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTVList));
      // act
      await notifier.fetchTVDetail(tId);
      // assert
      expect(notifier.tvState, RequestState.loaded);
      expect(notifier.tv, testTVDetail);
    });

    test('should change recommendation tvs when data is gotten successfully',
        () async {
      // arrange
      when(mockGetTVDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVDetail));
      when(mockGetTVRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTVList));
      // act
      await notifier.fetchTVDetail(tId);
      // assert
      expect(notifier.tvState, RequestState.loaded);
      expect(notifier.tvRecommendations, tTVList);
    });

    test('should return error when tv detail is unsuccessful', () async {
      // arrange
      when(mockGetTVDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(mockGetTVRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTVList));
      // act
      await notifier.fetchTVDetail(tId);
      // assert
      expect(notifier.tvState, RequestState.error);
      expect(notifier.message, 'Server Failure');
    });

    test('should return error when recommendations is unsuccessful', () async {
      // arrange
      when(mockGetTVDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVDetail));
      when(mockGetTVRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await notifier.fetchTVDetail(tId);
      // assert
      expect(notifier.recommendationState, RequestState.error);
      expect(notifier.message, 'Server Failure');
    });
  });

  group('Watchlist Operations', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchListTVStatus.execute(tId))
          .thenAnswer((_) async => true);
      // act
      await notifier.loadWatchlistStatus(tId);
      // assert
      expect(notifier.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlistTV.execute(testTVDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockGetWatchListTVStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => true);
      // act
      await notifier.addWatchlist(testTVDetail);
      // assert
      verify(mockSaveWatchlistTV.execute(testTVDetail));
      expect(notifier.watchlistMessage, 'Added to Watchlist');
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlistTV.execute(testTVDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockGetWatchListTVStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => false);
      // act
      await notifier.removeFromWatchlist(testTVDetail);
      // assert
      verify(mockRemoveWatchlistTV.execute(testTVDetail));
      expect(notifier.watchlistMessage, 'Removed from Watchlist');
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlistTV.execute(testTVDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchListTVStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => false);
      // act
      await notifier.addWatchlist(testTVDetail);
      // assert
      expect(notifier.watchlistMessage, 'Failed');
    });

    test('should update watchlist message when remove watchlist failed',
        () async {
      // arrange
      when(mockRemoveWatchlistTV.execute(testTVDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchListTVStatus.execute(testTVDetail.id))
          .thenAnswer((_) async => true);
      // act
      await notifier.removeFromWatchlist(testTVDetail);
      // assert
      expect(notifier.watchlistMessage, 'Failed');
    });
  });
}
