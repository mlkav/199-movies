import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTVDetailBloc extends MockBloc<TVDetailEvent, TVDetailState>
    implements TVDetailBloc {}

class MockTVRecommendationsBloc
    extends MockBloc<TVRecommendationsEvent, TVRecommendationsState>
    implements TVRecommendationsBloc {}

class MockTVWatchlistStatusBloc
    extends MockBloc<TVWatchlistStatusEvent, TVWatchlistStatusState>
    implements TVWatchlistStatusBloc {}

class MockTVSeasonDetailBloc
    extends MockBloc<TVSeasonDetailEvent, TVSeasonDetailState>
    implements TVSeasonDetailBloc {}

void main() {
  late MockTVDetailBloc mockTVDetailBloc;
  late MockTVRecommendationsBloc mockTVRecommendationsBloc;
  late MockTVWatchlistStatusBloc mockTVWatchlistStatusBloc;
  late MockTVSeasonDetailBloc mockTVSeasonDetailBloc;

  setUp(() {
    mockTVDetailBloc = MockTVDetailBloc();
    mockTVRecommendationsBloc = MockTVRecommendationsBloc();
    mockTVWatchlistStatusBloc = MockTVWatchlistStatusBloc();
    mockTVSeasonDetailBloc = MockTVSeasonDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TVDetailBloc>.value(value: mockTVDetailBloc),
        BlocProvider<TVRecommendationsBloc>.value(
            value: mockTVRecommendationsBloc),
        BlocProvider<TVWatchlistStatusBloc>.value(
            value: mockTVWatchlistStatusBloc),
        BlocProvider<TVSeasonDetailBloc>.value(
            value: mockTVSeasonDetailBloc),
      ],
      child: MaterialApp(
        home: body,
        routes: {
          TVDetailPage.routeName: (_) =>
              const Scaffold(body: Text('Recommendation Detail')),
        },
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state).thenReturn(TVDetailLoading());
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(TVRecommendationsLoading());
    when(() => mockTVWatchlistStatusBloc.state).thenReturn(
        const TVWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error text when detail error',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state)
        .thenReturn(const TVDetailError('Error message'));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(TVRecommendationsLoading());
    when(() => mockTVWatchlistStatusBloc.state).thenReturn(
        const TVWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display add icon when TV show not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state)
        .thenReturn(const TVDetailLoaded(testTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(const TVRecommendationsLoaded([]));
    when(() => mockTVWatchlistStatusBloc.state).thenReturn(
        const TVWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when TV show is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state)
        .thenReturn(const TVDetailLoaded(testTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(const TVRecommendationsLoaded([]));
    when(() => mockTVWatchlistStatusBloc.state).thenReturn(
        const TVWatchlistStatusState(isAddedToWatchlist: true, message: ''));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Tapping watchlist button when not added should trigger AddTVWatchlist',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state)
        .thenReturn(const TVDetailLoaded(testTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(const TVRecommendationsLoaded([]));
    when(() => mockTVWatchlistStatusBloc.state).thenReturn(
        const TVWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    final watchlistButton = find.byType(FilledButton);
    await tester.tap(watchlistButton);

    verify(() => mockTVWatchlistStatusBloc
        .add(const AddTVWatchlist(testTVDetail))).called(1);
  });

  testWidgets(
      'Tapping watchlist button when added should trigger RemoveTVWatchlist',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state)
        .thenReturn(const TVDetailLoaded(testTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(const TVRecommendationsLoaded([]));
    when(() => mockTVWatchlistStatusBloc.state).thenReturn(
        const TVWatchlistStatusState(isAddedToWatchlist: true, message: ''));

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    final watchlistButton = find.byType(FilledButton);
    await tester.tap(watchlistButton);

    verify(() => mockTVWatchlistStatusBloc
        .add(const RemoveTVWatchlist(testTVDetail))).called(1);
  });

  testWidgets(
      'Should display SnackBar when added to watchlist success',
      (WidgetTester tester) async {
    final streamController = StreamController<TVWatchlistStatusState>.broadcast();
    when(() => mockTVWatchlistStatusBloc.stream)
        .thenAnswer((_) => streamController.stream);
    when(() => mockTVDetailBloc.state)
        .thenReturn(const TVDetailLoaded(testTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(const TVRecommendationsLoaded([]));
    when(() => mockTVWatchlistStatusBloc.state).thenReturn(
        const TVWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    streamController.add(const TVWatchlistStatusState(
        isAddedToWatchlist: true, message: 'Added to Watchlist'));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);

    await streamController.close();
  });

  testWidgets(
      'Should display AlertDialog when watchlist operation fails',
      (WidgetTester tester) async {
    final streamController = StreamController<TVWatchlistStatusState>.broadcast();
    when(() => mockTVWatchlistStatusBloc.stream)
        .thenAnswer((_) => streamController.stream);
    when(() => mockTVDetailBloc.state)
        .thenReturn(const TVDetailLoaded(testTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(const TVRecommendationsLoaded([]));
    when(() => mockTVWatchlistStatusBloc.state).thenReturn(
        const TVWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    streamController.add(const TVWatchlistStatusState(
        isAddedToWatchlist: false, message: 'Failed'));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);

    await streamController.close();
  });

  testWidgets(
      'Tapping a season item and then episode should open episode video dialog',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state)
        .thenReturn(const TVDetailLoaded(testTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(const TVRecommendationsLoaded([]));
    when(() => mockTVWatchlistStatusBloc.state).thenReturn(
        const TVWatchlistStatusState(isAddedToWatchlist: false, message: ''));
    when(() => mockTVSeasonDetailBloc.state)
        .thenReturn(const TVSeasonDetailLoaded(testSeasonDetail));

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    final seasonText = find.text('Season 1');
    expect(seasonText, findsOneWidget);

    final inkWell = tester.widget<InkWell>(
      find.ancestor(
        of: seasonText,
        matching: find.byType(InkWell),
      ),
    );
    inkWell.onTap!();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Episodes List'), findsOneWidget);
    final episodeText = find.text('E1. Episode 1');
    expect(episodeText, findsOneWidget);

    final episodeInkWell = tester.widget<InkWell>(
      find.ancestor(
        of: episodeText,
        matching: find.byType(InkWell),
      ),
    );
    episodeInkWell.onTap!();
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Episode 1: Episode 1'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets(
      'Should display recommendation error text and recommendation items when loaded',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state)
        .thenReturn(const TVDetailLoaded(testTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(const TVRecommendationsError('Rec error'));
    when(() => mockTVWatchlistStatusBloc.state).thenReturn(
        const TVWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    expect(find.text('Rec error'), findsOneWidget);
  });

  testWidgets(
      'Should navigate to recommendation detail when item card is tapped',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state)
        .thenReturn(const TVDetailLoaded(testTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(TVRecommendationsLoaded(testTVList));
    when(() => mockTVWatchlistStatusBloc.state).thenReturn(
        const TVWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    final recommendationInkWell = tester.widget<InkWell>(
      find.descendant(
        of: find.byType(ListView).last,
        matching: find.byType(InkWell),
      ).first,
    );
    recommendationInkWell.onTap!();
    await tester.pumpAndSettle();

    expect(find.text('Recommendation Detail'), findsOneWidget);
  });

  testWidgets('Tapping back button should pop navigator',
      (WidgetTester tester) async {
    when(() => mockTVDetailBloc.state)
        .thenReturn(const TVDetailLoaded(testTVDetail));
    when(() => mockTVRecommendationsBloc.state)
        .thenReturn(const TVRecommendationsLoaded([]));
    when(() => mockTVWatchlistStatusBloc.state).thenReturn(
        const TVWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const TVDetailPage(id: 1)));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
  });
}
