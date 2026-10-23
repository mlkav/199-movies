import 'package:equatable/equatable.dart';

class MovieWatchlistStatusState extends Equatable {
  final bool isAddedToWatchlist;
  final String message;

  const MovieWatchlistStatusState({
    required this.isAddedToWatchlist,
    required this.message,
  });

  factory MovieWatchlistStatusState.initial() => const MovieWatchlistStatusState(
        isAddedToWatchlist: false,
        message: '',
      );

  MovieWatchlistStatusState copyWith({
    bool? isAddedToWatchlist,
    String? message,
  }) {
    return MovieWatchlistStatusState(
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [isAddedToWatchlist, message];
}
