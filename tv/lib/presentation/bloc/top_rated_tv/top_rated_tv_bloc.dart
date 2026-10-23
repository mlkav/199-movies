import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_event.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_state.dart';

class TopRatedTVBloc extends Bloc<TopRatedTVEvent, TopRatedTVState> {
  final GetTopRatedTV getTopRatedTV;

  TopRatedTVBloc({required this.getTopRatedTV}) : super(TopRatedTVEmpty()) {
    on<FetchTopRatedTV>((event, emit) async {
      emit(TopRatedTVLoading());
      final result = await getTopRatedTV.execute();
      result.fold(
        (failure) => emit(TopRatedTVError(failure.message)),
        (tvData) => emit(TopRatedTVLoaded(tvData)),
      );
    });
  }
}
