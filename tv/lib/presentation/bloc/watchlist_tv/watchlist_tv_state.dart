import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';

abstract class WatchlistTVState extends Equatable {
  const WatchlistTVState();

  @override
  List<Object> get props => [];
}

class WatchlistTVEmpty extends WatchlistTVState {}

class WatchlistTVLoading extends WatchlistTVState {}

class WatchlistTVLoaded extends WatchlistTVState {
  final List<TV> tvList;

  const WatchlistTVLoaded(this.tvList);

  @override
  List<Object> get props => [tvList];
}

class WatchlistTVError extends WatchlistTVState {
  final String message;

  const WatchlistTVError(this.message);

  @override
  List<Object> get props => [message];
}
