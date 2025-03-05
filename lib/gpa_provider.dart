import 'package:flutter/material.dart';

class GPAProvider extends ChangeNotifier {
  double _previousGrade = 3.5;
  int _previousCredits = 30;
  double _targetGPA = 3.8;

  // Getters
  double get previousGrade => _previousGrade;
  int get previousCredits => _previousCredits;
  double get targetGPA => _targetGPA;

  // Setters
  void updateCurrentGPA(double newGPA) {
    _previousGrade = newGPA;
    notifyListeners();
  }

  void updateCompletedCredits(int newCredits) {
    _previousCredits = newCredits;
    notifyListeners();
  }

  void updateTargetGPA(double newTarget) {
    _targetGPA = newTarget;
    notifyListeners();
  }
}
