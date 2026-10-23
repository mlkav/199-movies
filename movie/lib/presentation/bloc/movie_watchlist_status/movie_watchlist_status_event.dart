import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie_detail.dart';

abstract class MovieWatchlistStatusEvent extends Equatable {
  const MovieWatchlistStatusEvent();

  @override
  List<Object> get props => [];
}

class LoadMovieWatchlistStatus extends MovieWatchlistStatusEvent {
  final int id;

  const LoadMovieWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class AddMovieWatchlist extends MovieWatchlistStatusEvent {
  final MovieDetail movie;

  const AddMovieWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveMovieWatchlist extends MovieWatchlistStatusEvent {
  final MovieDetail movie;

  const RemoveMovieWatchlist(this.movie);

  @override
  List<Object> get props => [movie];
}
