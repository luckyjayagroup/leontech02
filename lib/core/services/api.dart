import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:leontech/core/utils/env.dart';
import 'package:leontech/core/utils/function.dart';
import 'package:leontech/core/utils/function_string.dart';
import 'package:leontech/core/widgets/dialogs/dialogerror.dart';

class CustomResponse extends http.BaseResponse {
  final String body;
  CustomResponse({
    required int statusCode,
    required this.body,
    required http.BaseRequest request,
    Map<String, String>? headers,
    bool? isRedirect,
    bool? persistentConnection,
    int? contentLength,
    http.Client? client,
  }) : super(
          statusCode,
          request: request,
          isRedirect: isRedirect ?? false,
          persistentConnection: persistentConnection ?? true,
          contentLength: contentLength,
        );
  @override
  String toString() {
    return 'CustomResponse(statusCode: $statusCode, headers: $headers, body: $body)';
  }
}

Future getResponse(String url, Map<String, dynamic> data, {String contentType = 'application/x-www-form-urlencoded', Map<String, String>? aheaders}) async {
  var netService = GetConnect(allowAutoSignedCert: true, timeout: const Duration(seconds: 1000), maxRedirects: 100, maxAuthRetries: 2);
  data = {...data, ...apikey};
  dp("netService.get($url, $data)");
  try {
    Response<dynamic> res;
    if (contentType == 'multipart/form-data') {
      res = await netService.get(url, query: data, contentType: contentType, headers: aheaders);
    } else {
      res = await netService.get(url, query: data, contentType: contentType, headers: aheaders);
      //res = await netService.get(url, query: data, contentType: contentType);
    }
    switch (res.statusCode) {
      case 200:
        return res;
      case 408:
        prosestxt = 'Koneksi ke Server Habis';
        doError(prosestxt);
        return;
      case 415:
        dp("post: $url");
        dp("data: $data");
        dp("status: ${res.statusCode}");
        dp("getResponse($url, $data, contentType = $contentType, $aheaders})");

        pesanError('Kesalahan jaringan, coba sekali lagi,\nRestart Jaringan jika diperlukan');
        return;
      case null:
        dp("getResponse($url, $data, contentType = $contentType, $aheaders})");
        doError('status code NULL\nKesalahan jaringan, tidak terhubung jaringan Internet');
        return;
      default:
        dp("status: ${res.statusCode}");
        dp("body: ${res.body}");
        pesanError("status: ${res.statusCode}\nbody: ${res.body}");

        return;
    }
  } catch (_) {
    // make it explicit that a SocketException will be thrown if the network connection fails
    // ignore: no_wildcard_variable_uses
    pesanError('Kesalahan jaringan, tidak terhubung jaringan Internet\n$_\ndata: $data');

    rethrow;
  }
}

Future<List> executeSQL(String sql) async {
  try {
    var response = await http.get(Uri.https(urlExec, urlExcadd2, {'req': encryptData(sql)}));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      dp('Request failed with status: ${response.statusCode}.');
      return [];
    }
  } catch (e) {
    dp(e.toString());
    dp("sql: $sql");
    return [];
  }
}

Future<List?> getUrlData(String path, [Map<String, dynamic>? query]) async {
  try {
    var response = await http.get(Uri.https(urlApi, path, query));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic>) {
        return [jsonResponse];
      }
      return jsonResponse;
    } else {
      dp('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } catch (e, stackTrace) {
    dp("getUrlData\nerror :\n $e\nstackTrace : $stackTrace");
    return null;
  }
}
