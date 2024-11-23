import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leontech/core/models/lokasi.dart';
// ignore: unused_import
import 'package:leontech/core/utils/function_string.dart';

class LokasiService {
  static const String baseUrl = "api.luckyjayagroup.com";

  // Function untuk mengambil data lokasi
  static Future<List<LOKASI>> fetch(int page, int limit) async {
    final response = await http.get(Uri.https(baseUrl, '/lokasi', {"page":page.toString(), "limit":limit.toString()}));
    // dp(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<LOKASI> lokasiList = (jsonResponse['data'] as List)
          .map((lokasi) => LOKASI.fromMap(lokasi))
          .toList();
      return lokasiList;
    } else {
      throw Exception('Failed to load lokasi');
    }
  }
  static Future<LOKASI?> byId(int? id) async {
    if (id ==null) return null;
    final response = await http.get(Uri.https(baseUrl, '/lokasi/$id'));
    // dp("byId($id \nresponse.body:${response.body}");
    if (response.statusCode == 200) {
      return LOKASI.fromJson(response.body);
    } else {
      throw Exception('Failed to load lokasi');
    }
  }
    
}
