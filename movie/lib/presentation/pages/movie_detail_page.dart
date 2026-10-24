import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:movie/presentation/bloc/movie_recommendations/movie_recommendations_bloc.dart';
import 'package:movie/presentation/bloc/movie_recommendations/movie_recommendations_event.dart';
import 'package:movie/presentation/bloc/movie_recommendations/movie_recommendations_state.dart';
import 'package:movie/presentation/bloc/movie_watchlist_status/movie_watchlist_status_bloc.dart';
import 'package:movie/presentation/bloc/movie_watchlist_status/movie_watchlist_status_event.dart';
import 'package:movie/presentation/bloc/movie_watchlist_status/movie_watchlist_status_state.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/detail';

  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  MovieDetailPageState createState() => MovieDetailPageState();
}

class MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.id));
      context
          .read<MovieRecommendationsBloc>()
          .add(FetchMovieRecommendations(widget.id));
      context
          .read<MovieWatchlistStatusBloc>()
          .add(LoadMovieWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MovieDetailLoaded) {
            final movie = state.movie;
            return SafeArea(
              child: DetailContent(
                movie,
              ),
            );
          } else if (state is MovieDetailError) {
            return Text(state.message);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;

  const DetailContent(this.movie, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        _MoviePosterBackground(
          posterPath: movie.posterPath,
          screenWidth: screenWidth,
        ),
        _DraggableDetailSheet(movie: movie),
        const _BackButton(),
      ],
    );
  }
}

class _MoviePosterBackground extends StatelessWidget {
  final String? posterPath;
  final double screenWidth;

  const _MoviePosterBackground({
    required this.posterPath,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: '$BASE_IMAGE_URL$posterPath',
      width: screenWidth,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: kRichBlack,
        foregroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class _DraggableDetailSheet extends StatelessWidget {
  final MovieDetail movie;

  const _DraggableDetailSheet({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 48 + 8),
      child: DraggableScrollableSheet(
        minChildSize: 0.25,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: kRichBlack,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: _MovieSheetContent(movie: movie),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.white,
                    height: 4,
                    width: 48,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MovieSheetContent extends StatelessWidget {
  final MovieDetail movie;

  const _MovieSheetContent({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(movie.title, style: kHeading5),
        _WatchlistButton(movie: movie),
        Text(_showGenres(movie.genres)),
        Text(_showDuration(movie.runtime)),
        _MovieRatingBar(voteAverage: movie.voteAverage),
        const SizedBox(height: 16),
        Text('Overview', style: kHeading6),
        Text(movie.overview),
        const SizedBox(height: 16),
        Text('Recommendations', style: kHeading6),
        const _MovieRecommendationsList(),
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }
    if (result.isEmpty) return result;
    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class _WatchlistButton extends StatelessWidget {
  final MovieDetail movie;

  const _WatchlistButton({required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieWatchlistStatusBloc, MovieWatchlistStatusState>(
      listener: (context, state) {
        final message = state.message;
        if (message == MovieWatchlistStatusBloc.watchlistAddSuccessMessage ||
            message == MovieWatchlistStatusBloc.watchlistRemoveSuccessMessage) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        } else if (message.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(message),
              );
            },
          );
        }
      },
      builder: (context, state) {
        return FilledButton(
          onPressed: () async {
            if (!state.isAddedToWatchlist) {
              context
                  .read<MovieWatchlistStatusBloc>()
                  .add(AddMovieWatchlist(movie));
            } else {
              context
                  .read<MovieWatchlistStatusBloc>()
                  .add(RemoveMovieWatchlist(movie));
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              state.isAddedToWatchlist
                  ? const Icon(Icons.check)
                  : const Icon(Icons.add),
              const Text('Watchlist'),
            ],
          ),
        );
      },
    );
  }
}

class _MovieRatingBar extends StatelessWidget {
  final double voteAverage;

  const _MovieRatingBar({required this.voteAverage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBarIndicator(
          rating: voteAverage / 2,
          itemCount: 5,
          itemBuilder: (context, index) => const Icon(
            Icons.star,
            color: kMikadoYellow,
          ),
          itemSize: 24,
        ),
        Text('$voteAverage'),
      ],
    );
  }
}

class _MovieRecommendationsList extends StatelessWidget {
  const _MovieRecommendationsList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieRecommendationsBloc, MovieRecommendationsState>(
      builder: (context, state) {
        if (state is MovieRecommendationsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MovieRecommendationsError) {
          return Text(state.message);
        } else if (state is MovieRecommendationsLoaded) {
          final recommendations = state.movies;
          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final movieRecommendation = recommendations[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        MovieDetailPage.routeName,
                        arguments: movieRecommendation.id,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            '$BASE_IMAGE_URL${movieRecommendation.posterPath}',
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
