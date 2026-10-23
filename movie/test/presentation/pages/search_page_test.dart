import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieSearchBloc
    extends MockBloc<MovieSearchEvent, MovieSearchState>
    implements MovieSearchBloc {}

void main() {
  late MockMovieSearchBloc mockMovieSearchBloc;

  setUp(() {
    mockMovieSearchBloc = MockMovieSearchBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieSearchBloc>.value(
      value: mockMovieSearchBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockMovieSearchBloc.state).thenReturn(MovieSearchLoading());

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockMovieSearchBloc.state)
        .thenReturn(MovieSearchLoaded(testMovieList));

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(() => mockMovieSearchBloc.state)
        .thenReturn(const MovieSearchError('Error message'));

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Submitting query should trigger FetchMovieSearch',
      (WidgetTester tester) async {
    when(() => mockMovieSearchBloc.state).thenReturn(MovieSearchEmpty());

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    await tester.enterText(find.byType(TextField), 'spiderman');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    verify(() => mockMovieSearchBloc.add(const FetchMovieSearch('spiderman')))
        .called(1);
  });
}
