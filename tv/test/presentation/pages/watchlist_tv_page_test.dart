import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockWatchlistTVBloc
    extends MockBloc<WatchlistTVEvent, WatchlistTVState>
    implements WatchlistTVBloc {}

void main() {
  late MockWatchlistTVBloc mockWatchlistTVBloc;

  setUp(() {
    mockWatchlistTVBloc = MockWatchlistTVBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTVBloc>.value(
      value: mockWatchlistTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockWatchlistTVBloc.state).thenReturn(WatchlistTVLoading());

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView and TVCard when data is loaded',
      (WidgetTester tester) async {
    when(() => mockWatchlistTVBloc.state)
        .thenReturn(const WatchlistTVLoaded([testWatchlistTV]));

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TVCard), findsOneWidget);
  });

  testWidgets('Page should display text with message when error',
      (WidgetTester tester) async {
    when(() => mockWatchlistTVBloc.state)
        .thenReturn(const WatchlistTVError('Error message'));

    await tester.pumpWidget(makeTestableWidget(const WatchlistTVPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
