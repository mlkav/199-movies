import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';

import 'get_watchlist_tv_status_test.mocks.dart';

@GenerateMocks([TVRepository])
void main() {
  late GetWatchListTVStatus usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetWatchListTVStatus(mockTVRepository);
  });

  test('should get watchlist TV status from the repository', () async {
    when(mockTVRepository.isAddedToWatchlistTV(1))
        .thenAnswer((_) async => true);

    final result = await usecase.execute(1);

    expect(result, true);
  });
}
