import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_search_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_page.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_tv_page_test.mocks.dart';

@GenerateMocks([TVListNotifier])
void main() {
  late MockTVListNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTVListNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TVListNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(
                  builder: (_) => const Text('Home Movie Page'));
            case '/now-playing-tv':
              return MaterialPageRoute(
                  builder: (_) => const Text('Now Playing TV Page'));
            case '/popular-tv':
              return MaterialPageRoute(
                  builder: (_) => const Text('Popular TV Page'));
            case '/top-rated-tv':
              return MaterialPageRoute(
                  builder: (_) => const Text('Top Rated TV Page'));
            case '/detail-tv':
              return MaterialPageRoute(
                  builder: (_) => const Text('TV Detail Page'));
            case '/search-tv':
              return MaterialPageRoute(
                  builder: (_) => const Text('TV Search Page'));
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
    when(mockNotifier.nowPlayingTV).thenReturn(<TV>[]);
    when(mockNotifier.popularTVState).thenReturn(RequestState.loaded);
    when(mockNotifier.popularTV).thenReturn(<TV>[]);
    when(mockNotifier.topRatedTVState).thenReturn(RequestState.loaded);
    when(mockNotifier.topRatedTV).thenReturn(<TV>[]);
  }

  testWidgets('Page should display CircularProgressIndicator when loading',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.loading);
    when(mockNotifier.popularTVState).thenReturn(RequestState.loading);
    when(mockNotifier.topRatedTVState).thenReturn(RequestState.loading);

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display TVList when data loaded',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.loaded);
    when(mockNotifier.nowPlayingTV).thenReturn(<TV>[testTV]);
    when(mockNotifier.popularTVState).thenReturn(RequestState.loaded);
    when(mockNotifier.popularTV).thenReturn(<TV>[testTV]);
    when(mockNotifier.topRatedTVState).thenReturn(RequestState.loaded);
    when(mockNotifier.topRatedTV).thenReturn(<TV>[testTV]);

    await tester.pumpWidget(makeTestableWidget(HomeTVPage()));

    expect(find.byType(TVList), findsNWidgets(3));

    final image = tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage).first);
    final errorWidget = image.errorWidget!(tester.element(find.byType(CachedNetworkImage).first), 'url', 'error');
    expect(errorWidget, isA<Icon>());
  });

  testWidgets('Page should display Failed text when error',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.error);
    when(mockNotifier.popularTVState).thenReturn(RequestState.error);
    when(mockNotifier.topRatedTVState).thenReturn(RequestState.error);

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    expect(find.text('Failed'), findsNWidgets(3));
  });

  testWidgets('Should navigate to search page when search button tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text('TV Search Page'), findsOneWidget);
  });

  testWidgets('Should navigate to TV detail page when item card tapped',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.loaded);
    when(mockNotifier.nowPlayingTV).thenReturn(<TV>[testTV]);
    when(mockNotifier.popularTVState).thenReturn(RequestState.loaded);
    when(mockNotifier.popularTV).thenReturn(<TV>[]);
    when(mockNotifier.topRatedTVState).thenReturn(RequestState.loaded);
    when(mockNotifier.topRatedTV).thenReturn(<TV>[]);

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    final tvCardFinder = find.descendant(
      of: find.byType(TVList),
      matching: find.byType(InkWell),
    );
    await tester.tap(tvCardFinder.first);
    await tester.pumpAndSettle();

    expect(find.text('TV Detail Page'), findsOneWidget);
  });

  testWidgets('Should navigate to Now Playing TV page when See More tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    await tester.tap(find.text('See More').first);
    await tester.pumpAndSettle();

    expect(find.text('Now Playing TV Page'), findsOneWidget);
  });

  testWidgets('Should navigate to Popular TV page when See More tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    await tester.tap(find.text('See More').at(1));
    await tester.pumpAndSettle();

    expect(find.text('Popular TV Page'), findsOneWidget);
  });

  testWidgets('Should navigate to Top Rated TV page when See More tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    await tester.tap(find.text('See More').last);
    await tester.pumpAndSettle();

    expect(find.text('Top Rated TV Page'), findsOneWidget);
  });

  testWidgets('Should navigate to Movies page when Movies drawer item tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Movies'));
    await tester.pumpAndSettle();

    expect(find.text('Home Movie Page'), findsOneWidget);
  });

  testWidgets('Should close drawer when TV Series drawer item tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    final tvSeriesDrawerTile = find.descendant(
      of: find.byType(Drawer),
      matching: find.text('TV Series'),
    );
    await tester.tap(tvSeriesDrawerTile);
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsNothing);
  });

  testWidgets('Should navigate to Watchlist Movies page when Watchlist Movies drawer item tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Watchlist Movies'));
    await tester.pumpAndSettle();

    expect(find.text('Watchlist Movies Page'), findsOneWidget);
  });

  testWidgets('Should navigate to Watchlist TV page when Watchlist TV drawer item tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Watchlist TV Series'));
    await tester.pumpAndSettle();

    expect(find.text('Watchlist TV Page'), findsOneWidget);
  });

  testWidgets('Should navigate to About page when About drawer item tapped',
      (WidgetTester tester) async {
    stubMockNotifier();

    await tester.pumpWidget(makeTestableWidget(const HomeTVPage()));

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('About Page'), findsOneWidget);
  });
}
