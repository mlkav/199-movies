import 'package:ditonton/common/constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    dotenv.testLoad(
      fileInput: 'API_KEY=test_api_key\n'
          'BASE_URL=https://api.themoviedb.org/3\n'
          'BASE_IMAGE_URL=https://image.tmdb.org/t/p/w500\n',
    );
  });

  test('constants variables should be accessible', () {
    expect(BASE_IMAGE_URL, isNotEmpty);
    expect(
      BASE_IMAGE_URL,
      equals('https://image.tmdb.org/t/p/w500'),
    );
    expect(kHeading5.fontSize, 23);
    expect(kHeading6.fontSize, 19);
    expect(kSubtitle.fontSize, 15);
    expect(kBodyText.fontSize, 13);
    expect(kTextTheme.headlineMedium, equals(kHeading5));
    expect(kDrawerTheme, isNotNull);
    expect(kColorScheme.primary, equals(kMikadoYellow));
  });
}
