import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTopRatedTVBloc extends MockBloc<TopRatedTVEvent, TopRatedTVState>
    implements TopRatedTVBloc {}

void main() {
  late MockTopRatedTVBloc mockTopRatedTVBloc;

  setUp(() {
    mockTopRatedTVBloc = MockTopRatedTVBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVBloc>.value(
      value: mockTopRatedTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTopRatedTVBloc.state).thenReturn(TopRatedTVLoading());

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView and TVCard when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTopRatedTVBloc.state)
        .thenReturn(TopRatedTVLoaded(testTVList));

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TVCard), findsOneWidget);
  });

  testWidgets('Page should display text with message when error',
      (WidgetTester tester) async {
    when(() => mockTopRatedTVBloc.state)
        .thenReturn(const TopRatedTVError('Error message'));

    await tester.pumpWidget(makeTestableWidget(const TopRatedTVPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
