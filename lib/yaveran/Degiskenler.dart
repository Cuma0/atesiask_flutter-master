import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:just_audio_background/just_audio_background.dart';

class Degiskenler {
  static final Degiskenler _instance = Degiskenler._internal();
  int versionMenba = 0;

  //String kaynakYolu=".";
  //String kaynakYolu="https://kardelendergisi.com/atesiask";
  String kaynakYolu="https://raw.githubusercontent.com/emreaksel/atesiask/main/flutter";

  static var currentEpigramNotifier = ValueNotifier<String>('...');
  static var songListNotifier = ValueNotifier<List<dynamic>>([]);


  List<dynamic> dinlemeListeleri=[];
  List<dynamic> listSozler=[];
  List<dynamic> listDinle=[];

  /*final Map<String, List<VoidCallback>> _variableListeners = {};
  void addListenerForVariable(String variable, VoidCallback listener) {
    if (!_variableListeners.containsKey(variable)) {
      _variableListeners[variable] = [];
    }
    _variableListeners[variable]!.add(listener);
  }
  void removeListenerForVariable(String variable, VoidCallback listener) {
    _variableListeners[variable]?.remove(listener);
  }
  void notifyListenersForVariable(String variable) {
    _variableListeners[variable]?.forEach((listener) => listener());
  }*/

  factory Degiskenler() {
    return _instance;
  }

  Degiskenler._internal();
}