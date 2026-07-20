import 'package:flutter/foundation.dart';

class FavouritesData extends ChangeNotifier {
  final List<Map<String, dynamic>> _favouriteMeals = [];

  List<Map<String, dynamic>> get favouriteMeals {
    return List.unmodifiable(_favouriteMeals);
  }

  bool isFavourite(String mealName) {
    return _favouriteMeals.any(
      (meal) => meal['name'] == mealName,
    );
  }

  void toggleFavourite(Map<String, dynamic> meal) {
    final int existingIndex = _favouriteMeals.indexWhere(
      (item) => item['name'] == meal['name'],
    );

    if (existingIndex >= 0) {
      _favouriteMeals.removeAt(existingIndex);
    } else {
      _favouriteMeals.add(meal);
    }

    notifyListeners();
  }

  void removeFavourite(String mealName) {
    _favouriteMeals.removeWhere(
      (meal) => meal['name'] == mealName,
    );

    notifyListeners();
  }
}

final FavouritesData favouritesData = FavouritesData();