abstract class EntitlementService {
  Future<bool> currentEntitlement();
  Future<void> refreshEntitlement();
}

class MockEntitlementService implements EntitlementService {
  bool isPro;

  MockEntitlementService({this.isPro = false});

  @override
  Future<bool> currentEntitlement() async => isPro;

  @override
  Future<void> refreshEntitlement() async {}
}

class RevenueCatEntitlementService implements EntitlementService {
  @override
  Future<bool> currentEntitlement() async {
    // Placeholder for RevenueCat adapter.
    return false;
  }

  @override
  Future<void> refreshEntitlement() async {}
}

class NativeStoreEntitlementService implements EntitlementService {
  @override
  Future<bool> currentEntitlement() async {
    // Placeholder for StoreKit / Play Billing adapter.
    return false;
  }

  @override
  Future<void> refreshEntitlement() async {}
}
