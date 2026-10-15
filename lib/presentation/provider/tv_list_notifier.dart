import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter/material.dart';

class TVListNotifier extends ChangeNotifier {
  var _nowPlayingTV = <TV>[];
  List<TV> get nowPlayingTV => _nowPlayingTV;

  RequestState _nowPlayingState = RequestState.empty;
  RequestState get nowPlayingState => _nowPlayingState;

  var _popularTV = <TV>[];
  List<TV> get popularTV => _popularTV;

  RequestState _popularTVState = RequestState.empty;
  RequestState get popularTVState => _popularTVState;

  var _topRatedTV = <TV>[];
  List<TV> get topRatedTV => _topRatedTV;

  RequestState _topRatedTVState = RequestState.empty;
  RequestState get topRatedTVState => _topRatedTVState;

  String _message = '';
  String get message => _message;

  TVListNotifier({
    required this.getNowPlayingTV,
    required this.getPopularTV,
    required this.getTopRatedTV,
  });

  final GetNowPlayingTV getNowPlayingTV;
  final GetPopularTV getPopularTV;
  final GetTopRatedTV getTopRatedTV;

  Future<void> fetchNowPlayingTV() async {
    _nowPlayingState = RequestState.loading;
    notifyListeners();

    final result = await getNowPlayingTV.execute();
    result.fold(
      (failure) {
        _nowPlayingState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _nowPlayingState = RequestState.loaded;
        _nowPlayingTV = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTV() async {
    _popularTVState = RequestState.loading;
    notifyListeners();

    final result = await getPopularTV.execute();
    result.fold(
      (failure) {
        _popularTVState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _popularTVState = RequestState.loaded;
        _popularTV = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTV() async {
    _topRatedTVState = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedTV.execute();
    result.fold(
      (failure) {
        _topRatedTVState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _topRatedTVState = RequestState.loaded;
        _topRatedTV = tvData;
        notifyListeners();
      },
    );
  }
}
