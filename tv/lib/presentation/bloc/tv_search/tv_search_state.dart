import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';

abstract class TVSearchState extends Equatable {
  const TVSearchState();

  @override
  List<Object> get props => [];
}

class TVSearchEmpty extends TVSearchState {}

class TVSearchLoading extends TVSearchState {}

class TVSearchLoaded extends TVSearchState {
  final List<TV> result;

  const TVSearchLoaded(this.result);

  @override
  List<Object> get props => [result];
}

class TVSearchError extends TVSearchState {
  final String message;

  const TVSearchError(this.message);

  @override
  List<Object> get props => [message];
}
