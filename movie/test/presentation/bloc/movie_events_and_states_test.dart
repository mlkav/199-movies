import 'package:flutter_test/flutter_test.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:movie/presentation/bloc/movie_recommendations/movie_recommendations_event.dart';
import 'package:movie/presentation/bloc/movie_recommendations/movie_recommendations_state.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:movie/presentation/bloc/movie_watchlist_status/movie_watchlist_status_event.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_event.dart';
import 'package:movie/presentation/bloc/now_playing_movies/now_playing_movies_state.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_event.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_state.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_event.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_state.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_event.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_state.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('Movie Events and States props coverage', () {
    expect(FetchNowPlayingMovies().props, []);
    expect(NowPlayingMoviesEmpty().props, []);
    expect(NowPlayingMoviesLoading().props, []);

    expect(FetchPopularMovies().props, []);
    expect(PopularMoviesEmpty().props, []);
    expect(PopularMoviesLoading().props, []);

    expect(FetchTopRatedMovies().props, []);
    expect(TopRatedMoviesEmpty().props, []);
    expect(TopRatedMoviesLoading().props, []);

    expect(const FetchMovieDetail(1).props, [1]);
    expect(MovieDetailEmpty().props, []);
    expect(MovieDetailLoading().props, []);

    expect(const FetchMovieRecommendations(1).props, [1]);
    expect(MovieRecommendationsEmpty().props, []);
    expect(MovieRecommendationsLoading().props, []);

    expect(const LoadMovieWatchlistStatus(1).props, [1]);
    expect(const AddMovieWatchlist(testMovieDetail).props, [testMovieDetail]);
    expect(
        const RemoveMovieWatchlist(testMovieDetail).props, [testMovieDetail]);

    expect(FetchWatchlistMovies().props, []);
    expect(WatchlistMovieEmpty().props, []);
    expect(WatchlistMovieLoading().props, []);

    expect(const FetchMovieSearch('spiderman').props, ['spiderman']);
    expect(MovieSearchEmpty().props, []);
    expect(MovieSearchLoading().props, []);
  });
}
