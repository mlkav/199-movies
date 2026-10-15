import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_page.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_page_test.mocks.dart';

@GenerateMocks([WatchlistTVNotifier])
void main() {
  late MockWatchlistTVNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockWatchlistTVNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<WatchlistTVNotifier>.value(
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

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
    'Page should display empty message when tv series is empty',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState)
          .thenReturn(RequestState.loaded);
      when(mockNotifier.watchlistTV)
          .thenReturn([]);

      await tester.pumpWidget(
        makeTestableWidget(const WatchlistTVPage()),
      );

      expect(find.byKey(const Key('empty_watchlist')), findsOneWidget);
      expect(find.text('Watchlist is still empty'), findsOneWidget);
      expect(
        find.text('Add your favorite TV Series to your watchlist.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('Page should display ListView and TVCard when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.loaded);
    when(mockNotifier.watchlistTV).thenReturn(<TV>[testWatchlistTV]);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVPage()));

    expect(listViewFinder, findsOneWidget);
    expect(find.byType(TVCard), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should refresh when navigating back via RouteObserver',
      (WidgetTester tester) async {
    when(mockNotifier.watchlistState).thenReturn(RequestState.loaded);
    when(mockNotifier.watchlistTV).thenReturn(<TV>[]);

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVPage()));

    tester.state<WatchlistTVPageState>(find.byType(WatchlistTVPage)).didPopNext();
    verify(mockNotifier.fetchWatchlistTV()).called(greaterThan(0));
  });
}
