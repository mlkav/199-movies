import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movies_page_test.mocks.dart';

@GenerateMocks([WatchlistMovieNotifier])
void main() {
  late MockWatchlistMovieNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockWatchlistMovieNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<WatchlistMovieNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });


  testWidgets(
    'Page should display empty message when watchlist is empty',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState)
          .thenReturn(RequestState.loaded);
      when(mockNotifier.watchlistMovies)
          .thenReturn([]);

      await tester.pumpWidget(
        makeTestableWidget(WatchlistMoviesPage()),
      );

      expect(find.byKey(const Key('empty_watchlist')), findsOneWidget);
      expect(find.text('Watchlist is still empty'), findsOneWidget);
      expect(
        find.text('Add your favorite movies to your watchlist.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('Page should display ListView and MovieCard when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.loaded);
    when(mockNotifier.watchlistMovies).thenReturn(<Movie>[testWatchlistMovie]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should refresh when navigating back via RouteObserver',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.loaded);
    when(mockNotifier.watchlistMovies).thenReturn(<Movie>[]);

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    tester.state<WatchlistMoviesPageState>(find.byType(WatchlistMoviesPage)).didPopNext();
    verify(mockNotifier.fetchWatchlistMovies()).called(greaterThan(0));
  });
}
