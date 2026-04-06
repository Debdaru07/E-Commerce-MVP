abstract class WaitlistRepository {
  Future<void> submitWaitlist({
    required String email,
  });
}
