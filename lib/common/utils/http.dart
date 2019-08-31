import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:http/http.dart' as http;

class Http {
  static Future get(String url) async {
    // var userToken = Config.USER_TOKEN;
    // Map<String, String> mapHeaders = {"x-access-token": userToken.toString()};
    // final res = await http.get(url, headers: mapHeaders);
    final res = await http.get(url);
    // String data = gbk.decode(res.bodyBytes);
    return res.bodyBytes;
  }

  static post(String url, body) async {
    final res = await http.post(url, body: body);
    return {"code": res.statusCode, "errorMessage": res.reasonPhrase};
  }
}
