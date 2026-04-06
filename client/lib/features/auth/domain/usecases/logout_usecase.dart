import '../../../../shared/services/token_storage_service.dart';

/// Use case for logging out user (clearing stored tokens)
class LogoutUseCase {
  Future<void> execute() async {
    await TokenStorageService.clear();
  }
}
