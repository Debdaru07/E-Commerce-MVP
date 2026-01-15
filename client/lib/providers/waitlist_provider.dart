import 'package:flutter/material.dart';
import '../data/services/waitlist_service.dart';

class WaitlistProvider extends ChangeNotifier {
  final WaitlistService _service;

  WaitlistProvider(this._service);

  bool isLoading = false;
  bool isSubmitted = false;

  Future<void> submitEmail(String email) async {
    isLoading = true;
    notifyListeners();

    await _service.submit(email);

    isLoading = false;
    isSubmitted = true;
    notifyListeners();
  }
}
