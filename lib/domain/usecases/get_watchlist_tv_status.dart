import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetWatchListTVStatus {
  final TVRepository repository;

  GetWatchListTVStatus(this.repository);

  Future<bool> execute(int id) {
    return repository.isAddedToWatchlistTV(id);
  }
}
