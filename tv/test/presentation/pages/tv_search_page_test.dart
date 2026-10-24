import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTVSearchBloc extends MockBloc<TVSearchEvent, TVSearchState>
    implements TVSearchBloc {}

void main() {
  late MockTVSearchBloc mockTVSearchBloc;

  setUp(() {
    mockTVSearchBloc = MockTVSearchBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TVSearchBloc>.value(
      value: mockTVSearchBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTVSearchBloc.state).thenReturn(TVSearchLoading());

    await tester.pumpWidget(makeTestableWidget(const TVSearchPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTVSearchBloc.state).thenReturn(TVSearchLoaded(testTVList));

    await tester.pumpWidget(makeTestableWidget(const TVSearchPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(TVCard), findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(() => mockTVSearchBloc.state)
        .thenReturn(const TVSearchError('Error message'));

    await tester.pumpWidget(makeTestableWidget(const TVSearchPage()));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Submitting query should trigger FetchTVSearch',
      (WidgetTester tester) async {
    when(() => mockTVSearchBloc.state).thenReturn(TVSearchEmpty());

    await tester.pumpWidget(makeTestableWidget(const TVSearchPage()));

    await tester.enterText(find.byType(TextField), 'got');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    verify(() => mockTVSearchBloc.add(const FetchTVSearch('got')))
        .called(greaterThanOrEqualTo(1));
  });
}
