
import 'package:flutter/cupertino.dart';

class SetState with ChangeNotifier{

  bool _SetState;

  bool get setState => _SetState;

  set setState(bool value) {
    _SetState = value;
    notifyListeners();
  }
}