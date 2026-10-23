import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv_detail.dart';

abstract class TVDetailState extends Equatable {
  const TVDetailState();

  @override
  List<Object> get props => [];
}

class TVDetailEmpty extends TVDetailState {}

class TVDetailLoading extends TVDetailState {}

class TVDetailLoaded extends TVDetailState {
  final TVDetail tv;

  const TVDetailLoaded(this.tv);

  @override
  List<Object> get props => [tv];
}

class TVDetailError extends TVDetailState {
  final String message;

  const TVDetailError(this.message);

  @override
  List<Object> get props => [message];
}
