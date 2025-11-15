import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  int _notificationCount = 0;

  int get notificationCount => _notificationCount;

  void setNotificationCount(int count) {
    _notificationCount = count;
    notifyListeners();
  }

  void increment() {
    _notificationCount++;
    notifyListeners();
  }

  void decrement() {
    if (_notificationCount > 0) {
      _notificationCount--;
      notifyListeners();
    }
  }
}
