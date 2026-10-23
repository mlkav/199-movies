import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/search_tv.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_event.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_state.dart';

class TVSearchBloc extends Bloc<TVSearchEvent, TVSearchState> {
  final SearchTV searchTV;

  TVSearchBloc(this.searchTV) : super(TVSearchEmpty()) {
    on<FetchTVSearch>((event, emit) async {
      emit(TVSearchLoading());
      final result = await searchTV.execute(event.query);
      result.fold(
        (failure) => emit(TVSearchError(failure.message)),
        (data) => emit(TVSearchLoaded(data)),
      );
    });
  }
}
