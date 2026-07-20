import 'package:flutter/foundation.dart';

class BasketData extends ChangeNotifier {
  final List<Map<String, dynamic>> _basketItems = [];

  List<Map<String, dynamic>> get basketItems {
    return List.unmodifiable(_basketItems);
  }

  int get itemCount {
    return _basketItems.fold<int>(
      0,
      (total, item) => total + (item['quantity'] as int),
    );
  }

  double get totalPrice {
    return _basketItems.fold<double>(
      0,
      (total, item) {
        final double price = item['priceValue'] as double;
        final int quantity = item['quantity'] as int;

        return total + (price * quantity);
      },
    );
  }

  void addItem({
    required String name,
    required String cook,
    required String price,
    required String emoji,
    String? imageUrl,
    int quantity = 1,
  }) {
    final int existingIndex = _basketItems.indexWhere(
      (item) => item['name'] == name,
    );

    final double priceValue =
        double.tryParse(price.replaceAll('£', '').trim()) ?? 0;

    if (existingIndex >= 0) {
      final int currentQuantity =
          _basketItems[existingIndex]['quantity'] as int;

      _basketItems[existingIndex]['quantity'] =
          currentQuantity + quantity;
    } else {
      _basketItems.add({
        'name': name,
        'cook': cook,
        'price': price,
        'priceValue': priceValue,
        'emoji': emoji,
        'imageUrl': imageUrl,
        'quantity': quantity,
      });
    }

    notifyListeners();
  }

  void increaseQuantity(String mealName) {
    final int index = _basketItems.indexWhere(
      (item) => item['name'] == mealName,
    );

    if (index == -1) {
      return;
    }

    final int currentQuantity =
        _basketItems[index]['quantity'] as int;

    _basketItems[index]['quantity'] = currentQuantity + 1;

    notifyListeners();
  }

  void decreaseQuantity(String mealName) {
    final int index = _basketItems.indexWhere(
      (item) => item['name'] == mealName,
    );

    if (index == -1) {
      return;
    }

    final int currentQuantity =
        _basketItems[index]['quantity'] as int;

    if (currentQuantity <= 1) {
      _basketItems.removeAt(index);
    } else {
      _basketItems[index]['quantity'] = currentQuantity - 1;
    }

    notifyListeners();
  }

  void removeItem(String mealName) {
    _basketItems.removeWhere(
      (item) => item['name'] == mealName,
    );

    notifyListeners();
  }

  void clearBasket() {
    _basketItems.clear();
    notifyListeners();
  }
}

final BasketData basketData = BasketData();