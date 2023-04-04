library june_flutter;

class June {
  June._privateConstructor();
  static final June _instance = June._privateConstructor();
  static June get instance => _instance;

  void init({required String writeKey}) async {}

  Future<bool> identifyUser({
    String? userId,
    Map<String, dynamic> traits = const {},
  }) async {
    return true;
  }

  Future<bool> identifyGroup({
    String? userId,
    String? groupId,
    Map<String, dynamic> traits = const {},
  }) async {
    return true;
  }

  Future<bool> track(
    String event, {
    Map<String, dynamic>? properties,
  }) async {
    return true;
  }
}
