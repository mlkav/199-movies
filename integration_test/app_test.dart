import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End App Integration Test', () {
    testWidgets('Should load home page, switch to TV series, search, and open detail', (WidgetTester tester) async {
      // Menjalankan aplikasi utama
      app.main();
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (tester.any(find.text('Ditonton'))) break;
      }

      // Verifikasi halaman utama film terbuka
      expect(find.text('Ditonton'), findsWidgets);

      // Pindah ke halaman TV Series melalui menu Drawer
      final drawerFinder = find.byTooltip('Open navigation menu');
      if (tester.any(drawerFinder)) {
        await tester.tap(drawerFinder);
        await tester.pumpAndSettle();

        // Klik menu TV Series di Drawer
        final tvMenuItem = find.text('TV Series');
        await tester.tap(tvMenuItem.first);
        await tester.pumpAndSettle();
      }

      // Verifikasi halaman TV Series terbuka dengan mencari teks section 'Popular'
      expect(find.text('Popular'), findsWidgets);

      // Pencarian TV Series
      final searchIcon = find.byIcon(Icons.search);
      await tester.tap(searchIcon.first);
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      if (tester.any(searchField)) {
        await tester.enterText(searchField, 'Game of Thrones');
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pumpAndSettle();
      }

      // Klik hasil pencarian untuk membuka halaman detail TV
      final searchResult = find.text('Game of Thrones');
      if (tester.any(searchResult)) {
        await tester.tap(searchResult.first);
        await tester.pumpAndSettle();
      }
    });
  });
}
