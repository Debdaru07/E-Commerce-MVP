import '../../../../shared/services/token_storage_service.dart';

/// Use case for retrieving stored access token
class GetAccessTokenUseCase {
  Future<String?> execute() async {
    return await TokenStorageService.getAccessToken();
  }
}
