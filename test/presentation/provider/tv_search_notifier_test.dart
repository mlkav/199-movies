import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTV])
void main() {
  late TVSearchNotifier notifier;
  late MockSearchTV mockSearchTV;

  setUp(() {
    mockSearchTV = MockSearchTV();
    notifier = TVSearchNotifier(searchTV: mockSearchTV);
  });

  const tQuery = 'Game of Thrones';
  final tTVList = <TV>[testTV];

  test('should change state to Loading when usecase is called', () async {
    // arrange
    when(mockSearchTV.execute(tQuery))
        .thenAnswer((_) async => Right(tTVList));
    // act
    notifier.fetchTVSearch(tQuery);
    // assert
    expect(notifier.state, RequestState.loading);
  });

  test('should change search result when data is gotten successfully', () async {
    // arrange
    when(mockSearchTV.execute(tQuery))
        .thenAnswer((_) async => Right(tTVList));
    // act
    await notifier.fetchTVSearch(tQuery);
    // assert
    expect(notifier.state, RequestState.loaded);
    expect(notifier.searchResult, tTVList);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockSearchTV.execute(tQuery))
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchTVSearch(tQuery);
    // assert
    expect(notifier.state, RequestState.error);
    expect(notifier.message, 'Server Failure');
  });
}
