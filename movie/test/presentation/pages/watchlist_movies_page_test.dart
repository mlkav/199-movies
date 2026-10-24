import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

void main() {
  late MockWatchlistMovieBloc mockWatchlistMovieBloc;

  setUp(() {
    mockWatchlistMovieBloc = MockWatchlistMovieBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMovieBloc>.value(
      value: mockWatchlistMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockWatchlistMovieBloc.state)
        .thenReturn(WatchlistMovieLoading());

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView and MovieCard when data is loaded',
      (WidgetTester tester) async {
    when(() => mockWatchlistMovieBloc.state)
        .thenReturn(const WatchlistMovieLoaded([testWatchlistMovie]));

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
  });

  testWidgets('Page should display empty watchlist message when list is empty',
      (WidgetTester tester) async {
    when(() => mockWatchlistMovieBloc.state)
        .thenReturn(const WatchlistMovieLoaded([]));

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(find.byKey(const Key('empty_watchlist')), findsOneWidget);
    expect(find.text('Watchlist is still empty'), findsOneWidget);
  });

  testWidgets('Page should display text with message when error',
      (WidgetTester tester) async {
    when(() => mockWatchlistMovieBloc.state)
        .thenReturn(const WatchlistMovieError('Error message'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
