import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_event.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_state.dart';

class PopularTVBloc extends Bloc<PopularTVEvent, PopularTVState> {
  final GetPopularTV getPopularTV;

  PopularTVBloc(this.getPopularTV) : super(PopularTVEmpty()) {
    on<FetchPopularTV>((event, emit) async {
      emit(PopularTVLoading());
      final result = await getPopularTV.execute();
      result.fold(
        (failure) => emit(PopularTVError(failure.message)),
        (tvData) => emit(PopularTVLoaded(tvData)),
      );
    });
  }
}
