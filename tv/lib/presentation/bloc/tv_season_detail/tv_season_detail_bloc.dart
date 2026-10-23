import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_tv_season_detail.dart';
import 'package:tv/presentation/bloc/tv_season_detail/tv_season_detail_event.dart';
import 'package:tv/presentation/bloc/tv_season_detail/tv_season_detail_state.dart';

class TVSeasonDetailBloc
    extends Bloc<TVSeasonDetailEvent, TVSeasonDetailState> {
  final GetTVSeasonDetail getTVSeasonDetail;

  TVSeasonDetailBloc(this.getTVSeasonDetail) : super(TVSeasonDetailEmpty()) {
    on<FetchTVSeasonDetail>((event, emit) async {
      emit(TVSeasonDetailLoading());
      final result =
          await getTVSeasonDetail.execute(event.tvId, event.seasonNumber);
      result.fold(
        (failure) => emit(TVSeasonDetailError(failure.message)),
        (seasonDetail) => emit(TVSeasonDetailLoaded(seasonDetail)),
      );
    });
  }
}
