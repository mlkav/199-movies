import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'search_page_test.mocks.dart';

@GenerateMocks([MovieSearchNotifier])
void main() {
  late MockMovieSearchNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMovieSearchNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieSearchNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
        onGenerateRoute: (settings) {
          if (settings.name == MovieDetailPage.routeName) {
            return MaterialPageRoute(builder: (_) => const Text('Movie Detail Page'));
          }
          return null;
        },
      ),
    );
  }

  testWidgets('Page should display CircularProgressIndicator when loading',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.loading);

    await tester.pumpWidget(makeTestableWidget(SearchPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.searchResult).thenReturn(<Movie>[testMovie]);

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Spider-Man'), findsOneWidget);
  });

  testWidgets('Should trigger search on query submitted',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.empty);
    when(mockNotifier.searchResult).thenReturn(<Movie>[]);

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    final textField = find.byType(TextField);
    await tester.enterText(textField, 'Spider-Man');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(mockNotifier.fetchMovieSearch('Spider-Man'));
  });
}
