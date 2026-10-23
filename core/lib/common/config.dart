import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiKey {
    if (dotenv.isInitialized) {
      return dotenv.env['API_KEY'] ??
          'api_key=2174d146bb9c0eab47529b2e77d6b526';
    }
    return 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  }

  static String get baseUrl {
    if (dotenv.isInitialized) {
      return dotenv.env['BASE_URL'] ?? 'https://api.themoviedb.org/3';
    }
    return 'https://api.themoviedb.org/3';
  }

  static String get baseImageUrl {
    if (dotenv.isInitialized) {
      return dotenv.env['BASE_IMAGE_URL'] ?? 'https://image.tmdb.org/t/p/w500';
    }
    return 'https://image.tmdb.org/t/p/w500';
  }
}
