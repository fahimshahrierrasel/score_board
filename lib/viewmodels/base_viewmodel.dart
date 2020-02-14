import 'package:flutter/cupertino.dart';
import 'package:score_board/viewmodels/view_state.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;
  ViewState get state => _state;

  void setViewState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }
}
