import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';

abstract class NowPlayingTVState extends Equatable {
  const NowPlayingTVState();

  @override
  List<Object> get props => [];
}

class NowPlayingTVEmpty extends NowPlayingTVState {}

class NowPlayingTVLoading extends NowPlayingTVState {}

class NowPlayingTVLoaded extends NowPlayingTVState {
  final List<TV> tvList;

  const NowPlayingTVLoaded(this.tvList);

  @override
  List<Object> get props => [tvList];
}

class NowPlayingTVError extends NowPlayingTVState {
  final String message;

  const NowPlayingTVError(this.message);

  @override
  List<Object> get props => [message];
}
