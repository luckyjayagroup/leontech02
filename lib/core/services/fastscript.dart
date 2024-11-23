import 'package:collection/collection.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:leontech/core/models/envmodel.dart';
import 'package:leontech/core/utils/env.dart';
import 'package:leontech/core/utils/function.dart';
import 'package:leontech/core/utils/function_string.dart';

var fs = <EnvModel>[];

class FastScript {
  
  static Future<List<EnvModel>> fetch() async {
    try {
      final response = await http.get(Uri.https(urlApi, '/env'));
      // dp(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            jsonDecode(decryptData(response.body));
        List<EnvModel> envList = (jsonResponse['data'] as List)
            .map((item) => EnvModel.fromMap(item))
            .toList();
        fs = envList;
        return envList;
      } else {
        dp("response.statusCode: ${response.statusCode}");
        dp("response.body: ${response.body}");
      }
    } catch (e, s) {
      dp("Error: $e\nStacktrace: $s");
    }
    return fs;
  }
static Future<EnvModel?> byId(int? id) async {
    if (id ==null) return null;
    final response = await http.get(Uri.https(urlApi, '/env/$id'));
    // dp("byId($id \nresponse.body:${response.body}");
    if (response.statusCode == 200) {
      return EnvModel.fromJson(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
  static Future<List?> execByid(int? id) async {
    dp("FastScript byid");
    if (id == null) {
      dp("id null");
      return null;
    }
    try {
      var envItem = fs.firstWhereOrNull((e) => e.id == id);
      if (envItem == null) {
        await fetch();
        envItem = fs.firstWhereOrNull((e) => e.id == id);
        if (envItem == null) return null;
        return null;
      }

      final response = await http.get(Uri.https(
          urlApi, '/env/exec', {"q": encryptData(envItem.skrip ?? '')}));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(decryptData(response.body));
        var items2 = jsonResponse['data'];

        return items2;
      } else {
        dp("response.statusCode: ${response.statusCode}");
        dp("response.body: ${response.body}");

        throw Exception('Failed to load Data');
      }
    } catch (e, s) {
      dp("Error: $e\nStacktrace: $s");
    }
    return null;
  }
  static Future<List?> execByNama(String? nama) async {
    dp("FastScript byid");
    if (nama == null) {
      dp("nama null");
      return null;
    }
      var envItem = fs.firstWhereOrNull((e) => e.nama?.toLowerCase() == nama.toLowerCase());
      if (envItem == null) {
        await fetch();
        envItem = fs.firstWhereOrNull((e) => e.nama?.toLowerCase() ==nama.toLowerCase());
        if (envItem == null) return null;
        return null;
      }
      return  await execByid(envItem.id);
    
  }
 
  static Future<bool> deleteEnv(int? id) async {
    if (id == null) return false;
    final response = await http.delete(Uri.https(urlApi, '/env/$id'));
    if (response.statusCode == 200) {
      return true;
    }
    return false;

  }
  static Future<EnvModel?> update(EnvModel data) async {
    data.toJson();
    final encryptedData = encryptData(data.toJson());

    if (data.id == null) {
      final response = await http.post(
        Uri.https(urlApi, '/env'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'data': encryptedData}),
      );
      if (response.statusCode == 201) {
        dp("data berhasil ditambahkan");
        var jsonResponse = jsonDecode(decryptData(response.body));
        if(jsonResponse['data'] is String) return EnvModel.fromJson(jsonResponse['data']);
        return EnvModel.fromMap(jsonResponse['data']);
      } else {
        dp("response.statusCode: ${response.statusCode}");
        dp("response.body: ${response.body}");
      }
    } else {
      final response = await http.put(
        Uri.https(urlApi, '/env/${data.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'data': encryptedData}),
      );
      if (response.statusCode == 200) {
        dp("data berhasil disimpan");
        var jsonResponse = jsonDecode(decryptData(response.body));
         if(jsonResponse['data'] is String) return EnvModel.fromJson(jsonResponse['data']);
        return EnvModel.fromMap(jsonResponse['data']);
      } else {
        dp("response.statusCode: ${response.statusCode}");
        dp("response.body: ${response.body}");
      }
    }
    return null;
  }
}
