import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter/foundation.dart';

class TopRatedTVNotifier extends ChangeNotifier {
  final GetTopRatedTV getTopRatedTV;

  TopRatedTVNotifier({required this.getTopRatedTV});

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<TV> _tvList = [];
  List<TV> get tvList => _tvList;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTV() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedTV.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (tvData) {
        _tvList = tvData;
        _state = RequestState.loaded;
        notifyListeners();
      },
    );
  }
}
