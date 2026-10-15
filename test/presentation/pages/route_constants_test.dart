import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_search_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all routeName constants should be accessible', () {
    expect(AboutPage.routeName, isNotEmpty);
    expect(HomeMoviePage.routeName, isNotEmpty);
    expect(HomeTVPage.routeName, isNotEmpty);
    expect(MovieDetailPage.routeName, isNotEmpty);
    expect(NowPlayingTVPage.routeName, isNotEmpty);
    expect(PopularMoviesPage.routeName, isNotEmpty);
    expect(PopularTVPage.routeName, isNotEmpty);
    expect(SearchPage.routeName, isNotEmpty);
    expect(TopRatedMoviesPage.routeName, isNotEmpty);
    expect(TopRatedTVPage.routeName, isNotEmpty);
    expect(TVDetailPage.routeName, isNotEmpty);
    expect(TVSearchPage.routeName, isNotEmpty);
    expect(WatchlistMoviesPage.routeName, isNotEmpty);
    expect(WatchlistTVPage.routeName, isNotEmpty);
  });
}
