import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

final locator = GetIt.instance;

void init() {
  // Helper / Service
  locator.registerLazySingleton(() => AnalyticsService());

  // BLoC / Cubit - Movie
  locator.registerFactory(
    () => NowPlayingMoviesBloc(locator()),
  );
  locator.registerFactory(
    () => PopularMoviesBloc(locator()),
  );
  locator.registerFactory(
    () => TopRatedMoviesBloc(locator()),
  );
  locator.registerFactory(
    () => MovieDetailBloc(
      locator(),
      analyticsService: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieRecommendationsBloc(locator()),
  );
  locator.registerFactory(
    () => MovieWatchlistStatusBloc(
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
      analyticsService: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieBloc(locator()),
  );
  locator.registerFactory(
    () => MovieSearchBloc(
      locator(),
      analyticsService: locator(),
    ),
  );

  // BLoC / Cubit - TV Series
  locator.registerFactory(
    () => NowPlayingTVBloc(locator()),
  );
  locator.registerFactory(
    () => PopularTVBloc(locator()),
  );
  locator.registerFactory(
    () => TopRatedTVBloc(getTopRatedTV: locator()),
  );
  locator.registerFactory(
    () => TVDetailBloc(
      locator(),
      analyticsService: locator(),
    ),
  );
  locator.registerFactory(
    () => TVRecommendationsBloc(locator()),
  );
  locator.registerFactory(
    () => TVSeasonDetailBloc(locator()),
  );
  locator.registerFactory(
    () => TVWatchlistStatusBloc(
      getWatchListTVStatus: locator(),
      saveWatchlistTV: locator(),
      removeWatchlistTV: locator(),
      analyticsService: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTVBloc(locator()),
  );
  locator.registerFactory(
    () => TVSearchBloc(
      locator(),
      analyticsService: locator(),
    ),
  );

  // Use cases - Movie
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // Use cases - TV
  locator.registerLazySingleton(() => GetNowPlayingTV(locator()));
  locator.registerLazySingleton(() => GetPopularTV(locator()));
  locator.registerLazySingleton(() => GetTopRatedTV(repository: locator()));
  locator.registerLazySingleton(() => GetTVDetail(locator()));
  locator.registerLazySingleton(() => GetTVRecommendations(locator()));
  locator.registerLazySingleton(() => GetTVSeasonDetail(locator()));
  locator.registerLazySingleton(() => SearchTV(locator()));
  locator.registerLazySingleton(() => GetWatchListTVStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTV(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTV(locator()));
  locator.registerLazySingleton(() => GetWatchlistTV(locator()));

  // Repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TVRepository>(
    () => TVRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // Data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<TVRemoteDataSource>(
    () => TVRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TVLocalDataSource>(
    () => TVLocalDataSourceImpl(databaseHelper: locator()),
  );

  // Helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // External (SSL Pinning Client)
  locator.registerLazySingleton(() => HttpSSLPinning.client);
}
