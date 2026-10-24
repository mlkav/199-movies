import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService({FirebaseAnalytics? analytics})
      : _analytics = analytics ?? FirebaseAnalytics.instance;

  Future<void> logAppOpen() async {
    try {
      await _analytics.logAppOpen();
    } catch (_) {}
  }

  Future<void> logSearch({
    required String searchTerm,
    required String category,
  }) async {
    try {
      await _analytics.logSearch(
        searchTerm: searchTerm,
      );
      await _analytics.logEvent(
        name: 'search_content',
        parameters: {
          'search_term': searchTerm,
          'category': category,
        },
      );
    } catch (_) {}
  }

  Future<void> logSelectContent({
    required String contentType,
    required String itemId,
    required String title,
  }) async {
    try {
      await _analytics.logSelectContent(
        contentType: contentType,
        itemId: itemId,
      );
      await _analytics.logEvent(
        name: 'view_item',
        parameters: {
          'content_type': contentType,
          'item_id': itemId,
          'item_name': title,
        },
      );
    } catch (_) {}
  }

  Future<void> logAddToWatchlist({
    required String contentType,
    required String itemId,
    required String title,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'add_to_wishlist',
        parameters: {
          'content_type': contentType,
          'item_id': itemId,
          'item_name': title,
        },
      );
    } catch (_) {}
  }

  Future<void> logRemoveFromWatchlist({
    required String contentType,
    required String itemId,
    required String title,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'remove_from_wishlist',
        parameters: {
          'content_type': contentType,
          'item_id': itemId,
          'item_name': title,
        },
      );
    } catch (_) {}
  }
}
