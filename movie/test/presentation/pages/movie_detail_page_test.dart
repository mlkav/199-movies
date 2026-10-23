import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc
    extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MockMovieRecommendationsBloc
    extends MockBloc<MovieRecommendationsEvent, MovieRecommendationsState>
    implements MovieRecommendationsBloc {}

class MockMovieWatchlistStatusBloc
    extends MockBloc<MovieWatchlistStatusEvent, MovieWatchlistStatusState>
    implements MovieWatchlistStatusBloc {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieRecommendationsBloc mockMovieRecommendationsBloc;
  late MockMovieWatchlistStatusBloc mockMovieWatchlistStatusBloc;

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieRecommendationsBloc = MockMovieRecommendationsBloc();
    mockMovieWatchlistStatusBloc = MockMovieWatchlistStatusBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailBloc>.value(value: mockMovieDetailBloc),
        BlocProvider<MovieRecommendationsBloc>.value(
            value: mockMovieRecommendationsBloc),
        BlocProvider<MovieWatchlistStatusBloc>.value(
            value: mockMovieWatchlistStatusBloc),
      ],
      child: MaterialApp(
        home: body,
        routes: {
          MovieDetailPage.routeName: (_) =>
              const Scaffold(body: Text('Recommendation Detail')),
        },
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailLoading());
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsLoading());
    when(() => mockMovieWatchlistStatusBloc.state).thenReturn(
        const MovieWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display error text when detail error',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(const MovieDetailError('Error message'));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsLoading());
    when(() => mockMovieWatchlistStatusBloc.state).thenReturn(
        const MovieWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(const MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(const MovieRecommendationsLoaded([]));
    when(() => mockMovieWatchlistStatusBloc.state).thenReturn(
        const MovieWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(const MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(const MovieRecommendationsLoaded([]));
    when(() => mockMovieWatchlistStatusBloc.state).thenReturn(
        const MovieWatchlistStatusState(isAddedToWatchlist: true, message: ''));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Tapping watchlist button when not added should trigger AddMovieWatchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(const MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(const MovieRecommendationsLoaded([]));
    when(() => mockMovieWatchlistStatusBloc.state).thenReturn(
        const MovieWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    final watchlistButton = find.byType(FilledButton);
    await tester.tap(watchlistButton);

    verify(() => mockMovieWatchlistStatusBloc
        .add(const AddMovieWatchlist(testMovieDetail))).called(1);
  });

  testWidgets(
      'Tapping watchlist button when added should trigger RemoveMovieWatchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(const MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(const MovieRecommendationsLoaded([]));
    when(() => mockMovieWatchlistStatusBloc.state).thenReturn(
        const MovieWatchlistStatusState(isAddedToWatchlist: true, message: ''));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    final watchlistButton = find.byType(FilledButton);
    await tester.tap(watchlistButton);

    verify(() => mockMovieWatchlistStatusBloc
        .add(const RemoveMovieWatchlist(testMovieDetail))).called(1);
  });

  testWidgets(
      'Should display SnackBar when added to watchlist success',
      (WidgetTester tester) async {
    final streamController = StreamController<MovieWatchlistStatusState>.broadcast();
    when(() => mockMovieWatchlistStatusBloc.stream)
        .thenAnswer((_) => streamController.stream);
    when(() => mockMovieDetailBloc.state)
        .thenReturn(const MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(const MovieRecommendationsLoaded([]));
    when(() => mockMovieWatchlistStatusBloc.state).thenReturn(
        const MovieWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    streamController.add(const MovieWatchlistStatusState(
        isAddedToWatchlist: true, message: 'Added to Watchlist'));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);

    await streamController.close();
  });

  testWidgets(
      'Should display AlertDialog when watchlist operation fails',
      (WidgetTester tester) async {
    final streamController = StreamController<MovieWatchlistStatusState>.broadcast();
    when(() => mockMovieWatchlistStatusBloc.stream)
        .thenAnswer((_) => streamController.stream);
    when(() => mockMovieDetailBloc.state)
        .thenReturn(const MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(const MovieRecommendationsLoaded([]));
    when(() => mockMovieWatchlistStatusBloc.state).thenReturn(
        const MovieWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    streamController.add(const MovieWatchlistStatusState(
        isAddedToWatchlist: false, message: 'Failed'));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);

    await streamController.close();
  });

  testWidgets(
      'Should display recommendation error text when recommendation fails',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(const MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(const MovieRecommendationsError('Rec error'));
    when(() => mockMovieWatchlistStatusBloc.state).thenReturn(
        const MovieWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.text('Rec error'), findsOneWidget);
  });

  testWidgets(
      'Should navigate to recommendation detail when item card is tapped',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(const MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(MovieRecommendationsLoaded(testMovieList));
    when(() => mockMovieWatchlistStatusBloc.state).thenReturn(
        const MovieWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    final recommendationInkWell = tester.widget<InkWell>(
      find.descendant(
        of: find.byType(ListView),
        matching: find.byType(InkWell),
      ).first,
    );
    recommendationInkWell.onTap!();
    await tester.pumpAndSettle();

    expect(find.text('Recommendation Detail'), findsOneWidget);
  });

  testWidgets('Tapping back button should pop navigator',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(const MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieRecommendationsBloc.state)
        .thenReturn(const MovieRecommendationsLoaded([]));
    when(() => mockMovieWatchlistStatusBloc.state).thenReturn(
        const MovieWatchlistStatusState(isAddedToWatchlist: false, message: ''));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
  });
}
