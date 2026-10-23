import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  testWidgets('TVCard should display name and overview and navigate on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      routes: {
        TVDetailPage.routeName: (_) =>
            const Scaffold(body: Text('TV Detail Page')),
      },
      home: const Scaffold(
        body: TVCard(testTV),
      ),
    ));

    expect(find.text(testTV.name!), findsOneWidget);
    expect(find.text(testTV.overview!), findsOneWidget);

    await tester.tap(find.byType(TVCard));
    await tester.pumpAndSettle();

    expect(find.text('TV Detail Page'), findsOneWidget);
  });
}
