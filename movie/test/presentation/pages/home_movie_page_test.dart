import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingMoviesBloc
    extends MockBloc<NowPlayingMoviesEvent, NowPlayingMoviesState>
    implements NowPlayingMoviesBloc {}

class MockPopularMoviesBloc
    extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

void main() {
  late MockNowPlayingMoviesBloc mockNowPlayingMoviesBloc;
  late MockPopularMoviesBloc mockPopularMoviesBloc;
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;

  setUp(() {
    mockNowPlayingMoviesBloc = MockNowPlayingMoviesBloc();
    mockPopularMoviesBloc = MockPopularMoviesBloc();
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingMoviesBloc>.value(
            value: mockNowPlayingMoviesBloc),
        BlocProvider<PopularMoviesBloc>.value(value: mockPopularMoviesBloc),
        BlocProvider<TopRatedMoviesBloc>.value(value: mockTopRatedMoviesBloc),
      ],
      child: MaterialApp(
        home: body,
        routes: {
          PopularMoviesPage.routeName: (_) =>
              const Scaffold(body: Text('Popular Movies')),
          TopRatedMoviesPage.routeName: (_) =>
              const Scaffold(body: Text('Top Rated Movies')),
          MovieDetailPage.routeName: (_) =>
              const Scaffold(body: Text('Movie Detail')),
          SearchPage.routeName: (_) =>
              const Scaffold(body: Text('Search Page')),
          WatchlistMoviesPage.routeName: (_) =>
              const Scaffold(body: Text('Watchlist Movies Page')),
          '/home-tv': (_) => const Scaffold(body: Text('Home TV')),
          '/watchlist-tv': (_) => const Scaffold(body: Text('Watchlist TV')),
          '/about': (_) => const Scaffold(body: Text('About Page')),
        },
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMoviesBloc.state)
        .thenReturn(NowPlayingMoviesLoading());
    when(() => mockPopularMoviesBloc.state).thenReturn(PopularMoviesLoading());
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoading());

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display MovieList when loaded',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMoviesBloc.state)
        .thenReturn(NowPlayingMoviesLoaded(testMovieList));
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(testMovieList));
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(testMovieList));

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    expect(find.byType(MovieList), findsNWidgets(3));

    final image = tester
        .widget<CachedNetworkImage>(find.byType(CachedNetworkImage).first);
    final errorWidget = image.errorWidget!(
        tester.element(find.byType(CachedNetworkImage).first), 'url', 'error');
    expect(errorWidget, isA<Icon>());
  });

  testWidgets('Page should display Error text when error',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMoviesBloc.state)
        .thenReturn(const NowPlayingMoviesError('Error'));
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(const PopularMoviesError('Error'));
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(const TopRatedMoviesError('Error'));

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('Should navigate to Search page when search button tapped',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMoviesBloc.state)
        .thenReturn(NowPlayingMoviesLoaded(testMovieList));
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(testMovieList));
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(testMovieList));

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text('Search Page'), findsOneWidget);
  });

  testWidgets('Should navigate to Popular page when See More tapped',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMoviesBloc.state)
        .thenReturn(NowPlayingMoviesLoaded(testMovieList));
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(testMovieList));
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(testMovieList));

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    await tester.tap(find.text('See More').first);
    await tester.pumpAndSettle();

    expect(find.text('Popular Movies'), findsOneWidget);
  });

  testWidgets('Should navigate to Top Rated page when See More tapped',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMoviesBloc.state)
        .thenReturn(NowPlayingMoviesLoaded(testMovieList));
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(testMovieList));
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(testMovieList));

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    await tester.tap(find.text('See More').last);
    await tester.pumpAndSettle();

    expect(find.text('Top Rated Movies'), findsOneWidget);
  });

  testWidgets('Should navigate to Detail page when Movie item card tapped',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMoviesBloc.state)
        .thenReturn(NowPlayingMoviesLoaded(testMovieList));
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(testMovieList));
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(testMovieList));

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    final item = find.byType(InkWell).first;
    await tester.tap(item);
    await tester.pumpAndSettle();

    expect(find.text('Movie Detail'), findsOneWidget);
  });

  testWidgets('Should open drawer and tap TV Series',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMoviesBloc.state)
        .thenReturn(NowPlayingMoviesLoaded(testMovieList));
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(testMovieList));
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(testMovieList));

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    tester.state<ScaffoldState>(find.byType(Scaffold).first).openDrawer();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.widgetWithText(ListTile, 'TV Series'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Home TV'), findsOneWidget);
  });

  testWidgets('Should open drawer and tap Watchlist Movies',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMoviesBloc.state)
        .thenReturn(NowPlayingMoviesLoaded(testMovieList));
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(testMovieList));
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(testMovieList));

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    tester.state<ScaffoldState>(find.byType(Scaffold).first).openDrawer();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.widgetWithText(ListTile, 'Watchlist Movies'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Watchlist Movies Page'), findsOneWidget);
  });

  testWidgets('Should open drawer and tap Watchlist TV Series',
      (WidgetTester tester) async {
    when(() => mockNowPlayingMoviesBloc.state)
        .thenReturn(NowPlayingMoviesLoaded(testMovieList));
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(testMovieList));
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(testMovieList));

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    tester.state<ScaffoldState>(find.byType(Scaffold).first).openDrawer();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.widgetWithText(ListTile, 'Watchlist TV Series'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Watchlist TV'), findsOneWidget);
  });

  testWidgets('Should open drawer and tap About', (WidgetTester tester) async {
    when(() => mockNowPlayingMoviesBloc.state)
        .thenReturn(NowPlayingMoviesLoaded(testMovieList));
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(testMovieList));
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(testMovieList));

    await tester.pumpWidget(makeTestableWidget(const HomeMoviePage()));

    tester.state<ScaffoldState>(find.byType(Scaffold).first).openDrawer();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.widgetWithText(ListTile, 'About'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('About Page'), findsOneWidget);
  });
}
