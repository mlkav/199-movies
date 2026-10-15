import 'package:ditonton/common/config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    dotenv.testLoad(
      fileInput: 'API_KEY=test_key\n'
          'BASE_URL=test_url\n'
          'BASE_IMAGE_URL=test_image_url\n',
    );
  });

  test('AppConfig getters should return values from .env', () {
    expect(AppConfig.apiKey, equals('test_key'));
    expect(AppConfig.baseUrl, equals('test_url'));
    expect(AppConfig.baseImageUrl, equals('test_image_url'));
  });

  test('AppConfig apiKey should be empty when API_KEY is missing', () {
    dotenv.testLoad(
      fileInput: 'BASE_URL=test_url\n'
          'BASE_IMAGE_URL=test_image_url\n',
    );

    expect(AppConfig.apiKey, isEmpty);
  });
}
