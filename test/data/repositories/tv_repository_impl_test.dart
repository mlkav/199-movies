import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_season_model.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVRepositoryImpl repository;
  late MockTVRemoteDataSource mockRemoteDataSource;
  late MockTVLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVRemoteDataSource();
    mockLocalDataSource = MockTVLocalDataSource();
    repository = TVRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTVModel = TVModel(
    backdropPath: '/path.jpg',
    firstAirDate: '2021-01-01',
    genreIds: [1, 2],
    id: 1,
    name: 'Name',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTV = TV(
    backdropPath: '/path.jpg',
    firstAirDate: '2021-01-01',
    genreIds: [1, 2],
    id: 1,
    name: 'Name',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTVModelList = <TVModel>[tTVModel];
  final tTVList = <TV>[tTV];

  group('Now Playing TV Series (On The Air)', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTV())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getNowPlayingTV();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTV());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTV()).thenThrow(ServerException());
      // act
      final result = await repository.getNowPlayingTV();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTV());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getNowPlayingTV())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getNowPlayingTV();
      // assert
      verify(mockRemoteDataSource.getNowPlayingTV());
      expect(
          result,
          equals(
              Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular TV Series', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTV())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getPopularTV();
      // assert
      verify(mockRemoteDataSource.getPopularTV());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTV()).thenThrow(ServerException());
      // act
      final result = await repository.getPopularTV();
      // assert
      verify(mockRemoteDataSource.getPopularTV());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTV())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularTV();
      // assert
      verify(mockRemoteDataSource.getPopularTV());
      expect(
          result,
          equals(
              Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Top Rated TV Series', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTV())
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getTopRatedTV();
      // assert
      verify(mockRemoteDataSource.getTopRatedTV());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTV()).thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTV();
      // assert
      verify(mockRemoteDataSource.getTopRatedTV());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTV())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedTV();
      // assert
      verify(mockRemoteDataSource.getTopRatedTV());
      expect(
          result,
          equals(
              Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get TV Detail', () {
    final tId = 1;
    final tTVResponse = TVDetailResponse(
      adult: false,
      backdropPath: '/path.jpg',
      firstAirDate: '2021-01-01',
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: 'https://google.com',
      id: 1,
      name: 'Name',
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      originalLanguage: 'en',
      originalName: 'Original Name',
      overview: 'Overview',
      popularity: 1.0,
      posterPath: '/path.jpg',
      seasons: [
        TVSeasonModel(
          airDate: '2021-01-01',
          episodeCount: 10,
          id: 1,
          name: 'Season 1',
          overview: 'Overview',
          posterPath: '/path.jpg',
          seasonNumber: 1,
        )
      ],
      status: 'Status',
      tagline: 'Tagline',
      type: 'Scripted',
      voteAverage: 1.0,
      voteCount: 1,
    );

    test(
        'should return TV Detail data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVDetail(tId))
          .thenAnswer((_) async => tTVResponse);
      // act
      final result = await repository.getTVDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTVDetail(tId));
      expect(result, equals(Right(testTVDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVDetail(tId)).thenThrow(ServerException());
      // act
      final result = await repository.getTVDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTVDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTVDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTVDetail(tId));
      expect(
          result,
          equals(
              Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get TV Recommendations', () {
    final tId = 1;

    test('should return data (TV list) when the call is successful', () async {
      // arrange
      when(mockRemoteDataSource.getTVRecommendations(tId))
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.getTVRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTVRecommendations(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return server failure when call to remote source fails',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTVRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTVRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTVRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTVRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTVRecommendations(tId));
      expect(
          result,
          equals(
              Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Search TV Series', () {
    final tQuery = 'Game of Thrones';

    test('should return TV list when call to remote source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTV(tQuery))
          .thenAnswer((_) async => tTVModelList);
      // act
      final result = await repository.searchTV(tQuery);
      // assert
      verify(mockRemoteDataSource.searchTV(tQuery));
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return Server Failure when call to remote source fails',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTV(tQuery)).thenThrow(ServerException());
      // act
      final result = await repository.searchTV(tQuery);
      // assert
      verify(mockRemoteDataSource.searchTV(tQuery));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return Connection Failure when device is not connected',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTV(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTV(tQuery);
      // assert
      verify(mockRemoteDataSource.searchTV(tQuery));
      expect(
          result,
          equals(
              Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Save Watchlist', () {
    test('should return success message when saving succeeds', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTVTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlistTV(testTVDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving fails', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testTVTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlistTV(testTVDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('Remove Watchlist', () {
    test('should return success message when removing succeeds', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTVTable))
          .thenAnswer((_) async => 'Removed from Watchlist');
      // act
      final result = await repository.removeWatchlistTV(testTVDetail);
      // assert
      expect(result, Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure when removing fails', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testTVTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlistTV(testTVDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('Get Watchlist Status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getTVById(tId))
          .thenAnswer((_) async => testTVTable);
      // act
      final result = await repository.isAddedToWatchlistTV(tId);
      // assert
      expect(result, true);
    });
  });

  group('Get Watchlist TV Series', () {
    test('should return list of TV Series from local source', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTV())
          .thenAnswer((_) async => [testTVTable]);
      // act
      final result = await repository.getWatchlistTV();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTV]);
    });
  });
}
