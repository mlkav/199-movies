import 'package:bloc_test/bloc_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingTVBloc
    extends MockBloc<NowPlayingTVEvent, NowPlayingTVState>
    implements NowPlayingTVBloc {}

class MockPopularTVBloc
    extends MockBloc<PopularTVEvent, PopularTVState>
    implements PopularTVBloc {}

class MockTopRatedTVBloc
    extends MockBloc<TopRatedTVEvent, TopRatedTVState>
    implements TopRatedTVBloc {}

void main() {
  late MockNowPlayingTVBloc mockNowPlayingTVBloc;
  late MockPopularTVBloc mockPopularTVBloc;
  late MockTopRatedTVBloc mockTopRatedTVBloc;

  setUp(() {
    mockNowPlayingTVBloc = MockNowPlayingTVBloc();
    mockPopularTVBloc = MockPopularTVBloc();
    mockTopRatedTVBloc = MockTopRatedTVBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NowPlayingTVBloc>.value(value: mockNowPlayingTVBloc),
        BlocProvider<PopularTVBloc>.value(value: mockPopularTVBloc),
        BlocProvider<TopRatedTVBloc>.value(value: mockTopRatedTVBloc),
      ],
      child: MaterialApp(
        home: body,
        routes: {
          NowPlayingTVPage.routeName: (_) =>
              const Scaffold(body: Text('Now Playing TV')),
          PopularTVPage.routeName: (_) =>
              const Scaffold(body: Text('Popular TV')),
          TopRatedTVPage.routeName: (_) =>
              const Scaffold(body: Text('Top Rated TV')),
          TVDetailPage.routeName: (_) =>
              const Scaffold(body: Text('TV Detail')),
          TVSearchPage.routeName: (_) =>
              const Scaffold(body: Text('TV Search')),
          WatchlistTVPage.routeName: (_) =>
              const Scaffold(body: Text('Watchlist TV')),
          '/home': (_) => const Scaffold(body: Text('Home Movie')),
          '/watchlist-movie': (_) =>
              const Scaffold(body: Text('Watchlist Movies')),
          '/about': (_) => const Scaffold(body: Text('About Page')),
        },
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state).thenReturn(NowPlayingTVLoading());
    when(() => mockPopularTVBloc.state).thenReturn(PopularTVLoading());
    when(() => mockTopRatedTVBloc.state).thenReturn(TopRatedTVLoading());

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display TVList when loaded',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state)
        .thenReturn(NowPlayingTVLoaded(testTVList));
    when(() => mockPopularTVBloc.state)
        .thenReturn(PopularTVLoaded(testTVList));
    when(() => mockTopRatedTVBloc.state)
        .thenReturn(TopRatedTVLoaded(testTVList));

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    expect(find.byType(TVList), findsNWidgets(3));

    final image = tester
        .widget<CachedNetworkImage>(find.byType(CachedNetworkImage).first);
    final errorWidget = image.errorWidget!(
        tester.element(find.byType(CachedNetworkImage).first), 'url', 'error');
    expect(errorWidget, isA<Icon>());
  });

  testWidgets('Page should display Error text when error',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state)
        .thenReturn(const NowPlayingTVError('Error'));
    when(() => mockPopularTVBloc.state)
        .thenReturn(const PopularTVError('Error'));
    when(() => mockTopRatedTVBloc.state)
        .thenReturn(const TopRatedTVError('Error'));

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('Should navigate to Search page when search button tapped',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state)
        .thenReturn(NowPlayingTVLoaded(testTVList));
    when(() => mockPopularTVBloc.state)
        .thenReturn(PopularTVLoaded(testTVList));
    when(() => mockTopRatedTVBloc.state)
        .thenReturn(TopRatedTVLoaded(testTVList));

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text('TV Search'), findsOneWidget);
  });

  testWidgets('Should navigate to Now Playing TV page when See More tapped',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state)
        .thenReturn(NowPlayingTVLoaded(testTVList));
    when(() => mockPopularTVBloc.state)
        .thenReturn(PopularTVLoaded(testTVList));
    when(() => mockTopRatedTVBloc.state)
        .thenReturn(TopRatedTVLoaded(testTVList));

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    await tester.tap(find.text('See More').first);
    await tester.pumpAndSettle();

    expect(find.text('Now Playing TV'), findsOneWidget);
  });

  testWidgets('Should open drawer and navigate when item tapped',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state)
        .thenReturn(NowPlayingTVLoaded(testTVList));
    when(() => mockPopularTVBloc.state)
        .thenReturn(PopularTVLoaded(testTVList));
    when(() => mockTopRatedTVBloc.state)
        .thenReturn(TopRatedTVLoaded(testTVList));

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Series'), findsWidgets);

    await tester.tap(find.text('Movies'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Home Movie'), findsOneWidget);
  });
}
