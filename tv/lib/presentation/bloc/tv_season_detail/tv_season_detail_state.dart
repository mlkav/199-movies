import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/season_detail.dart';

abstract class TVSeasonDetailState extends Equatable {
  const TVSeasonDetailState();

  @override
  List<Object> get props => [];
}

class TVSeasonDetailEmpty extends TVSeasonDetailState {}

class TVSeasonDetailLoading extends TVSeasonDetailState {}

class TVSeasonDetailLoaded extends TVSeasonDetailState {
  final SeasonDetail seasonDetail;

  const TVSeasonDetailLoaded(this.seasonDetail);

  @override
  List<Object> get props => [seasonDetail];
}

class TVSeasonDetailError extends TVSeasonDetailState {
  final String message;

  const TVSeasonDetailError(this.message);

  @override
  List<Object> get props => [message];
}
