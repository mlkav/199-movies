import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
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
        if (settings.name == TVDetailPage.routeName) {
          return MaterialPageRoute(
            builder: (_) => const Text('TV Detail Page'),
          );
        }
        return null;
      },
    );
  }

  testWidgets('TVCard should display title and overview and navigate on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(TVCard(testTV)));

    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);

    final image = tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
    final errorWidget = image.errorWidget!(tester.element(find.byType(CachedNetworkImage)), 'url', 'error');
    expect(errorWidget, isA<Icon>());

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('TV Detail Page'), findsOneWidget);
  });
}
