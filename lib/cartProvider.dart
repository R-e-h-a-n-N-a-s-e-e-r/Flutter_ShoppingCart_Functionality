import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  double _totalPrice = 0.0;

  double get totalPrice => _totalPrice;

  void _setPrefItem() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setInt('cart_item', _counter);
    sp.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItem() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _counter = sp.getInt('cart_item')!;
    _totalPrice = sp.getDouble('total_price')!;
    notifyListeners();
  }

  void addItem() {
    _counter++;
    _setPrefItem();
    notifyListeners();
  }

  void removeItem() {
    _counter--;
    _setPrefItem();
    notifyListeners();
  }

  int getItemCount() {
    _getPrefItem();
    return _counter;
  }

  void setTotalPrice(price) {
    _totalPrice = _totalPrice + price;
    _setPrefItem();
    notifyListeners();
  }

  void removeTotalPrice(double price) {
    _totalPrice = _totalPrice - price;
    _setPrefItem();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefItem();
    return _totalPrice;
  }
}
