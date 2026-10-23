import 'package:equatable/equatable.dart';

abstract class TopRatedTVEvent extends Equatable {
  const TopRatedTVEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedTV extends TopRatedTVEvent {}
