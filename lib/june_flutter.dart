library june_flutter;

import 'dart:convert';

import 'package:http/http.dart' as http;

class June {
  June._privateConstructor();
  static final June _instance = June._privateConstructor();
  static June get instance => _instance;

  String? _writeKey;
  String? _userId;
  String? _groupId;

  void init({required String writeKey}) async {
    _writeKey = writeKey;
  }

  Future<bool> identifyUser({
    required String userId,
    Map<String, dynamic> traits = const {},
  }) async {
    _userId = userId;
    _groupId = null;

    return await _identifyNullableUser(
      userId: userId,
      traits: traits,
      methodCall: "identifyUser()",
    );
  }

  Future<bool> identifyGroup({
    required String userId,
    required String groupId,
    Map<String, dynamic> traits = const {},
  }) async {
    _userId = userId;
    _groupId = groupId;

    return await _identifyNullableGroup(
      userId: userId,
      groupId: groupId,
      traits: traits,
      methodCall: "identifyGroup()",
    );
  }

  Future<bool> setCurrentUserTraits({
    Map<String, dynamic> traits = const {},
  }) async {
    return await _identifyNullableUser(traits: traits, methodCall: "setCurrentUserTraits()");
  }

  Future<bool> setCurrentGroupTraits({
    Map<String, dynamic> traits = const {},
  }) async {
    return await _identifyNullableGroup(traits: traits, methodCall: "setCurrentGroupTraits()");
  }

  Future<bool> track(
    String event, {
    Map<String, dynamic>? properties,
  }) async {
    return await _makeHttpCall(endpoint: "track", body: {
      "event": event,
      if (properties != null) "properties": properties,
      if (_userId != null) "userId": _userId,
      if (_groupId != null) "context": {"groupId": _groupId},
    });
  }

  Future<bool> _identifyNullableUser({
    required String methodCall,
    String? userId,
    Map<String, dynamic> traits = const {},
  }) async {
    // Restore user id/group id from the session if not passed as parameters
    final finalUserId = userId ?? _userId;
    if (finalUserId == null) {
      print("identifyUser() must be called with a non-null userId before calling $methodCall");
      return false;
    }

    // Make HTTP call with the appropriate payload
    return await _makeHttpCall(endpoint: "identify", body: {
      "userId": finalUserId,
      "traits": traits,
    });
  }

  Future<bool> _identifyNullableGroup({
    required String methodCall,
    String? userId,
    String? groupId,
    Map<String, dynamic> traits = const {},
  }) async {
    // Restore user id/group id from the session if not passed as parameters
    final finalUserId = userId ?? _userId;
    final finalGroupId = groupId ?? _groupId;
    if (finalUserId == null || finalGroupId == null) {
      print("identifyGroup() must be calledbefore calling $methodCall");
      return false;
    }

    // Make HTTP call with the appropriate payload
    return await _makeHttpCall(endpoint: "group", body: {
      "userId": finalUserId,
      "groupId": finalUserId,
      "traits": traits,
    });
  }

  Future<bool> _makeHttpCall({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    if (_writeKey == null) {
      print("June must be initialized before calling any actions.");
      return false;
    }

    try {
      var url = 'https://api.june.so/sdk/$endpoint';
      final headers = <String, String>{
        "Content-Type": "application/json",
        "Authorization": "Basic $_writeKey",
      };

      // Inject timestamp into body
      body["timestamp"] = DateTime.now().toIso8601String();

      final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
      return response.statusCode == 200;
    } on Exception catch (error) {
      print('June HTTP API returned with error: ${error.toString()}');
      return false;
    }
  }
}
