import 'dart:io';

import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/data/models/genre_model.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/data/models/season_detail_model.dart';
import 'package:tv/data/models/season_model.dart';
import 'package:tv/data/models/tv_detail_model.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/repositories/tv_repository_impl.dart';
import 'package:tv/domain/entities/season_detail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_repository_impl_test.mocks.dart';

@GenerateMocks([TVRemoteDataSource, TVLocalDataSource])
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

  const tTVModel = TVModel(
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

  const tTV = TV(
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

  group('Now Playing TV', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getNowPlayingTV())
          .thenAnswer((_) async => tTVModelList);

      final result = await repository.getNowPlayingTV();

      verify(mockRemoteDataSource.getNowPlayingTV());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getNowPlayingTV()).thenThrow(ServerException());

      final result = await repository.getNowPlayingTV();

      verify(mockRemoteDataSource.getNowPlayingTV());
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when device is not connected to internet',
        () async {
      when(mockRemoteDataSource.getNowPlayingTV())
          .thenThrow(const SocketException('Failed to connect to the network'));

      final result = await repository.getNowPlayingTV();

      verify(mockRemoteDataSource.getNowPlayingTV());
      expect(
          result,
          equals(const Left(
              ConnectionFailure('Failed to connect to the network'))));
    });

    test('should return SSL failure when SSL handshake fails', () async {
      when(mockRemoteDataSource.getNowPlayingTV())
          .thenThrow(const HandshakeException('Handshake Failed'));

      final result = await repository.getNowPlayingTV();

      expect(
          result,
          equals(
              const Left(SSLFailure('SSL Certificate Verification Failed'))));
    });

    test('should return SSL failure when TlsException occurs', () async {
      when(mockRemoteDataSource.getNowPlayingTV())
          .thenThrow(const TlsException('TLS Failed'));

      final result = await repository.getNowPlayingTV();

      expect(
          result,
          equals(
              const Left(SSLFailure('SSL Certificate Verification Failed'))));
    });

    test('should return ServerFailure on unknown exception', () async {
      when(mockRemoteDataSource.getNowPlayingTV())
          .thenThrow(Exception('Unknown Error'));

      final result = await repository.getNowPlayingTV();

      expect(result, isA<Left<Failure, List<TV>>>());
    });
  });

  group('Popular TV', () {
    test('should return TV list when call to data source is success', () async {
      when(mockRemoteDataSource.getPopularTV())
          .thenAnswer((_) async => tTVModelList);

      final result = await repository.getPopularTV();

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getPopularTV()).thenThrow(ServerException());

      final result = await repository.getPopularTV();

      expect(result, const Left(ServerFailure('')));
    });

    test('should return SSL failure when TlsException occurs', () async {
      when(mockRemoteDataSource.getPopularTV())
          .thenThrow(const TlsException('TLS Failed'));

      final result = await repository.getPopularTV();

      expect(
          result,
          equals(
              const Left(SSLFailure('SSL Certificate Verification Failed'))));
    });

    test('should return ServerFailure on unknown exception', () async {
      when(mockRemoteDataSource.getPopularTV())
          .thenThrow(Exception('Unknown Error'));

      final result = await repository.getPopularTV();

      expect(result, isA<Left<Failure, List<TV>>>());
    });
  });

  group('Top Rated TV', () {
    test('should return TV list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.getTopRatedTV())
          .thenAnswer((_) async => tTVModelList);

      final result = await repository.getTopRatedTV();

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTopRatedTV()).thenThrow(ServerException());

      final result = await repository.getTopRatedTV();

      expect(result, const Left(ServerFailure('')));
    });

    test('should return SSL failure when TlsException occurs', () async {
      when(mockRemoteDataSource.getTopRatedTV())
          .thenThrow(const TlsException('TLS Failed'));

      final result = await repository.getTopRatedTV();

      expect(
          result,
          equals(
              const Left(SSLFailure('SSL Certificate Verification Failed'))));
    });

    test('should return ServerFailure on unknown exception', () async {
      when(mockRemoteDataSource.getTopRatedTV())
          .thenThrow(Exception('Unknown Error'));

      final result = await repository.getTopRatedTV();

      expect(result, isA<Left<Failure, List<TV>>>());
    });
  });

  group('Get TV Detail', () {
    const tId = 1;
    const tTVResponse = TVDetailResponse(
      adult: false,
      backdropPath: '/path.jpg',
      firstAirDate: '2021-01-01',
      genres: [GenreModel(id: 1, name: 'Action')],
      id: 1,
      name: 'Name',
      numberOfEpisodes: 10,
      numberOfSeasons: 1,
      originalName: 'Original Name',
      overview: 'Overview',
      posterPath: '/path.jpg',
      seasons: [
        SeasonModel(
          airDate: '2021-01-01',
          episodeCount: 10,
          id: 1,
          name: 'Season 1',
          overview: 'Overview',
          posterPath: '/path.jpg',
          seasonNumber: 1,
        )
      ],
      voteAverage: 1.0,
      voteCount: 1,
    );

    test(
        'should return TV data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getTVDetail(tId))
          .thenAnswer((_) async => tTVResponse);

      final result = await repository.getTVDetail(tId);

      verify(mockRemoteDataSource.getTVDetail(tId));
      expect(result, equals(const Right(testTVDetail)));
    });

    test(
        'should return Server Failure when call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTVDetail(tId)).thenThrow(ServerException());

      final result = await repository.getTVDetail(tId);

      verify(mockRemoteDataSource.getTVDetail(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('should return SSL failure when TlsException occurs', () async {
      when(mockRemoteDataSource.getTVDetail(tId))
          .thenThrow(const TlsException('TLS Failed'));

      final result = await repository.getTVDetail(tId);

      expect(
          result,
          equals(
              const Left(SSLFailure('SSL Certificate Verification Failed'))));
    });

    test('should return ServerFailure on unknown exception', () async {
      when(mockRemoteDataSource.getTVDetail(tId))
          .thenThrow(Exception('Unknown Error'));

      final result = await repository.getTVDetail(tId);

      expect(result, isA<Left<Failure, TVDetail>>());
    });
  });

  group('Get TV Season Detail', () {
    const tTvId = 1;
    const tSeasonNumber = 1;
    const tSeasonDetailResponse = SeasonDetailResponse(
      airDate: '2021-01-01',
      episodes: [],
      id: 1,
      name: 'Season 1',
      overview: 'Overview',
      posterPath: '/path.jpg',
      seasonNumber: 1,
    );

    test('should return season detail when call is successful', () async {
      when(mockRemoteDataSource.getTVSeasonDetail(tTvId, tSeasonNumber))
          .thenAnswer((_) async => tSeasonDetailResponse);

      final result = await repository.getTVSeasonDetail(tTvId, tSeasonNumber);

      verify(mockRemoteDataSource.getTVSeasonDetail(tTvId, tSeasonNumber));
      expect(result, isA<Right<Failure, SeasonDetail>>());
    });

    test('should return ServerFailure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getTVSeasonDetail(tTvId, tSeasonNumber))
          .thenThrow(ServerException());

      final result = await repository.getTVSeasonDetail(tTvId, tSeasonNumber);

      expect(result, equals(const Left(ServerFailure(''))));
    });
  });

  group('Get TV Recommendations', () {
    final tTVList = <TVModel>[];
    const tId = 1;

    test('should return data when call is successful', () async {
      when(mockRemoteDataSource.getTVRecommendations(tId))
          .thenAnswer((_) async => tTVList);

      final result = await repository.getTVRecommendations(tId);

      verify(mockRemoteDataSource.getTVRecommendations(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(<TV>[]));
    });

    test('should return ServerFailure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getTVRecommendations(tId))
          .thenThrow(ServerException());

      final result = await repository.getTVRecommendations(tId);

      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('should return SSL failure when TlsException occurs', () async {
      when(mockRemoteDataSource.getTVRecommendations(tId))
          .thenThrow(const TlsException('TLS Failed'));

      final result = await repository.getTVRecommendations(tId);

      expect(
          result,
          equals(
              const Left(SSLFailure('SSL Certificate Verification Failed'))));
    });

    test('should return ServerFailure on unknown exception', () async {
      when(mockRemoteDataSource.getTVRecommendations(tId))
          .thenThrow(Exception('Unknown Error'));

      final result = await repository.getTVRecommendations(tId);

      expect(result, isA<Left<Failure, List<TV>>>());
    });
  });

  group('Search TV', () {
    const tQuery = 'Game of Thrones';

    test('should return TV list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.searchTV(tQuery))
          .thenAnswer((_) async => tTVModelList);

      final result = await repository.searchTV(tQuery);

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTVList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.searchTV(tQuery)).thenThrow(ServerException());

      final result = await repository.searchTV(tQuery);

      expect(result, const Left(ServerFailure('')));
    });

    test('should return SSL failure when TlsException occurs', () async {
      when(mockRemoteDataSource.searchTV(tQuery))
          .thenThrow(const TlsException('TLS Failed'));

      final result = await repository.searchTV(tQuery);

      expect(
          result,
          equals(
              const Left(SSLFailure('SSL Certificate Verification Failed'))));
    });

    test('should return ServerFailure on unknown exception', () async {
      when(mockRemoteDataSource.searchTV(tQuery))
          .thenThrow(Exception('Unknown Error'));

      final result = await repository.searchTV(tQuery);

      expect(result, isA<Left<Failure, List<TV>>>());
    });
  });

  group('save watchlist', () {
    test('should return success message when saving succeeds', () async {
      when(mockLocalDataSource.insertWatchlist(testTVTable))
          .thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlistTV(testTVDetail);

      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving fails', () async {
      when(mockLocalDataSource.insertWatchlist(testTVTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));

      final result = await repository.saveWatchlistTV(testTVDetail);

      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove succeeds', () async {
      when(mockLocalDataSource.removeWatchlist(testTVTable))
          .thenAnswer((_) async => 'Removed from Watchlist');

      final result = await repository.removeWatchlistTV(testTVDetail);

      expect(result, const Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure when remove fails', () async {
      when(mockLocalDataSource.removeWatchlist(testTVTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));

      final result = await repository.removeWatchlistTV(testTVDetail);

      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      const tId = 1;
      when(mockLocalDataSource.getTVById(tId))
          .thenAnswer((_) async => testTVTable);

      final result = await repository.isAddedToWatchlistTV(tId);

      expect(result, true);
    });
  });

  group('get watchlist TV', () {
    test('should return list of TV from local data source', () async {
      when(mockLocalDataSource.getWatchlistTV())
          .thenAnswer((_) async => [testTVTable]);

      final result = await repository.getWatchlistTV();

      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTV]);
    });
  });
}
