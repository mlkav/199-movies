import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:tv/domain/entities/episode.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_event.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_state.dart';
import 'package:tv/presentation/bloc/tv_recommendations/tv_recommendations_bloc.dart';
import 'package:tv/presentation/bloc/tv_recommendations/tv_recommendations_event.dart';
import 'package:tv/presentation/bloc/tv_recommendations/tv_recommendations_state.dart';
import 'package:tv/presentation/bloc/tv_season_detail/tv_season_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_season_detail/tv_season_detail_event.dart';
import 'package:tv/presentation/bloc/tv_season_detail/tv_season_detail_state.dart';
import 'package:tv/presentation/bloc/tv_watchlist_status/tv_watchlist_status_bloc.dart';
import 'package:tv/presentation/bloc/tv_watchlist_status/tv_watchlist_status_event.dart';
import 'package:tv/presentation/bloc/tv_watchlist_status/tv_watchlist_status_state.dart';

class TVDetailPage extends StatefulWidget {
  static const routeName = '/detail-tv';

  final int id;
  const TVDetailPage({super.key, required this.id});

  @override
  TVDetailPageState createState() => TVDetailPageState();
}

class TVDetailPageState extends State<TVDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TVDetailBloc>().add(FetchTVDetail(widget.id));
      context
          .read<TVRecommendationsBloc>()
          .add(FetchTVRecommendations(widget.id));
      context
          .read<TVWatchlistStatusBloc>()
          .add(LoadTVWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TVDetailBloc, TVDetailState>(
        builder: (context, state) {
          if (state is TVDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TVDetailLoaded) {
            final tv = state.tv;
            return SafeArea(
              child: DetailContent(
                tv,
              ),
            );
          } else if (state is TVDetailError) {
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
  final TVDetail tv;

  const DetailContent(this.tv, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        _TVPosterBackground(
          posterPath: tv.posterPath,
          screenWidth: screenWidth,
        ),
        _DraggableTVDetailSheet(tv: tv),
        const _TVBackButton(),
      ],
    );
  }
}

class _TVPosterBackground extends StatelessWidget {
  final String? posterPath;
  final double screenWidth;

  const _TVPosterBackground({
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

class _TVBackButton extends StatelessWidget {
  const _TVBackButton();

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

class _DraggableTVDetailSheet extends StatelessWidget {
  final TVDetail tv;

  const _DraggableTVDetailSheet({required this.tv});

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
                    child: _TVSheetContent(tv: tv),
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

class _TVSheetContent extends StatelessWidget {
  final TVDetail tv;

  const _TVSheetContent({required this.tv});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tv.name, style: kHeading5),
        _TVWatchlistButton(tv: tv),
        Text(_showGenres(tv.genres)),
        Text('${tv.numberOfSeasons} Seasons, ${tv.numberOfEpisodes} Episodes'),
        _TVRatingBar(voteAverage: tv.voteAverage),
        const SizedBox(height: 16),
        Text('Overview', style: kHeading6),
        Text(tv.overview),
        const SizedBox(height: 16),
        Text('Seasons', style: kHeading6),
        _TVSeasonsList(seasons: tv.seasons, tvId: tv.id),
        const SizedBox(height: 16),
        Text('Recommendations', style: kHeading6),
        const _TVRecommendationsList(),
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
}

class _TVWatchlistButton extends StatelessWidget {
  final TVDetail tv;

  const _TVWatchlistButton({required this.tv});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TVWatchlistStatusBloc, TVWatchlistStatusState>(
      listener: (context, state) {
        final message = state.message;
        if (message == TVWatchlistStatusBloc.watchlistAddSuccessMessage ||
            message == TVWatchlistStatusBloc.watchlistRemoveSuccessMessage) {
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
              context.read<TVWatchlistStatusBloc>().add(AddTVWatchlist(tv));
            } else {
              context.read<TVWatchlistStatusBloc>().add(RemoveTVWatchlist(tv));
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

class _TVRatingBar extends StatelessWidget {
  final double voteAverage;

  const _TVRatingBar({required this.voteAverage});

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

class _TVSeasonsList extends StatelessWidget {
  final List<Season> seasons;
  final int tvId;

  const _TVSeasonsList({
    required this.seasons,
    required this.tvId,
  });

  @override
  Widget build(BuildContext context) {
    if (seasons.isEmpty) {
      return const Text('No seasons available');
    }
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: seasons.length,
        itemBuilder: (context, index) {
          final season = seasons[index];
          return InkWell(
            onTap: () => _showSeasonDetail(context, season, tvId),
            child: Container(
              width: 110,
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: season.posterPath != null
                        ? CachedNetworkImage(
                            imageUrl: '$BASE_IMAGE_URL${season.posterPath}',
                            height: 110,
                            width: 100,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Container(
                            height: 110,
                            width: 100,
                            color: Colors.grey.shade800,
                            child: const Icon(Icons.tv, size: 40),
                          ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    season.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${season.episodeCount} Episodes',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSeasonDetail(BuildContext context, Season season, int tvId) {
    context
        .read<TVSeasonDetailBloc>()
        .add(FetchTVSeasonDetail(tvId, season.seasonNumber));

    showModalBottomSheet(
      context: context,
      backgroundColor: kRichBlack,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _SeasonDetailBottomSheetContent(season: season);
      },
    );
  }
}

class _SeasonDetailBottomSheetContent extends StatelessWidget {
  final Season season;

  const _SeasonDetailBottomSheetContent({required this.season});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _SeasonHeaderRow(season: season),
                const SizedBox(height: 16),
                Text('Overview', style: kHeading6),
                const SizedBox(height: 8),
                Text(
                  season.overview.isNotEmpty
                      ? season.overview
                      : 'No overview available for this season.',
                  style: kBodyText,
                ),
                const SizedBox(height: 16),
                Text('Episodes List', style: kHeading6),
                const SizedBox(height: 8),
                const _EpisodesListBlocBuilder(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SeasonHeaderRow extends StatelessWidget {
  final Season season;

  const _SeasonHeaderRow({required this.season});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: season.posterPath != null
              ? CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${season.posterPath}',
                  width: 90,
                  height: 130,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Container(
                  width: 90,
                  height: 130,
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.tv, size: 40),
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(season.name, style: kHeading6),
              const SizedBox(height: 4),
              Text('Season ${season.seasonNumber}', style: kSubtitle),
              const SizedBox(height: 4),
              Text(
                'Total Episodes: ${season.episodeCount}',
                style: const TextStyle(
                  color: kMikadoYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (season.airDate != null && season.airDate!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Air Date: ${season.airDate}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _EpisodesListBlocBuilder extends StatelessWidget {
  const _EpisodesListBlocBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TVSeasonDetailBloc, TVSeasonDetailState>(
      builder: (context, state) {
        if (state is TVSeasonDetailLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is TVSeasonDetailLoaded) {
          final episodes = state.seasonDetail.episodes;
          if (episodes.isEmpty) {
            return const Text('No episodes available.');
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              final episode = episodes[index];
              return _EpisodeCardItem(episode: episode);
            },
          );
        } else if (state is TVSeasonDetailError) {
          return Text(state.message);
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _EpisodeCardItem extends StatelessWidget {
  final Episode episode;

  const _EpisodeCardItem({required this.episode});

  void _playEpisodeVideo(BuildContext context, Episode episode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kRichBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.play_circle_fill, color: kMikadoYellow),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Episode ${episode.episodeNumber}: ${episode.name}',
                  style: kHeading6,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: episode.stillPath != null
                        ? CachedNetworkImage(
                            imageUrl: '$BASE_IMAGE_URL${episode.stillPath}',
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 180,
                            width: double.infinity,
                            color: kOxfordBlue,
                            child: const Icon(Icons.tv, size: 50),
                          ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 48,
                      color: kMikadoYellow,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                episode.overview.isNotEmpty
                    ? episode.overview
                    : 'Playing video preview for Episode ${episode.episodeNumber}.',
                style: const TextStyle(fontSize: 12),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kOxfordBlue,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => _playEpisodeVideo(context, episode),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: episode.stillPath != null
                    ? CachedNetworkImage(
                        imageUrl: '$BASE_IMAGE_URL${episode.stillPath}',
                        width: 100,
                        height: 65,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Container(
                        width: 100,
                        height: 65,
                        color: Colors.grey.shade800,
                        child: const Icon(
                          Icons.movie_outlined,
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'E${episode.episodeNumber}. ${episode.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (episode.runtime != null) ...[
                          Text(
                            '${episode.runtime}m',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: kMikadoYellow,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${episode.voteAverage}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      episode.overview.isNotEmpty
                          ? episode.overview
                          : 'No description available.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.play_circle_fill,
                color: kMikadoYellow,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TVRecommendationsList extends StatelessWidget {
  const _TVRecommendationsList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TVRecommendationsBloc, TVRecommendationsState>(
      builder: (context, state) {
        if (state is TVRecommendationsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TVRecommendationsError) {
          return Text(state.message);
        } else if (state is TVRecommendationsLoaded) {
          final recommendations = state.tvList;
          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final tvRecommendation = recommendations[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        TVDetailPage.routeName,
                        arguments: tvRecommendation.id,
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            '$BASE_IMAGE_URL${tvRecommendation.posterPath}',
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
