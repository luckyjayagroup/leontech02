import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leontech/core/models/barangjenis.dart';
// ignore: unused_import
import 'package:leontech/core/utils/function_string.dart';

class JenisBarangService {
  static const String baseUrl = "api.luckyjayagroup.com";

  // Function untuk mengambil data barang
  static Future<List<BARANGJENIS>> fetch(int page, int limit) async {
    final response = await http.get(Uri.https(baseUrl, '/jenisbarang', {"page":page.toString(), "limit":limit.toString()}));
    // dp(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<BARANGJENIS> barangList = (jsonResponse['data'] as List)
          .map((item) => BARANGJENIS.fromMap(item))
          .toList();
      return barangList;
    } else {
      throw Exception('Failed to load jenis barang');
    }
  }
  static Future<BARANGJENIS?> byId(int? id) async {
    if (id ==null) return null;
    final response = await http.get(Uri.https(baseUrl, '/jenisbarang/$id'));
    // dp("byId($id \nresponse.body:${response.body}");
    if (response.statusCode == 200) {
      return BARANGJENIS.fromJson(response.body);
    } else {
      throw Exception('Failed to jenis barang');
    }
  }
    
}
