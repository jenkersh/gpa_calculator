import 'package:flutter/material.dart';

class GPAProvider extends ChangeNotifier {
  double _currentGPA = 3.5;
  int _completedCredits = 30;
  double _targetGPA = 3.8;

  // Getters
  double get currentGPA => _currentGPA;
  int get completedCredits => _completedCredits;
  double get targetGPA => _targetGPA;

  // Setters
  void updateCurrentGPA(double newGPA) {
    _currentGPA = newGPA;
    notifyListeners();
  }

  void updateCompletedCredits(int newCredits) {
    _completedCredits = newCredits;
    notifyListeners();
  }

  void updateTargetGPA(double newTarget) {
    _targetGPA = newTarget;
    notifyListeners();
  }
}
