import 'dart:convert';
import 'package:leontech/core/utils/function_string.dart';

class BARANGKATEGORI {
  int? id;
  String? kategori;
  String? gambar;
  String? deskripsi;
  int? aktif;
  String? updated;

  BARANGKATEGORI({
    this.id,
    this.kategori,
    this.gambar,
    this.deskripsi,
    this.aktif,
    this.updated,
  });

  @override
  String toString() {
    return 'BARANGKATEGORI(id: $id, kategori: $kategori, gambar: $gambar, deskripsi: $deskripsi, aktif: $aktif, updated: $updated)';
  }

  factory BARANGKATEGORI.fromMap(Map<String, dynamic> data) => BARANGKATEGORI(
        id: makeInt(data['id']),
        kategori: makeStr(data['kategori']),
        gambar: makeStr(data['gambar']),
        deskripsi: makeStr(data['deskripsi']),
        aktif: makeInt(data['aktif']),
        updated: makeStr(data['updated']),
      );

  Map<String, String?> toMap() => {
        'id': id.toString(),
        'kategori': kategori,
        'gambar': gambar,
        'deskripsi': deskripsi,
        'aktif': aktif.toString(),
        'updated': updated,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [BARANGKATEGORI].
  factory BARANGKATEGORI.fromJson(String data) {
    return BARANGKATEGORI.fromMap(json.decode(data) as Map<String, String?>);
  }

  /// `dart:convert`
  ///
  /// Converts [BARANGKATEGORI] to a JSON string.
  String toJson() => json.encode(toMap());

  BARANGKATEGORI copyWith({
    int? id,
    String? kategori,
    String? gambar,
    String? deskripsi,
    int? aktif,
    String? updated,
  }) {
    return BARANGKATEGORI(
      id: id ?? this.id,
      kategori: kategori ?? this.kategori,
      gambar: gambar ?? this.gambar,
      deskripsi: deskripsi ?? this.deskripsi,
      aktif: aktif ?? this.aktif,
      updated: updated ?? this.updated,
    );
  }


}
