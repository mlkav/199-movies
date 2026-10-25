import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_search_page.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_search_page_test.mocks.dart';

@GenerateMocks([TVSearchNotifier])
void main() {
  late MockTVSearchNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTVSearchNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TVSearchNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
        onGenerateRoute: (settings) {
          if (settings.name == TVDetailPage.routeName) {
            return MaterialPageRoute(builder: (_) => const Text('TV Detail Page'));
          }
          return null;
        },
      ),
    );
  }

  testWidgets('Page should display CircularProgressIndicator when loading',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.loading);

    await tester.pumpWidget(makeTestableWidget(const TVSearchPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.loaded);
    when(mockNotifier.searchResult).thenReturn(<TV>[testTV]);

    await tester.pumpWidget(makeTestableWidget(const TVSearchPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
  });

  testWidgets('Should trigger search on query submitted',
      (WidgetTester tester) async {
    when(mockNotifier.state).thenReturn(RequestState.empty);
    when(mockNotifier.searchResult).thenReturn(<TV>[]);

    await tester.pumpWidget(makeTestableWidget(const TVSearchPage()));

    final textField = find.byType(TextField);
    await tester.enterText(textField, 'Game of Thrones');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(mockNotifier.fetchTVSearch('Game of Thrones'));
  });
}
