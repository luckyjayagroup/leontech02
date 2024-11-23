import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leontech/core/models/barang.dart';
import 'package:leontech/core/utils/env.dart';
import 'package:leontech/core/utils/function.dart';
// ignore: unused_import
import 'package:leontech/core/utils/function_string.dart';

class BarangService {
  // Function untuk mengambil data barang
  static Future<List<BARANG>> fetch(int page, int limit,
      {List<String>? fields,
      List<String>? filteredFields,
      String? filterWords}) async {
    final Map<String, String> queryParameters = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    // Menambahkan fields ke query parameters jika tersedia
    if (fields != null) {
      queryParameters['fields'] = fields.join(', ');
    }

    // Menambahkan filterWords ke query parameters jika tersedia
    if (filterWords != null &&
        filterWords.isNotEmpty &&
        filteredFields != null) {
      queryParameters['filterWords'] = filterWords;
      queryParameters['filteredFields'] = filteredFields.join(', ');
    }
    final response =
        await http.get(Uri.https(urlApi, '/barang', queryParameters));
    // dp(response.body);
    if (response.statusCode == 200) {
      var res = decryptData(response.body);
      Map<String, dynamic> jsonResponse = json.decode(res);
      if (jsonResponse.containsKey('data')) {
        List<BARANG> itemList = (jsonResponse['data'] as List)
            .map((item) => BARANG.fromMap(item))
            .toList();
        return itemList;
      } else {
        dp("not ok \n${jsonResponse.runtimeType}");
        return [];
      }
    } else {
      dp("response.statusCode: ${response.statusCode}");
      dp("response.body: ${response.body}");
      
      throw Exception('Failed to load barang');
    }
  }

  static Future<BARANG?> byId(int? id) async {
    if (id == null) return null;
    final response = await http.get(Uri.https(urlApi, '/barang/$id'));
    // dp("byId($id \nresponse.body:${response.body}");
    if (response.statusCode == 200) {
      return BARANG.fromJson(decryptData(response.body));
    } else {
      throw Exception('Failed to load barang');
    }
  }
  
  static update(BARANG data) async {
    data.liststok = [];
    data.listpeletakan = null;
    data.listsatuan = [];
    data.toJson();
    final encryptedData =  encryptData(data.toJson());
    // encryptData(json.encode({'id':data.id.toString(), 'kode':data.kode, 'nama':data.nama.toString()}));
    final response = await http.put(
      Uri.https(urlApi, '/barang/${data.id}'),
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
