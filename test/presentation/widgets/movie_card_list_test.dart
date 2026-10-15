import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == MovieDetailPage.routeName) {
          return MaterialPageRoute(
            builder: (_) => const Text('Movie Detail Page'),
          );
        }
        return null;
      },
    );
  }

  testWidgets('MovieCard should display title and overview and navigate on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(MovieCard(testMovie)));

    expect(find.text('Spider-Man'), findsOneWidget);

    final image = tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
    final errorWidget = image.errorWidget!(tester.element(find.byType(CachedNetworkImage)), 'url', 'error');
    expect(errorWidget, isA<Icon>());

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Movie Detail Page'), findsOneWidget);
  });
}
