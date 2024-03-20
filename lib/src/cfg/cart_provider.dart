import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier {
  void shouldRefresh() {
    notifyListeners();
  }
}
