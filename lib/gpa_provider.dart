import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GPAProvider extends ChangeNotifier {
  double _previousGrade = 0.0;
  int _previousCredits = 0;
  double _targetGPA = 0.0;
  bool _showPreviousCourses = false;

  double get previousGrade => _previousGrade;
  int get previousCredits => _previousCredits;
  double get targetGPA => _targetGPA;
  bool get showPreviousCourses => _showPreviousCourses;

  GPAProvider() {
    _loadPreferences();  // Load saved preferences when the provider is initialized
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _showPreviousCourses = prefs.getBool('showPreviousCourses') ?? false;
    notifyListeners();
  }

  Future<void> togglePreviousCourses(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _showPreviousCourses = value;
    await prefs.setBool('showPreviousCourses', value);
    notifyListeners();
  }

  void updateCurrentGPA(double grade) {
    _previousGrade = grade;
    notifyListeners();
  }

  void updateCompletedCredits(int credits) {
    _previousCredits = credits;
    notifyListeners();
  }

  void updateTargetGPA(double gpa) {
    _targetGPA = gpa;
    notifyListeners();
  }
}
