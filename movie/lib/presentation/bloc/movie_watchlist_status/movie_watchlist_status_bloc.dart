import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/bloc/movie_watchlist_status/movie_watchlist_status_event.dart';
import 'package:movie/presentation/bloc/movie_watchlist_status/movie_watchlist_status_state.dart';

class MovieWatchlistStatusBloc
    extends Bloc<MovieWatchlistStatusEvent, MovieWatchlistStatusState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieWatchlistStatusBloc({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieWatchlistStatusState.initial()) {
    on<LoadMovieWatchlistStatus>((event, emit) async {
      final status = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status, message: ''));
    });

    on<AddMovieWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);
      await result.fold(
        (failure) async {
          emit(state.copyWith(message: failure.message));
        },
        (successMessage) async {
          final status = await getWatchListStatus.execute(event.movie.id);
          emit(state.copyWith(
            isAddedToWatchlist: status,
            message: successMessage,
          ));
        },
      );
    });

    on<RemoveMovieWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);
      await result.fold(
        (failure) async {
          emit(state.copyWith(message: failure.message));
        },
        (successMessage) async {
          final status = await getWatchListStatus.execute(event.movie.id);
          emit(state.copyWith(
            isAddedToWatchlist: status,
            message: successMessage,
          ));
        },
      );
    });
  }
}
