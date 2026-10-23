import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class GetTopRatedTV {
  final TVRepository repository;

  GetTopRatedTV({required this.repository});

  Future<Either<Failure, List<TV>>> execute() {
    return repository.getTopRatedTV();
  }
}
