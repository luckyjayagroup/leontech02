import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leontech/core/models/kontak.dart';
import 'package:leontech/core/utils/env.dart';
// ignore: unused_import
import 'package:leontech/core/utils/function_string.dart';

class KontakService {

  // Function untuk mengambil data kontak
  static Future<List<KONTAK>> fetch(int page, int limit) async {
    final response = await http.get(Uri.https(urlApi, '/kontak', {"page":page.toString(), "limit":limit.toString()}));
    // dp(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<KONTAK> kontakList = (jsonResponse['data'] as List)
          .map((kontak) => KONTAK.fromMap(kontak))
          .toList();
      return kontakList;
    } else {
      throw Exception('Failed to load kontak');
    }
  }
  static Future<KONTAK?> byId(int? id) async {
    if (id ==null) return null;
    final response = await http.get(Uri.https(urlApi, '/kontak/$id'));
    // dp("byId($id \nresponse.body:${response.body}");
    if (response.statusCode == 200) {
      return KONTAK.fromJson(response.body);
    } else {
      throw Exception('Failed to load kontak');
    }
  }
    
}
