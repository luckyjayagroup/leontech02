import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:leontech/core/models/transaksi/transaksi.dart';
import 'package:leontech/core/utils/env.dart';
import 'package:leontech/core/utils/function.dart';
import 'package:leontech/core/utils/function_string.dart';

class PenjualanService {
  // Function untuk mengambil data transaksi
  static Future<List<TRANSAKSI>> fetch(int page, int limit, {List<String>? fields, List<String>? filteredFields, String? filterWords}) async {
    final Map<String, String> queryParameters = {
      'page': page.toString(),
      'limit': limit.toString(),
      'kdtrans': 'PJ',
    };

    if (fields != null) {
      queryParameters['fields'] = fields.join(', ');
    }
    if (filterWords != null && filterWords.isNotEmpty && filteredFields != null) {
      queryParameters['filterWords'] = filterWords;
      queryParameters['filteredFields'] = filteredFields.join(', ');
    }
    final response = await http.get(Uri.https(urlApi, '/penjualan', queryParameters));
    //dp(response.body);
    if (response.statusCode == 200) {
      var res = decryptData(response.body);
      // dp("res: $res");
      Map<String, dynamic> jsonResponse = json.decode(res);
      if (jsonResponse.containsKey('data')) {
        List<TRANSAKSI> itemList = (jsonResponse['data'] as List).map((item) => TRANSAKSI.fromMap(item)).toList();
        return itemList;
      } else {
        dp("not ok \n${jsonResponse.runtimeType}");
        return [];
      }
    } else {
      dp("response: ${response.toString()}");
      dp("response.statusCode: ${response.statusCode}");
      dp("response.body: ${response.body}");

      throw response;
    }
  }

  static Future<TRANSAKSI?> byId(int? id) async {
    if (id == null) return null;
    final response = await http.get(Uri.https(urlApi, '/penjualan/$id'));

    if (response.statusCode == 200) {
      return TRANSAKSI.fromJson(decryptData(response.body));
    } else {
      dp("byId($id \nresponse.body:${response.body}");
      throw response;
    }
  }

  static update(TRANSAKSI data) async {
    data.toJson();
    final encryptedData = encryptData(data.toJson());
    // encryptData(json.encode({'id':data.id.toString(), 'kode':data.kode, 'nama':data.nama.toString()}));
    final response = await http.put(
      Uri.https(urlApi, '/transaksi/${data.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'data': encryptedData}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      dp("response.statusCode: ${response.statusCode}");
      dp("response.body: ${response.body}");
      return false;
    }
  }
}
