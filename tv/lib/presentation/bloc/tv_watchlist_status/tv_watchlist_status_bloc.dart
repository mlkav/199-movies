import 'package:core/common/analytics_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/presentation/bloc/tv_watchlist_status/tv_watchlist_status_event.dart';
import 'package:tv/presentation/bloc/tv_watchlist_status/tv_watchlist_status_state.dart';

class TVWatchlistStatusBloc
    extends Bloc<TVWatchlistStatusEvent, TVWatchlistStatusState> {
  final GetWatchListTVStatus getWatchListTVStatus;
  final SaveWatchlistTV saveWatchlistTV;
  final RemoveWatchlistTV removeWatchlistTV;
  final AnalyticsService? analyticsService;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  TVWatchlistStatusBloc({
    required this.getWatchListTVStatus,
    required this.saveWatchlistTV,
    required this.removeWatchlistTV,
    this.analyticsService,
  }) : super(const TVWatchlistStatusState(
          isAddedToWatchlist: false,
          message: '',
        )) {
    on<LoadTVWatchlistStatus>((event, emit) async {
      final status = await getWatchListTVStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status, message: ''));
    });

    on<AddTVWatchlist>((event, emit) async {
      final result = await saveWatchlistTV.execute(event.tv);
      await result.fold(
        (failure) async {
          emit(state.copyWith(message: failure.message));
        },
        (successMessage) async {
          final status = await getWatchListTVStatus.execute(event.tv.id);
          emit(state.copyWith(
            isAddedToWatchlist: status,
            message: successMessage,
          ));
          analyticsService?.logAddToWatchlist(
            contentType: 'tv',
            itemId: event.tv.id.toString(),
            title: event.tv.name,
          );
        },
      );
    });

    on<RemoveTVWatchlist>((event, emit) async {
      final result = await removeWatchlistTV.execute(event.tv);
      await result.fold(
        (failure) async {
          emit(state.copyWith(message: failure.message));
        },
        (successMessage) async {
          final status = await getWatchListTVStatus.execute(event.tv.id);
          emit(state.copyWith(
            isAddedToWatchlist: status,
            message: successMessage,
          ));
          analyticsService?.logRemoveFromWatchlist(
            contentType: 'tv',
            itemId: event.tv.id.toString(),
            title: event.tv.name,
          );
        },
      );
    });
  }
}
