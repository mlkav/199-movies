import 'package:movie/domain/entities/genre.dart';
import 'package:tv/data/models/tv_table.dart';
import 'package:tv/domain/entities/episode.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/domain/entities/season_detail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';

const testTV = TV(
  backdropPath: '/path.jpg',
  firstAirDate: '2021-01-01',
  genreIds: [1, 2],
  id: 1,
  name: 'Name',
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'Original Name',
  overview: 'Overview',
  popularity: 1.0,
  posterPath: '/path.jpg',
  voteAverage: 1.0,
  voteCount: 1,
);

final testTVList = [testTV];

const testSeason = Season(
  airDate: '2021-01-01',
  episodeCount: 10,
  id: 1,
  name: 'Season 1',
  overview: 'Overview',
  posterPath: '/path.jpg',
  seasonNumber: 1,
);

const testEpisode = Episode(
  airDate: '2021-01-01',
  episodeNumber: 1,
  id: 1,
  name: 'Episode 1',
  overview: 'Overview',
  runtime: 60,
  seasonNumber: 1,
  stillPath: '/path.jpg',
  voteAverage: 8.0,
  voteCount: 10,
);

const testSeasonDetail = SeasonDetail(
  airDate: '2021-01-01',
  episodes: [testEpisode],
  id: 1,
  name: 'Season 1',
  overview: 'Overview',
  posterPath: '/path.jpg',
  seasonNumber: 1,
);

const testTVDetail = TVDetail(
  adult: false,
  backdropPath: '/path.jpg',
  firstAirDate: '2021-01-01',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  name: 'Name',
  numberOfEpisodes: 10,
  numberOfSeasons: 1,
  originalName: 'Original Name',
  overview: 'Overview',
  posterPath: '/path.jpg',
  seasons: [testSeason],
  voteAverage: 1.0,
  voteCount: 1,
);

const testWatchlistTV = TV.watchlist(
  id: 1,
  name: 'Name',
  posterPath: '/path.jpg',
  overview: 'Overview',
);

const testTVTable = TVTable(
  id: 1,
  name: 'Name',
  posterPath: '/path.jpg',
  overview: 'Overview',
);

final testTVMap = {
  'id': 1,
  'overview': 'Overview',
  'posterPath': '/path.jpg',
  'name': 'Name',
};
