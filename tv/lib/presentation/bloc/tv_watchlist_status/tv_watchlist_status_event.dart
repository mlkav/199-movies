import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv_detail.dart';

abstract class TVWatchlistStatusEvent extends Equatable {
  const TVWatchlistStatusEvent();

  @override
  List<Object> get props => [];
}

class LoadTVWatchlistStatus extends TVWatchlistStatusEvent {
  final int id;

  const LoadTVWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddTVWatchlist extends TVWatchlistStatusEvent {
  final TVDetail tv;

  const AddTVWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}

class RemoveTVWatchlist extends TVWatchlistStatusEvent {
  final TVDetail tv;

  const RemoveTVWatchlist(this.tv);

  @override
  List<Object> get props => [tv];
}
