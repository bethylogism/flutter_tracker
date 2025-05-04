import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrinkTrackerModel extends ChangeNotifier {
  int _drinkCount = 0;

  int get drinkCount => _drinkCount;

  DrinkTrackerModel() {
    _loadCount();
  }

  Future<void> _loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    _drinkCount = prefs.getInt('drink_count') ?? 0;
    notifyListeners();
  }

  Future<void> addDrink() async {
    _drinkCount++;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('drink_count', _drinkCount);
  }

  Future<void> subtractDrink() async {
    if (_drinkCount > 0) {
      _drinkCount--;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('drink_count', _drinkCount);
    }
  }

  Future<void> resetCount() async {
    _drinkCount = 0;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('drink_count', _drinkCount);
  }
}
