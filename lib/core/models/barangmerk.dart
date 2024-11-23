import 'dart:convert';
import 'package:leontech/core/utils/function_string.dart';

class BARANGMERK {
  int? id;
  String? merk;
  String? gambar;
  String? deskripsi;
  int? aktif;
  String? updated;

  BARANGMERK({
    this.id,
    this.merk,
    this.gambar,
    this.deskripsi,
    this.aktif,
    this.updated,
  });

  @override
  String toString() {
    return 'BARANGMERK(id: $id, merk: $merk, gambar: $gambar, deskripsi: $deskripsi, aktif: $aktif, updated: $updated)';
  }

  factory BARANGMERK.fromMap(Map<String, dynamic> data) => BARANGMERK(
        id: makeInt(data['id']),
        merk: makeStr(data['merk']),
        gambar: makeStr(data['gambar']),
        deskripsi: makeStr(data['deskripsi']),
        aktif: makeInt(data['aktif']),
        updated: makeStr(data['updated']),
      );

  Map<String, String?> toMap() => {
        'id': id.toString(),
        'merk': merk,
        'gambar': gambar,
        'deskripsi': deskripsi,
        'aktif': aktif.toString(),
        'updated': updated,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [BARANGMERK].
  factory BARANGMERK.fromJson(String data) {
    return BARANGMERK.fromMap(json.decode(data) as Map<String, String?>);
  }

  /// `dart:convert`
  ///
  /// Converts [BARANGMERK] to a JSON string.
  String toJson() => json.encode(toMap());

  BARANGMERK copyWith({
    int? id,
    String? merk,
    String? gambar,
    String? deskripsi,
    int? aktif,
    String? updated,
  }) {
    return BARANGMERK(
      id: id ?? this.id,
      merk: merk ?? this.merk,
      gambar: gambar ?? this.gambar,
      deskripsi: deskripsi ?? this.deskripsi,
      aktif: aktif ?? this.aktif,
      updated: updated ?? this.updated,
    );
  }


}
