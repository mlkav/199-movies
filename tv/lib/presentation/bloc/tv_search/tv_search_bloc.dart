import 'package:core/common/analytics_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tv/domain/usecases/search_tv.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_event.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_state.dart';

class TVSearchBloc extends Bloc<TVSearchEvent, TVSearchState> {
  final SearchTV searchTV;
  final AnalyticsService? analyticsService;

  TVSearchBloc(this.searchTV, {this.analyticsService})
      : super(TVSearchEmpty()) {
    on<FetchTVSearch>((event, emit) async {
      final query = event.query;
      if (query.isEmpty) {
        emit(TVSearchEmpty());
        return;
      }

      emit(TVSearchLoading());
      final result = await searchTV.execute(query);
      result.fold(
        (failure) {
          emit(TVSearchError(failure.message));
        },
        (data) {
          emit(TVSearchLoaded(data));
          analyticsService?.logSearch(
            searchTerm: query,
            category: 'tv',
          );
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
