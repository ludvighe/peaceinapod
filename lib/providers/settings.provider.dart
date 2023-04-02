import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  int _rewind = 10;
  int _fastForward = 10;

  int get rewind => _rewind;
  set rewind(int value) {
    _rewind = value;
    notifyListeners();
  }

  int get fastForward => _fastForward;
  set fastForward(int value) {
    _fastForward = value;
    notifyListeners();
  }
}
