import '../../data/services/waitlist_service.dart';
import '../../domain/repositories/waitlist_repository.dart';

class WaitlistRepositoryImpl implements WaitlistRepository {
  final WaitlistService _service;

  WaitlistRepositoryImpl([WaitlistService? service]) : _service = service ?? WaitlistService();

  @override
  Future<void> submitWaitlist({required String email}) {
    return _service.submit(email);
  }
}
