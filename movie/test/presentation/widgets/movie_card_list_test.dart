import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  testWidgets('MovieCard should display title and overview and navigate on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      routes: {
        MovieDetailPage.routeName: (_) =>
            const Scaffold(body: Text('Movie Detail Page')),
      },
      home: const Scaffold(
        body: MovieCard(testMovie),
      ),
    ));

    expect(find.text(testMovie.title!), findsOneWidget);
    expect(find.text(testMovie.overview!), findsOneWidget);

    await tester.tap(find.byType(MovieCard));
    await tester.pumpAndSettle();

    expect(find.text('Movie Detail Page'), findsOneWidget);
  });
}
