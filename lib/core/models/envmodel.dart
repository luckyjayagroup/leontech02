import 'dart:convert';

class EnvModel {
  int? id;
  String? nama;
  String? skrip;
  
  EnvModel({this.id, this.nama, this.skrip});
  @override
  String toString() {
      return 'EnvModel(id: $id, nama: $nama, skrip: $skrip)';    
  }
  factory EnvModel.fromMap(Map<String, dynamic> json) {
    return EnvModel(
      id: json['id'],
      nama: json['nama'],
      skrip: json['skrip'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'skrip': skrip,
    };
  }
  String toJson() => jsonEncode(toMap());
  factory EnvModel.fromJson(String data) {
    return EnvModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }
}
