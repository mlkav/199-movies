import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TVRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TVRemoteDataSourceImpl(
      client: mockHttpClient,
      apiKey: apiKey,
      baseUrl: baseUrl,
    );
  });

  test('should initialize with default AppConfig values', () {
    dotenv.testLoad(
      fileInput: 'API_KEY=test_key\n'
          'BASE_URL=https://api.themoviedb.org/3\n',
    );

    final dataSource = TVRemoteDataSourceImpl(
      client: mockHttpClient,
    );

    expect(dataSource.apiKey, equals('test_key'));
    expect(dataSource.baseUrl, equals('https://api.themoviedb.org/3'));
  });

  group('get Now Playing TV', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv_on_the_air.json')))
        .tvList;

    test('should return list of TV Model when the response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_on_the_air.json'), 200));

      final result = await dataSource.getNowPlayingTV();

      expect(result, equals(tTVList));
    });

    test('should throw a ServerException when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getNowPlayingTV();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular TV', () {
    final tTVList =
        TVResponse.fromJson(json.decode(readJson('dummy_data/tv_popular.json')))
            .tvList;

    test('should return list of TV when response is success (200)', () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_popular.json'), 200));

      final result = await dataSource.getPopularTV();

      expect(result, tTVList);
    });

    test('should throw a ServerException when response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getPopularTV();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TV', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv_top_rated.json')))
        .tvList;

    test('should return list of TV when response code is 200', () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_top_rated.json'), 200));

      final result = await dataSource.getTopRatedTV();

      expect(result, tTVList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTopRatedTV();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV detail', () {
    const tId = 1;
    final tTVDetail = TVDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_detail.json')));

    test('should return TV detail when the response code is 200', () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_detail.json'), 200));

      final result = await dataSource.getTVDetail(tId);

      expect(result, equals(tTVDetail));
    });

    test('should throw Server Exception when response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTVDetail(tId);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV recommendations', () {
    final tTVList = TVResponse.fromJson(
            json.decode(readJson('dummy_data/tv_recommendations.json')))
        .tvList;
    const tId = 1;

    test('should return list of TV Model when response code is 200', () async {
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_recommendations.json'), 200));

      final result = await dataSource.getTVRecommendations(tId);

      expect(result, equals(tTVList));
    });

    test('should throw Server Exception when response code is 404 or other',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTVRecommendations(tId);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search TV', () {
    final tSearchResult = TVResponse.fromJson(
            json.decode(readJson('dummy_data/search_got_tv.json')))
        .tvList;
    const tQuery = 'Game of Thrones';

    test('should return list of TV when response code is 200', () async {
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/search_got_tv.json'), 200));

      final result = await dataSource.searchTV(tQuery);

      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      when(mockHttpClient
              .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.searchTV(tQuery);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
