import 'package:equatable/equatable.dart';

abstract class NowPlayingTVEvent extends Equatable {
  const NowPlayingTVEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingTV extends NowPlayingTVEvent {}
