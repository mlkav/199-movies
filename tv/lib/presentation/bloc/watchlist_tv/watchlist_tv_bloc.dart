import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_watchlist_tv.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_event.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_state.dart';

class WatchlistTVBloc extends Bloc<WatchlistTVEvent, WatchlistTVState> {
  final GetWatchlistTV getWatchlistTV;

  WatchlistTVBloc(this.getWatchlistTV) : super(WatchlistTVEmpty()) {
    on<FetchWatchlistTV>((event, emit) async {
      emit(WatchlistTVLoading());
      final result = await getWatchlistTV.execute();
      result.fold(
        (failure) => emit(WatchlistTVError(failure.message)),
        (tvData) => emit(WatchlistTVLoaded(tvData)),
      );
    });
  }
}
