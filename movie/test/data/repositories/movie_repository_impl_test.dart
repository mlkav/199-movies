import 'dart:io';

import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie/data/models/genre_model.dart';
import 'package:movie/data/models/movie_detail_model.dart';
import 'package:movie/data/models/movie_model.dart';
import 'package:movie/data/repositories/movie_repository_impl.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_repository_impl_test.mocks.dart';

@GenerateMocks([MovieRemoteDataSource, MovieLocalDataSource])
void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tMovieModel = MovieModel(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  const tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovieModelList = <MovieModel>[tMovieModel];
  final tMovieList = <Movie>[tMovie];

  group('Now Playing Movies', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getNowPlayingMovies())
          .thenAnswer((_) async => tMovieModelList);

      final result = await repository.getNowPlayingMovies();

      verify(mockRemoteDataSource.getNowPlayingMovies());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getNowPlayingMovies())
          .thenThrow(ServerException());

      final result = await repository.getNowPlayingMovies();

      verify(mockRemoteDataSource.getNowPlayingMovies());
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when device is not connected to internet',
        () async {
      when(mockRemoteDataSource.getNowPlayingMovies())
          .thenThrow(const SocketException('Failed to connect to the network'));

      final result = await repository.getNowPlayingMovies();

      verify(mockRemoteDataSource.getNowPlayingMovies());
      expect(
          result,
          equals(const Left(
              ConnectionFailure('Failed to connect to the network'))));
    });

    test('should return SSL failure when SSL handshake fails', () async {
      when(mockRemoteDataSource.getNowPlayingMovies())
          .thenThrow(const HandshakeException('Handshake Failed'));

      final result = await repository.getNowPlayingMovies();

      expect(result,
          equals(const Left(SSLFailure('SSL Certificate Verification Failed'))));
    });

    test('should return SSL failure when TlsException occurs', () async {
      when(mockRemoteDataSource.getNowPlayingMovies())
          .thenThrow(const TlsException('TLS Failed'));

      final result = await repository.getNowPlayingMovies();

      expect(result,
          equals(const Left(SSLFailure('SSL Certificate Verification Failed'))));
    });

    test('should return ServerFailure on unknown exception', () async {
      when(mockRemoteDataSource.getNowPlayingMovies())
          .thenThrow(Exception('Unknown Error'));

      final result = await repository.getNowPlayingMovies();

      expect(result, isA<Left<Failure, List<Movie>>>());
    });
  });

  group('Popular Movies', () {
    test('should return movie list when call to data source is success',
        () async {
      when(mockRemoteDataSource.getPopularMovies())
          .thenAnswer((_) async => tMovieModelList);

      final result = await repository.getPopularMovies();

      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getPopularMovies())
          .thenThrow(ServerException());

      final result = await repository.getPopularMovies();

      expect(result, const Left(ServerFailure('')));
    });

    test('should return SSL failure when TlsException occurs', () async {
      when(mockRemoteDataSource.getPopularMovies())
          .thenThrow(const TlsException('TLS Failed'));

      final result = await repository.getPopularMovies();

      expect(result,
          equals(const Left(SSLFailure('SSL Certificate Verification Failed'))));
    });

    test('should return ServerFailure on unknown exception', () async {
      when(mockRemoteDataSource.getPopularMovies())
          .thenThrow(Exception('Unknown Error'));

      final result = await repository.getPopularMovies();

      expect(result, isA<Left<Failure, List<Movie>>>());
    });
  });

  group('Top Rated Movies', () {
    test('should return movie list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.getTopRatedMovies())
          .thenAnswer((_) async => tMovieModelList);

      final result = await repository.getTopRatedMovies();

      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getTopRatedMovies())
          .thenThrow(ServerException());

      final result = await repository.getTopRatedMovies();

      expect(result, const Left(ServerFailure('')));
    });

    test('should return SSL failure when TlsException occurs', () async {
      when(mockRemoteDataSource.getTopRatedMovies())
          .thenThrow(const TlsException('TLS Failed'));

      final result = await repository.getTopRatedMovies();

      expect(result,
          equals(const Left(SSLFailure('SSL Certificate Verification Failed'))));
    });

    test('should return ServerFailure on unknown exception', () async {
      when(mockRemoteDataSource.getTopRatedMovies())
          .thenThrow(Exception('Unknown Error'));

      final result = await repository.getTopRatedMovies();

      expect(result, isA<Left<Failure, List<Movie>>>());
    });
  });

  group('Get Movie Detail', () {
    const tId = 1;
    const tMovieResponse = MovieDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      budget: 100,
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      imdbId: 'imdb1',
      originalLanguage: 'en',
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      revenue: 12000,
      runtime: 120,
      status: 'Status',
      tagline: 'Tagline',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return Movie data when the call to remote data source is successful',
        () async {
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenAnswer((_) async => tMovieResponse);

      final result = await repository.getMovieDetail(tId);

      verify(mockRemoteDataSource.getMovieDetail(tId));
      expect(result, equals(const Right(testMovieDetail)));
    });

    test(
        'should return Server Failure when call to remote data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenThrow(ServerException());

      final result = await repository.getMovieDetail(tId);

      verify(mockRemoteDataSource.getMovieDetail(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('should return SSL failure when TlsException occurs', () async {
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenThrow(const TlsException('TLS Failed'));

      final result = await repository.getMovieDetail(tId);

      expect(result,
          equals(const Left(SSLFailure('SSL Certificate Verification Failed'))));
    });

    test('should return ServerFailure on unknown exception', () async {
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenThrow(Exception('Unknown Error'));

      final result = await repository.getMovieDetail(tId);

      expect(result, isA<Left<Failure, MovieDetail>>());
    });
  });

  group('Get Movie Recommendations', () {
    final tMovieList = <MovieModel>[];
    const tId = 1;

    test('should return data when call is successful', () async {
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenAnswer((_) async => tMovieList);

      final result = await repository.getMovieRecommendations(tId);

      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(<Movie>[]));
    });

    test('should return ServerFailure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(ServerException());

      final result = await repository.getMovieRecommendations(tId);

      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('should return SSL failure when TlsException occurs', () async {
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(const TlsException('TLS Failed'));

      final result = await repository.getMovieRecommendations(tId);

      expect(result,
          equals(const Left(SSLFailure('SSL Certificate Verification Failed'))));
    });

    test('should return ServerFailure on unknown exception', () async {
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(Exception('Unknown Error'));

      final result = await repository.getMovieRecommendations(tId);

      expect(result, isA<Left<Failure, List<Movie>>>());
    });
  });

  group('Seach Movies', () {
    const tQuery = 'spiderman';

    test('should return movie list when call to data source is successful',
        () async {
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenAnswer((_) async => tMovieModelList);

      final result = await repository.searchMovies(tQuery);

      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenThrow(ServerException());

      final result = await repository.searchMovies(tQuery);

      expect(result, const Left(ServerFailure('')));
    });

    test('should return SSL failure when TlsException occurs', () async {
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenThrow(const TlsException('TLS Failed'));

      final result = await repository.searchMovies(tQuery);

      expect(result,
          equals(const Left(SSLFailure('SSL Certificate Verification Failed'))));
    });

    test('should return ServerFailure on unknown exception', () async {
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenThrow(Exception('Unknown Error'));

      final result = await repository.searchMovies(tQuery);

      expect(result, isA<Left<Failure, List<Movie>>>());
    });
  });

  group('save watchlist', () {
    test('should return success message when saving succeeds', () async {
      when(mockLocalDataSource.insertWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlist(testMovieDetail);

      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving fails', () async {
      when(mockLocalDataSource.insertWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));

      final result = await repository.saveWatchlist(testMovieDetail);

      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove succeeds', () async {
      when(mockLocalDataSource.removeWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Removed from Watchlist');

      final result = await repository.removeWatchlist(testMovieDetail);

      expect(result, const Right('Removed from Watchlist'));
    });

    test('should return DatabaseFailure when remove fails', () async {
      when(mockLocalDataSource.removeWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));

      final result = await repository.removeWatchlist(testMovieDetail);

      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      const tId = 1;
      when(mockLocalDataSource.getMovieById(tId))
          .thenAnswer((_) async => testMovieTable);

      final result = await repository.isAddedToWatchlist(tId);

      expect(result, true);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies from local data source', () async {
      when(mockLocalDataSource.getWatchlistMovies())
          .thenAnswer((_) async => [testMovieTable]);

      final result = await repository.getWatchlistMovies();

      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistMovie]);
    });
  });
}
