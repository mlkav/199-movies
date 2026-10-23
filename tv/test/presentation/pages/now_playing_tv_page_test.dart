import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNowPlayingTVBloc
    extends MockBloc<NowPlayingTVEvent, NowPlayingTVState>
    implements NowPlayingTVBloc {}

void main() {
  late MockNowPlayingTVBloc mockNowPlayingTVBloc;

  setUp(() {
    mockNowPlayingTVBloc = MockNowPlayingTVBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingTVBloc>.value(
      value: mockNowPlayingTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state).thenReturn(NowPlayingTVLoading());

    await tester.pumpWidget(makeTestableWidget(const NowPlayingTVPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView and TVCard when data is loaded',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state)
        .thenReturn(NowPlayingTVLoaded(testTVList));

    await tester.pumpWidget(makeTestableWidget(const NowPlayingTVPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TVCard), findsOneWidget);
  });

  testWidgets('Page should display text with message when error',
      (WidgetTester tester) async {
    when(() => mockNowPlayingTVBloc.state)
        .thenReturn(const NowPlayingTVError('Error message'));

    await tester.pumpWidget(makeTestableWidget(const NowPlayingTVPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
