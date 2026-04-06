import 'package:flutter/material.dart';
import '../domain/repositories/waitlist_repository.dart';

class WaitlistProvider extends ChangeNotifier {
  final WaitlistRepository _repository;

  WaitlistProvider(this._repository);

  bool isLoading = false;
  bool isSubmitted = false;

  Future<void> submitEmail(String email) async {
    isLoading = true;
    notifyListeners();

    await _repository.submitWaitlist(email: email);

    isLoading = false;
    isSubmitted = true;
    notifyListeners();
  }
}
