import 'package:core/common/analytics_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'analytics_service_test.mocks.dart';

@GenerateMocks([FirebaseAnalytics])
void main() {
  late AnalyticsService analyticsService;
  late MockFirebaseAnalytics mockFirebaseAnalytics;

  setUp(() {
    mockFirebaseAnalytics = MockFirebaseAnalytics();
    analyticsService = AnalyticsService(analytics: mockFirebaseAnalytics);
  });

  test('logAppOpen should call firebaseAnalytics.logAppOpen', () async {
    when(mockFirebaseAnalytics.logAppOpen()).thenAnswer((_) async {});

    await analyticsService.logAppOpen();

    verify(mockFirebaseAnalytics.logAppOpen()).called(1);
  });

  test('logSearch should call firebaseAnalytics.logSearch and logEvent',
      () async {
    when(mockFirebaseAnalytics.logSearch(
      searchTerm: 'spiderman',
    )).thenAnswer((_) async {});
    when(mockFirebaseAnalytics.logEvent(
      name: 'search_content',
      parameters: {'search_term': 'spiderman', 'category': 'movie'},
    )).thenAnswer((_) async {});

    await analyticsService.logSearch(
        searchTerm: 'spiderman', category: 'movie');

    verify(mockFirebaseAnalytics.logSearch(searchTerm: 'spiderman')).called(1);
    verify(mockFirebaseAnalytics.logEvent(
      name: 'search_content',
      parameters: {'search_term': 'spiderman', 'category': 'movie'},
    )).called(1);
  });

  test(
      'logSelectContent should call firebaseAnalytics.logSelectContent and logEvent',
      () async {
    when(mockFirebaseAnalytics.logSelectContent(
      contentType: 'movie',
      itemId: '1',
    )).thenAnswer((_) async {});
    when(mockFirebaseAnalytics.logEvent(
      name: 'view_item',
      parameters: {
        'content_type': 'movie',
        'item_id': '1',
        'item_name': 'Spiderman'
      },
    )).thenAnswer((_) async {});

    await analyticsService.logSelectContent(
        contentType: 'movie', itemId: '1', title: 'Spiderman');

    verify(mockFirebaseAnalytics.logSelectContent(
            contentType: 'movie', itemId: '1'))
        .called(1);
    verify(mockFirebaseAnalytics.logEvent(
      name: 'view_item',
      parameters: {
        'content_type': 'movie',
        'item_id': '1',
        'item_name': 'Spiderman'
      },
    )).called(1);
  });

  test('logAddToWatchlist should call firebaseAnalytics.logEvent', () async {
    when(mockFirebaseAnalytics.logEvent(
      name: 'add_to_wishlist',
      parameters: {
        'content_type': 'movie',
        'item_id': '1',
        'item_name': 'Spiderman'
      },
    )).thenAnswer((_) async {});

    await analyticsService.logAddToWatchlist(
        contentType: 'movie', itemId: '1', title: 'Spiderman');

    verify(mockFirebaseAnalytics.logEvent(
      name: 'add_to_wishlist',
      parameters: {
        'content_type': 'movie',
        'item_id': '1',
        'item_name': 'Spiderman'
      },
    )).called(1);
  });

  test('logRemoveFromWatchlist should call firebaseAnalytics.logEvent',
      () async {
    when(mockFirebaseAnalytics.logEvent(
      name: 'remove_from_wishlist',
      parameters: {
        'content_type': 'movie',
        'item_id': '1',
        'item_name': 'Spiderman'
      },
    )).thenAnswer((_) async {});

    await analyticsService.logRemoveFromWatchlist(
        contentType: 'movie', itemId: '1', title: 'Spiderman');

    verify(mockFirebaseAnalytics.logEvent(
      name: 'remove_from_wishlist',
      parameters: {
        'content_type': 'movie',
        'item_id': '1',
        'item_name': 'Spiderman'
      },
    )).called(1);
  });
}
