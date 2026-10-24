import 'package:core/common/analytics_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:movie/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:rxdart/rxdart.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;
  final AnalyticsService? analyticsService;

  MovieSearchBloc(this.searchMovies, {this.analyticsService})
      : super(MovieSearchEmpty()) {
    on<FetchMovieSearch>((event, emit) async {
      final query = event.query;
      if (query.isEmpty) {
        emit(MovieSearchEmpty());
        return;
      }

      emit(MovieSearchLoading());
      final result = await searchMovies.execute(query);
      result.fold(
        (failure) {
          emit(MovieSearchError(failure.message));
        },
        (data) {
          emit(MovieSearchLoaded(data));
          analyticsService?.logSearch(
            searchTerm: query,
            category: 'movie',
          );
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
