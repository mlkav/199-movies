import 'package:equatable/equatable.dart';

abstract class TVRecommendationsEvent extends Equatable {
  const TVRecommendationsEvent();

  @override
  List<Object> get props => [];
}

class FetchTVRecommendations extends TVRecommendationsEvent {
  final int id;

  const FetchTVRecommendations(this.id);

  @override
  List<Object> get props => [id];
}
