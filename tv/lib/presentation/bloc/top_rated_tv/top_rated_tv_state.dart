import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';

abstract class TopRatedTVState extends Equatable {
  const TopRatedTVState();

  @override
  List<Object> get props => [];
}

class TopRatedTVEmpty extends TopRatedTVState {}

class TopRatedTVLoading extends TopRatedTVState {}

class TopRatedTVLoaded extends TopRatedTVState {
  final List<TV> tvList;

  const TopRatedTVLoaded(this.tvList);

  @override
  List<Object> get props => [tvList];
}

class TopRatedTVError extends TopRatedTVState {
  final String message;

  const TopRatedTVError(this.message);

  @override
  List<Object> get props => [message];
}
