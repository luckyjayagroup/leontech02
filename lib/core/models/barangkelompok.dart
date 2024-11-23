import 'dart:convert';
import 'package:leontech/core/utils/function_string.dart';

class BARANGKELOMPOK {
  int? id;
  String? kelompok;
  String? gambar;
  String? deskripsi;
  int? aktif;
  String? updated;

  BARANGKELOMPOK({
    this.id,
    this.kelompok,
    this.gambar,
    this.deskripsi,
    this.aktif,
    this.updated,
  });

  @override
  String toString() {
    return 'BARANGKELOMPOK(id: $id, kelompok: $kelompok, gambar: $gambar, deskripsi: $deskripsi, aktif: $aktif, updated: $updated)';
  }

  factory BARANGKELOMPOK.fromMap(Map<String, dynamic> data) => BARANGKELOMPOK(
        id: makeInt(data['id']),
        kelompok: makeStr(data['kelompok']),
        gambar: makeStr(data['gambar']),
        deskripsi: makeStr(data['deskripsi']),
        aktif: makeInt(data['aktif']),
        updated: makeStr(data['updated']),
      );

  Map<String, String?> toMap() => {
        'id': id.toString(),
        'kelompok': kelompok,
        'gambar': gambar,
        'deskripsi': deskripsi,
        'aktif': aktif.toString(),
        'updated': updated,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [BARANGKELOMPOK].
  factory BARANGKELOMPOK.fromJson(String data) {
    return BARANGKELOMPOK.fromMap(json.decode(data) as Map<String, String?>);
  }

  /// `dart:convert`
  ///
  /// Converts [BARANGKELOMPOK] to a JSON string.
  String toJson() => json.encode(toMap());

  BARANGKELOMPOK copyWith({
    int? id,
    String? kelompok,
    String? gambar,
    String? deskripsi,
    int? aktif,
    String? updated,
  }) {
    return BARANGKELOMPOK(
      id: id ?? this.id,
      kelompok: kelompok ?? this.kelompok,
      gambar: gambar ?? this.gambar,
      deskripsi: deskripsi ?? this.deskripsi,
      aktif: aktif ?? this.aktif,
      updated: updated ?? this.updated,
    );
  }


}
