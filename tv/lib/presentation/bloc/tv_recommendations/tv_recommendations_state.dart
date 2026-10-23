import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';

abstract class TVRecommendationsState extends Equatable {
  const TVRecommendationsState();

  @override
  List<Object> get props => [];
}

class TVRecommendationsEmpty extends TVRecommendationsState {}

class TVRecommendationsLoading extends TVRecommendationsState {}

class TVRecommendationsLoaded extends TVRecommendationsState {
  final List<TV> tvList;

  const TVRecommendationsLoaded(this.tvList);

  @override
  List<Object> get props => [tvList];
}

class TVRecommendationsError extends TVRecommendationsState {
  final String message;

  const TVRecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}
