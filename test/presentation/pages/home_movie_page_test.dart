import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_movie_page_test.mocks.dart';

@GenerateMocks([MovieListNotifier])
void main() {
  late MockMovieListNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMovieListNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieListNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/popular-movie':
              return MaterialPageRoute(
                  builder: (_) => const Text('Popular Movies Page'));
            case '/top-rated-movie':
              return MaterialPageRoute(
                  builder: (_) => const Text('Top Rated Movies Page'));
            case '/detail':
              return MaterialPageRoute(
                  builder: (_) => const Text('Movie Detail Page'));
            case '/search':
              return MaterialPageRoute(
                  builder: (_) => const Text('Search Page'));
            case '/home-tv':
              return MaterialPageRoute(
                  builder: (_) => const Text('Home TV Page'));
            case '/watchlist-movie':
              return MaterialPageRoute(
                  builder: (_) => const Text('Watchlist Movies Page'));
            case '/watchlist-tv':
              return MaterialPageRoute(
                  builder: (_) => const Text('Watchlist TV Page'));
            case '/about':
              return MaterialPageRoute(
                  builder: (_) => const Text('About Page'));
            default:
              return null;
          }
        },
      ),
    );
  }

  void stubMockNotifier() {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.loaded);
    when(mockNotifier.nowPlayingMovies).thenReturn(<Movie>[]);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.loaded);
    when(mockNotifier.popularMovies).thenReturn(<Movie>[]);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.loaded);
    when(mockNotifier.topRatedMovies).thenReturn(<Movie>[]);
  }

  testWidgets('Page should display CircularProgressIndicator when loading',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.loading);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.loading);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.loading);

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display MovieList when data loaded',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.loaded);
    when(mockNotifier.nowPlayingMovies).thenReturn(<Movie>[testMovie]);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.loaded);
    when(mockNotifier.popularMovies).thenReturn(<Movie>[testMovie]);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.loaded);
    when(mockNotifier.topRatedMovies).thenReturn(<Movie>[testMovie]);

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    expect(find.byType(MovieList), findsNWidgets(3));

    final image = tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage).first);
    final errorWidget = image.errorWidget!(tester.element(find.byType(CachedNetworkImage).first), 'url', 'error');
    expect(errorWidget, isA<Icon>());
  });

  testWidgets('Page should display Failed text when error',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.error);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.error);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.error);

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('Should navigate to Search page when search icon tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text('Search Page'), findsOneWidget);
  });

  testWidgets('Should navigate to Popular Movies page when See More tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    await tester.tap(find.text('See More').first);
    await tester.pumpAndSettle();

    expect(find.text('Popular Movies Page'), findsOneWidget);
  });

  testWidgets('Should navigate to Top Rated Movies page when See More tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    await tester.tap(find.text('See More').last);
    await tester.pumpAndSettle();

    expect(find.text('Top Rated Movies Page'), findsOneWidget);
  });

  testWidgets('Should navigate to Movie Detail page when item card tapped',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.loaded);
    when(mockNotifier.nowPlayingMovies).thenReturn(<Movie>[testMovie]);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.loaded);
    when(mockNotifier.popularMovies).thenReturn(<Movie>[]);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.loaded);
    when(mockNotifier.topRatedMovies).thenReturn(<Movie>[]);

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    final itemFinder = find.descendant(
      of: find.byType(MovieList),
      matching: find.byType(InkWell),
    );
    await tester.tap(itemFinder.first);
    await tester.pumpAndSettle();

    expect(find.text('Movie Detail Page'), findsOneWidget);
  });

  testWidgets('Should close drawer when Movies drawer item is tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    final moviesTile = find.descendant(
      of: find.byType(Drawer),
      matching: find.text('Movies'),
    );
    await tester.tap(moviesTile);
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsNothing);
  });

  testWidgets('Should navigate to TV Series page when TV Series drawer item is tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    final drawerIconButton = find.byIcon(Icons.menu);
    await tester.tap(drawerIconButton);
    await tester.pumpAndSettle();

    final tvSeriesTile = find.text('TV Series');
    await tester.tap(tvSeriesTile);
    await tester.pumpAndSettle();

    expect(find.text('Home TV Page'), findsOneWidget);
  });

  testWidgets('Should navigate to Watchlist Movies page when Watchlist Movies drawer item is tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Watchlist Movies'));
    await tester.pumpAndSettle();

    expect(find.text('Watchlist Movies Page'), findsOneWidget);
  });

  testWidgets('Should navigate to Watchlist TV page when Watchlist TV drawer item is tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Watchlist TV Series'));
    await tester.pumpAndSettle();

    expect(find.text('Watchlist TV Page'), findsOneWidget);
  });

  testWidgets('Should navigate to About page when About drawer item is tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(HomeMoviePage()));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('About Page'), findsOneWidget);
  });
}
