import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leontech/core/models/barangmerk.dart';
import 'package:leontech/core/utils/env.dart';
import 'package:leontech/core/utils/function.dart';
// ignore: unused_import
import 'package:leontech/core/utils/function_string.dart';

class MerkService {
  
  static Future<List<BARANGMERK>> fetch(int page, int limit, {List<String>? fields, List<String>?filteredFields, String? filterWords }) async {
      final Map<String, String> queryParameters = {
    'page': page.toString(),
    'limit': limit.toString(),
  };

  // Menambahkan fields ke query parameters jika tersedia
  if (fields != null) {
    queryParameters['fields'] = fields.join(', ');
  }
  
  // Menambahkan filterWords ke query parameters jika tersedia
  if (filterWords != null && filterWords.isNotEmpty && filteredFields != null) {
    queryParameters['filterWords'] = filterWords;
    queryParameters['filteredFields'] = filteredFields.join(', ');
  }
    final response = await http.get(Uri.https(urlApi, '/merkbarang', queryParameters ));
    // dp(response.body);
    if (response.statusCode == 200) {
      var res = decryptData(response.body);
      Map<String, dynamic> jsonResponse = json.decode(res);
      if( jsonResponse.containsKey('data')){
        List<BARANGMERK> itemlist = (jsonResponse['data'] as List)
          .map((item) => BARANGMERK.fromMap(item))
          .toList();
      return itemlist;
      }else{
        dp("not ok \n${jsonResponse.runtimeType}");
        return [];
      }
      
    } else {
      dp("response.statusCode: ${response.statusCode}\nresponse.body: ${response.body}");
      throw Exception('Failed to load Merk');
    }
  }
  static Future<BARANGMERK?> byId(int? id) async {
    if (id ==null) return null;
    final response = await http.get(Uri.https(urlApi, '/merkbarang/$id'));
    // dp("byId($id \nresponse.body:${response.body}");
    if (response.statusCode == 200) {
      return BARANGMERK.fromJson(decryptData(response.body));
    } else {
      throw Exception('Failed to load Merk');
    }
  }
    
}
