import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leontech/core/models/barangkategori.dart';
// ignore: unused_import
import 'package:leontech/core/utils/function_string.dart';

class KategoriBarangService {
  static const String baseUrl = "api.luckyjayagroup.com";

  // Function untuk mengambil data barang
  static Future<List<BARANGKATEGORI>> fetch(int page, int limit) async {
    final response = await http.get(Uri.https(baseUrl, '/kategoribarang', {"page":page.toString(), "limit":limit.toString()}));
    // dp(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<BARANGKATEGORI> barangList = (jsonResponse['data'] as List)
          .map((item) => BARANGKATEGORI.fromMap(item))
          .toList();
      return barangList;
    } else {
      throw Exception('Failed to load kategori barang');
    }
  }
  static Future<BARANGKATEGORI?> byId(int? id) async {
    if (id ==null) return null;
    final response = await http.get(Uri.https(baseUrl, '/kategoribarang/$id'));
    // dp("byId($id \nresponse.body:${response.body}");
    if (response.statusCode == 200) {
      return BARANGKATEGORI.fromJson(response.body);
    } else {
      throw Exception('Failed to kategori barang');
    }
  }
    
}
