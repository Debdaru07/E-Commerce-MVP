import 'package:flutter/material.dart';

class LandingProvider extends ChangeNotifier {
  int highlightedFeature = 0;

  void setFeature(int index) {
    highlightedFeature = index;
    notifyListeners();
  }
}
