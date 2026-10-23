import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/presentation/bloc/tv_recommendations/tv_recommendations_event.dart';
import 'package:tv/presentation/bloc/tv_recommendations/tv_recommendations_state.dart';

class TVRecommendationsBloc
    extends Bloc<TVRecommendationsEvent, TVRecommendationsState> {
  final GetTVRecommendations getTVRecommendations;

  TVRecommendationsBloc(this.getTVRecommendations)
      : super(TVRecommendationsEmpty()) {
    on<FetchTVRecommendations>((event, emit) async {
      emit(TVRecommendationsLoading());
      final result = await getTVRecommendations.execute(event.id);
      result.fold(
        (failure) => emit(TVRecommendationsError(failure.message)),
        (tvList) => emit(TVRecommendationsLoaded(tvList)),
      );
    });
  }
}
