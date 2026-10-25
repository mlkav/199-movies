import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TVDetailNotifier])
void main() {
  late MockTVDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTVDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TVDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
        onGenerateRoute: (settings) {
          if (settings.name == TVDetailPage.routeName) {
            return MaterialPageRoute(builder: (_) => const Text('TV Detail Page'));
          }
          return null;
        },
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when TV show not added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTVDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when TV show is added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTVDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTVDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

    final watchlistButton = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(watchlistButton, findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should remove from watchlist when already added',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTVDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);
    when(mockNotifier.watchlistMessage).thenReturn('Removed from Watchlist');

    final watchlistButton = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    await tester.tap(watchlistButton);
    await tester.pump();

    verify(mockNotifier.removeFromWatchlist(testTVDetail));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTVDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(watchlistButton, findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Page should display error message when TV detail state is Error',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Failed to load TV detail');

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(find.text('Failed to load TV detail'), findsOneWidget);
  });

  testWidgets(
      'Page should display progress indicator when recommendation state is Loading',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTVDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loading);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets(
      'Page should display error message when recommendation state is Error',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTVDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.error);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.message).thenReturn('Recommendation error');
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(find.text('Recommendation error'), findsOneWidget);
  });

  testWidgets('Page should display season with fallback icon when poster is null',
      (WidgetTester tester) async {
    const tTVDetailNoSeasonPoster = TVDetail(
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
      seasons: [
        Season(
          airDate: '2021-01-01',
          episodeCount: 10,
          id: 1,
          name: 'Season 1',
          overview: 'Overview',
          posterPath: null,
          seasonNumber: 1,
        )
      ],
      voteAverage: 1.0,
      voteCount: 1,
    );

    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(tTVDetailNoSeasonPoster);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(find.byIcon(Icons.tv), findsOneWidget);
  });

  testWidgets('Page should display No seasons available when seasons list is empty',
      (WidgetTester tester) async {
    const tTVDetailNoSeasons = TVDetail(
      adult: false,
      backdropPath: '/path.jpg',
      firstAirDate: '2021-01-01',
      genres: [],
      id: 1,
      name: 'Name',
      numberOfEpisodes: 0,
      numberOfSeasons: 0,
      originalName: 'Original Name',
      overview: 'Overview',
      posterPath: '/path.jpg',
      seasons: [],
      voteAverage: 1.0,
      voteCount: 1,
    );

    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(tTVDetailNoSeasons);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(find.text('No seasons available'), findsOneWidget);
  });

  testWidgets('Page should display recommendations when recommendation state is Loaded',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTVDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[testTV]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('');

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(find.text('Recommendations'), findsOneWidget);
    expect(find.byType(ListView), findsNWidgets(2));

    final images = tester.widgetList<CachedNetworkImage>(find.byType(CachedNetworkImage));
    for (var img in images) {
      if (img.errorWidget != null) {
        final err = img.errorWidget!(tester.element(find.byType(CachedNetworkImage).first), 'url', 'error');
        expect(err, isA<Icon>());
      }
    }

    final inkWells = tester.widgetList<InkWell>(find.byType(InkWell));
    for (var inkWell in inkWells) {
      if (inkWell.onTap != null) {
        inkWell.onTap!();
      }
    }
  });

  testWidgets('Page should render Container when recommendationState is empty',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTVDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.empty);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(find.byType(Container), findsWidgets);
  });

  testWidgets('Page should pop when back button is tapped', (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTVDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
  });
}
