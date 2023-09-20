import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';

import '../../../domain/entities/random_user.dart';

import '../../models/random_user_json_response_model.dart';
import 'dart:convert';

import '../../models/random_user_model.dart';

class UserRemoteDatatasource {
  Future<RandomUser> getUser() async {
    var request =
        Uri.parse("https://randomuser.me/api").resolveUri(Uri(queryParameters: {
      "format": 'json',
      "results": "1",
    }));

    var response = await http.get(request);
    if (response.statusCode == 200) {
      logInfo("Got code 200");

      var jsonString = response.body;
      Map<String, dynamic> jsonData = json.decode(jsonString);

      var data = RandomUserJsonReponseModel.fromJson(jsonData);

      return RandomUserModel.fromRemote(data.results.first).toEntity();
    } else {
      logError("Got error code ${response.statusCode}");
    }

    return Future.error("error");
  }
}