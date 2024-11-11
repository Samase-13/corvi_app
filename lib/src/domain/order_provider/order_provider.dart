import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  String _status = '';
  String _orderId = '';

  String get status => _status;
  String get orderId => _orderId;

  void updateOrderStatus(String id, String status) {
    _orderId = id;
    _status = status;
    notifyListeners();
  }

  void reset() {
    _status = '';
    _orderId = '';
    notifyListeners();
  }
}
