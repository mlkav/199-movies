import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_now_playing_tv.dart';
import 'package:tv/presentation/bloc/now_playing_tv/now_playing_tv_event.dart';
import 'package:tv/presentation/bloc/now_playing_tv/now_playing_tv_state.dart';

class NowPlayingTVBloc
    extends Bloc<NowPlayingTVEvent, NowPlayingTVState> {
  final GetNowPlayingTV getNowPlayingTV;

  NowPlayingTVBloc(this.getNowPlayingTV) : super(NowPlayingTVEmpty()) {
    on<FetchNowPlayingTV>((event, emit) async {
      emit(NowPlayingTVLoading());
      final result = await getNowPlayingTV.execute();
      result.fold(
        (failure) => emit(NowPlayingTVError(failure.message)),
        (tvData) => emit(NowPlayingTVLoaded(tvData)),
      );
    });
  }
}
