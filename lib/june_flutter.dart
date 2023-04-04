library june_flutter;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// TODO: Remove
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
    String? userId,
    Map<String, dynamic> traits = const {},
  }) async {
    // Reset existing fields to make sure we don't get user/group conflicts
    _userId = null;
    _groupId = null;

    // Restore user id/group id from the session if not passed as parameters
    final finalUserId = userId ?? _userId;
    if (finalUserId == null) {
      debugPrint("identifyUser() must be called with a non-null userId before being called with just the traits.");
      return false;
    }

    // Make HTTP call with the appropriate payload
    return await _makeHttpCall(endpoint: "identify", body: {
      "userId": finalUserId,
      "traits": traits,
    });
  }

  Future<bool> identifyGroup({
    String? userId,
    String? groupId,
    Map<String, dynamic> traits = const {},
  }) async {
    // Reset existing fields to make sure we don't get user/group conflicts
    _userId = null;
    _groupId = null;

    // Restore user id/group id from the session if not passed as parameters
    final finalUserId = userId ?? _userId;
    if (finalUserId == null) {
      debugPrint("identifyGroup() must be called with a non-null userId before being called without it.");
      return false;
    }

    final finalGroupId = groupId ?? _groupId;
    if (finalGroupId == null) {
      debugPrint("identifyGroup() must be called with a non-null groupId before being called without it.");
      return false;
    }

    // Make HTTP call with the appropriate payload
    return await _makeHttpCall(endpoint: "group", body: {
      "userId": finalUserId,
      "groupId": finalUserId,
      "traits": traits,
    });
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

  Future<bool> _makeHttpCall({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    if (_writeKey == null) {
      debugPrint("June must be initialized before calling any actions.");
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

      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      return response.statusCode == 200;
    } on Exception catch (error) {
      debugPrint('June HTTP API returned with error: ${error.toString()}');
      return false;
    }
  }
}
