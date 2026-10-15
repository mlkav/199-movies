import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiKey {
    if (!dotenv.isInitialized) return '';
    return dotenv.env['API_KEY'] ?? '';
  }

  static String get baseUrl {
    if (!dotenv.isInitialized) return '';
    return dotenv.env['BASE_URL'] ?? '';
  }

  static String get baseImageUrl {
    if (!dotenv.isInitialized) return '';
    return dotenv.env['BASE_IMAGE_URL'] ?? '';
  }
}
