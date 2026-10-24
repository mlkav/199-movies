import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/search_tv.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_event.dart';
import 'package:tv/presentation/bloc/tv_search/tv_search_state.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTV])
void main() {
  late TVSearchBloc tvSearchBloc;
  late MockSearchTV mockSearchTV;

  setUp(() {
    mockSearchTV = MockSearchTV();
    tvSearchBloc = TVSearchBloc(mockSearchTV);
  });

  const tQuery = 'Game of Thrones';

  test('initialState should be TVSearchEmpty', () {
    expect(tvSearchBloc.state, TVSearchEmpty());
  });

  blocTest<TVSearchBloc, TVSearchState>(
    'Should emit [TVSearchLoading, TVSearchLoaded] when data is gotten successfully',
    build: () {
      when(mockSearchTV.execute(tQuery))
          .thenAnswer((_) async => Right(testTVList));
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(const FetchTVSearch(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TVSearchLoading(),
      TVSearchLoaded(testTVList),
    ],
    verify: (bloc) {
      verify(mockSearchTV.execute(tQuery));
    },
  );

  blocTest<TVSearchBloc, TVSearchState>(
    'Should emit [TVSearchLoading, TVSearchError] when search is unsuccessful',
    build: () {
      when(mockSearchTV.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(const FetchTVSearch(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TVSearchLoading(),
      const TVSearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTV.execute(tQuery));
    },
  );
}
