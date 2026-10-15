import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTV, GetPopularTV, GetTopRatedTV])
void main() {
  late TVListNotifier notifier;
  late MockGetNowPlayingTV mockGetNowPlayingTV;
  late MockGetPopularTV mockGetPopularTV;
  late MockGetTopRatedTV mockGetTopRatedTV;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTV = MockGetNowPlayingTV();
    mockGetPopularTV = MockGetPopularTV();
    mockGetTopRatedTV = MockGetTopRatedTV();
    notifier = TVListNotifier(
      getNowPlayingTV: mockGetNowPlayingTV,
      getPopularTV: mockGetPopularTV,
      getTopRatedTV: mockGetTopRatedTV,
    )..addListener(() {
        listenerCallCount++;
      });
  });

  final tTVList = <TV>[testTV];

  group('now playing TV', () {
    test('initialState should be Empty', () {
      expect(notifier.nowPlayingState, equals(RequestState.empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      await notifier.fetchNowPlayingTV();
      // assert
      verify(mockGetNowPlayingTV.execute());
    });

    test('should change state to Loading when usecase is called', () async {
      // arrange
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      notifier.fetchNowPlayingTV();
      // assert
      expect(notifier.nowPlayingState, RequestState.loading);
    });

    test('should change tv list when data is gotten successfully', () async {
      // arrange
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      await notifier.fetchNowPlayingTV();
      // assert
      expect(notifier.nowPlayingState, RequestState.loaded);
      expect(notifier.nowPlayingTV, tTVList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetNowPlayingTV.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await notifier.fetchNowPlayingTV();
      // assert
      expect(notifier.nowPlayingState, RequestState.error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular TV', () {
    test('should change state to Loading when usecase is called', () async {
      // arrange
      when(mockGetPopularTV.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      notifier.fetchPopularTV();
      // assert
      expect(notifier.popularTVState, RequestState.loading);
    });

    test('should change tv list when data is gotten successfully', () async {
      // arrange
      when(mockGetPopularTV.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      await notifier.fetchPopularTV();
      // assert
      expect(notifier.popularTVState, RequestState.loaded);
      expect(notifier.popularTV, tTVList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTV.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await notifier.fetchPopularTV();
      // assert
      expect(notifier.popularTVState, RequestState.error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated TV', () {
    test('should change state to Loading when usecase is called', () async {
      // arrange
      when(mockGetTopRatedTV.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      notifier.fetchTopRatedTV();
      // assert
      expect(notifier.topRatedTVState, RequestState.loading);
    });

    test('should change tv list when data is gotten successfully', () async {
      // arrange
      when(mockGetTopRatedTV.execute())
          .thenAnswer((_) async => Right(tTVList));
      // act
      await notifier.fetchTopRatedTV();
      // assert
      expect(notifier.topRatedTVState, RequestState.loaded);
      expect(notifier.topRatedTV, tTVList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTopRatedTV.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      // act
      await notifier.fetchTopRatedTV();
      // assert
      expect(notifier.topRatedTVState, RequestState.error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
