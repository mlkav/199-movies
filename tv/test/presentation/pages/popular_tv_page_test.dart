import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockPopularTVBloc extends MockBloc<PopularTVEvent, PopularTVState>
    implements PopularTVBloc {}

void main() {
  late MockPopularTVBloc mockPopularTVBloc;

  setUp(() {
    mockPopularTVBloc = MockPopularTVBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTVBloc>.value(
      value: mockPopularTVBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockPopularTVBloc.state).thenReturn(PopularTVLoading());

    await tester.pumpWidget(makeTestableWidget(const PopularTVPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView and TVCard when data is loaded',
      (WidgetTester tester) async {
    when(() => mockPopularTVBloc.state)
        .thenReturn(PopularTVLoaded(testTVList));

    await tester.pumpWidget(makeTestableWidget(const PopularTVPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TVCard), findsOneWidget);
  });

  testWidgets('Page should display text with message when error',
      (WidgetTester tester) async {
    when(() => mockPopularTVBloc.state)
        .thenReturn(const PopularTVError('Error message'));

    await tester.pumpWidget(makeTestableWidget(const PopularTVPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
