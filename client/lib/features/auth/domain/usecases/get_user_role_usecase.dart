import '../../../../shared/services/token_storage_service.dart';
import '../../../../shared/models/user_role.dart';

/// Use case for retrieving stored user role
class GetUserRoleUseCase {
  Future<UserRole?> execute() async {
    return await TokenStorageService.getUserRole();
  }
}
