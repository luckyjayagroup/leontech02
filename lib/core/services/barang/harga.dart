import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leontech/core/models/harga.dart';
import 'package:leontech/core/utils/env.dart';
// ignore: unused_import
import 'package:leontech/core/utils/function_string.dart';

class HargaService {
  

  // Function untuk mengambil data harga
  static Future<List<HARGA>> fetch(int page, int limit) async {
    final response = await http.get(Uri.https(urlApi, '/harga', {"page":page.toString(), "limit":limit.toString()}));
    // dp(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<HARGA> hargaList = (jsonResponse['data'] as List)
          .map((harga) => HARGA.fromMap(harga))
          .toList();
      return hargaList;
    } else {
      throw Exception('Failed to load harga');
    }
  }
  static Future<HARGA?> byId(String? kode) async {
    if (kode ==null) return null;
    final response = await http.get(Uri.https(urlApi, '/harga/$kode'));
    // dp("byId($id \nresponse.body:${response.body}");
    if (response.statusCode == 200) {
      return HARGA.fromJson(response.body);
    } else {
      throw Exception('Failed to load harga');
    }
  }
    
}
