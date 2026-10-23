import 'package:flutter_test/flutter_test.dart';
import 'package:tv/presentation/bloc/now_playing_tv/now_playing_tv_event.dart';
import 'package:tv/presentation/bloc/now_playing_tv/now_playing_tv_state.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_event.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_state.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_event.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_state.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_event.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_state.dart';
import 'package:tv/presentation/bloc/tv_recommendations/tv_recommendations_event.dart';
import 'package:tv/presentation/bloc/tv_recommendations/tv_recommendations_state.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_event.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_state.dart';
import 'package:tv/presentation/bloc/tv_season_detail/tv_season_detail_event.dart';
import 'package:tv/presentation/bloc/tv_season_detail/tv_season_detail_state.dart';
import 'package:tv/presentation/bloc/tv_watchlist_status/tv_watchlist_status_event.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_event.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_state.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('TV Events and States props coverage', () {
    expect(FetchNowPlayingTV().props, []);
    expect(NowPlayingTVEmpty().props, []);
    expect(NowPlayingTVLoading().props, []);

    expect(FetchPopularTV().props, []);
    expect(PopularTVEmpty().props, []);
    expect(PopularTVLoading().props, []);

    expect(FetchTopRatedTV().props, []);
    expect(TopRatedTVEmpty().props, []);
    expect(TopRatedTVLoading().props, []);

    expect(const FetchTVDetail(1).props, [1]);
    expect(TVDetailEmpty().props, []);
    expect(TVDetailLoading().props, []);

    expect(const FetchTVRecommendations(1).props, [1]);
    expect(TVRecommendationsEmpty().props, []);
    expect(TVRecommendationsLoading().props, []);

    expect(const FetchTVSeasonDetail(1, 1).props, [1, 1]);
    expect(TVSeasonDetailEmpty().props, []);
    expect(TVSeasonDetailLoading().props, []);

    expect(const LoadTVWatchlistStatus(1).props, [1]);
    expect(const AddTVWatchlist(testTVDetail).props, [testTVDetail]);
    expect(const RemoveTVWatchlist(testTVDetail).props, [testTVDetail]);

    expect(FetchWatchlistTV().props, []);
    expect(WatchlistTVEmpty().props, []);
    expect(WatchlistTVLoading().props, []);

    expect(const FetchTVSearch('got').props, ['got']);
    expect(TVSearchEmpty().props, []);
    expect(TVSearchLoading().props, []);
  });
}
