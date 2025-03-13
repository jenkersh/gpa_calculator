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
    _loadPreferences(); // Load saved preferences when the provider initializes
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _previousGrade = prefs.getDouble('previousGrade') ?? 0.0;
    _previousCredits = prefs.getInt('previousCredits') ?? 0;
    _targetGPA = prefs.getDouble('targetGPA') ?? 0.0;
    _showPreviousCourses = prefs.getBool('showPreviousCourses') ?? false;
    notifyListeners();
  }

  Future<void> togglePreviousCourses(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _showPreviousCourses = value;
    await prefs.setBool('showPreviousCourses', value);
    notifyListeners();
  }

  Future<void> updateCurrentGPA(double grade) async {
    final prefs = await SharedPreferences.getInstance();
    _previousGrade = grade;
    await prefs.setDouble('previousGrade', grade);
    notifyListeners();
  }

  Future<void> updateCompletedCredits(int credits) async {
    final prefs = await SharedPreferences.getInstance();
    _previousCredits = credits;
    await prefs.setInt('previousCredits', credits);
    notifyListeners();
  }

  Future<void> updateTargetGPA(double gpa) async {
    final prefs = await SharedPreferences.getInstance();
    _targetGPA = gpa;
    await prefs.setDouble('targetGPA', gpa);
    notifyListeners();
  }
}
