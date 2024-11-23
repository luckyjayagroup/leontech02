import 'dart:convert';
import 'package:leontech/core/utils/function_string.dart';

class BARANGGOLONGAN {
  int? id;
  String? nama;
  String? gambar;
  String? deskripsi;
  int? aktif;
  String? updated;

  BARANGGOLONGAN({
    this.id,
    this.nama,
    this.gambar,
    this.deskripsi,
    this.aktif,
    this.updated,
  });

  @override
  String toString() {
    return 'BARANGGOLONGAN(id: $id, nama: $nama, gambar: $gambar, deskripsi: $deskripsi, aktif: $aktif, updated: $updated)';
  }

  factory BARANGGOLONGAN.fromMap(Map<String, dynamic> data) => BARANGGOLONGAN(
        id: makeInt(data['id']),
        nama: makeStr(data['nama']),
        gambar: makeStr(data['gambar']),
        deskripsi: makeStr(data['deskripsi']),
        aktif: makeInt(data['aktif']),
        updated: makeStr(data['updated']),
      );

  Map<String, String?> toMap() => {
        'id': id.toString(),
        'nama': nama,
        'gambar': gambar,
        'deskripsi': deskripsi,
        'aktif': aktif.toString(),
        'updated': updated,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [BARANGGOLONGAN].
  factory BARANGGOLONGAN.fromJson(String data) {
    return BARANGGOLONGAN.fromMap(json.decode(data) as Map<String, String?>);
  }

  /// `dart:convert`
  ///
  /// Converts [BARANGGOLONGAN] to a JSON string.
  String toJson() => json.encode(toMap());

  BARANGGOLONGAN copyWith({
    int? id,
    String? nama,
    String? gambar,
    String? deskripsi,
    int? aktif,
    String? updated,
  }) {
    return BARANGGOLONGAN(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      gambar: gambar ?? this.gambar,
      deskripsi: deskripsi ?? this.deskripsi,
      aktif: aktif ?? this.aktif,
      updated: updated ?? this.updated,
    );
  }


}
