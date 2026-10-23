import 'package:equatable/equatable.dart';

class TVWatchlistStatusState extends Equatable {
  final bool isAddedToWatchlist;
  final String message;

  const TVWatchlistStatusState({
    required this.isAddedToWatchlist,
    required this.message,
  });

  factory TVWatchlistStatusState.initial() => const TVWatchlistStatusState(
        isAddedToWatchlist: false,
        message: '',
      );

  TVWatchlistStatusState copyWith({
    bool? isAddedToWatchlist,
    String? message,
  }) {
    return TVWatchlistStatusState(
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [isAddedToWatchlist, message];
}
