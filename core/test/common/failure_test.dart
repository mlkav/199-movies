import 'package:core/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ServerFailure props should contain message', () {
    const failure = ServerFailure('Server Failure');
    expect(failure.props, ['Server Failure']);
  });

  test('ConnectionFailure props should contain message', () {
    const failure = ConnectionFailure('Connection Failure');
    expect(failure.props, ['Connection Failure']);
  });

  test('DatabaseFailure props should contain message', () {
    const failure = DatabaseFailure('Database Failure');
    expect(failure.props, ['Database Failure']);
  });

  test('SSLFailure props should contain message', () {
    const failure = SSLFailure('SSL Failure');
    expect(failure.props, ['SSL Failure']);
  });
}
