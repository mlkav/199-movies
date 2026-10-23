import 'package:equatable/equatable.dart';

abstract class TVSeasonDetailEvent extends Equatable {
  const TVSeasonDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTVSeasonDetail extends TVSeasonDetailEvent {
  final int tvId;
  final int seasonNumber;

  const FetchTVSeasonDetail(this.tvId, this.seasonNumber);

  @override
  List<Object> get props => [tvId, seasonNumber];
}
