import 'package:core/common/analytics_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_event.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_state.dart';

class TVDetailBloc extends Bloc<TVDetailEvent, TVDetailState> {
  final GetTVDetail getTVDetail;
  final AnalyticsService? analyticsService;

  TVDetailBloc(this.getTVDetail, {this.analyticsService})
      : super(TVDetailEmpty()) {
    on<FetchTVDetail>((event, emit) async {
      emit(TVDetailLoading());
      final result = await getTVDetail.execute(event.id);
      result.fold(
        (failure) {
          emit(TVDetailError(failure.message));
        },
        (tv) {
          emit(TVDetailLoaded(tv));
          analyticsService?.logSelectContent(
            contentType: 'tv',
            itemId: tv.id.toString(),
            title: tv.name,
          );
        },
      );
    });
  }
}
