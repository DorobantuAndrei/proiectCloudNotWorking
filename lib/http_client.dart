import 'dart:convert';
import 'package:http/http.dart' as http;

Map buildResponse(bool error, String message, Map data) {
  //! Builds an internal response object, this is a structed way to pass data
  return {"error": error, "message": message, "data": data};
}

class HttpClient {
  Duration standartTimeOut = const Duration(seconds: 600);

  Future<Map> get(Uri uri, [Map<String, String> headers]) async {
    //! get request wrapper, returns a map with the response details
    try {
      http.Response response =
          await http.get(uri, headers: headers).timeout(standartTimeOut);
      if (response.statusCode == 200) {
        return buildResponse(false, "", jsonDecode(response.body));
      }
      return buildResponse(true, "", {});
    } catch (e) {
      print(e);
      return buildResponse(true, "", {});
    }
  }

  Future<Map> postForm(Uri uri, Map body, Map<String, String> headers) async {
    //! post request wrapper, returns a map with the response details
    var response = await http
        .post(uri, body: body, headers: headers)
        .timeout(standartTimeOut);
    if (response.statusCode < 299) {
      return buildResponse(false, "", jsonDecode(response.body));
    }
    return buildResponse(true, "", {});
  }

  Future<Map> post(Uri uri, Map body, Map<String, String> headers) async {
    //! post request wrapper, returns a map with the response details
    var response = await http
        .post(uri, body: jsonEncode(body), headers: headers)
        .timeout(standartTimeOut);
    if (response.statusCode < 299) {
      return buildResponse(
          false, "", response.body != '' ? jsonDecode(response.body) : {});
    }
    return buildResponse(
        true, jsonDecode(response.body)['error']['message'], {});
  }

  Future<Map> postHTML(Uri uri, Map body, Map<String, String> headers) async {
    //! post request wrapper, returns a map with the response details
    var response = await http
        .post(uri, body: jsonEncode(body), headers: headers)
        .timeout(standartTimeOut);
    if (response.statusCode < 299) {
      return buildResponse(
          false, "", {"html": response.body != '' ? response.body : ""});
    }
    return buildResponse(true, "", {});
  }

  Future<Map> delete(Uri uri) async {
    //! delete request wrapper, returns a map with the response details
    var response = await http.delete(uri).timeout(standartTimeOut);
    if (response.statusCode == 200) {
      return buildResponse(false, "", jsonDecode(response.body));
    }
    return buildResponse(true, "", {});
  }
}
