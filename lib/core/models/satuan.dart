import 'dart:convert';
import 'package:leontech/core/utils/function_string.dart';

class SATUAN {
  int? id;
  String? satuan;
  String? gambar;
  String? deskripsi;
  int? aktif;
  String? updated;

  SATUAN({
    this.id,
    this.satuan,
    this.gambar,
    this.deskripsi,
    this.aktif,
    this.updated,
  });

  @override
  String toString() {
    return 'SATUAN(id: $id, satuan: $satuan, gambar: $gambar, deskripsi: $deskripsi, aktif: $aktif, updated: $updated)';
  }

  factory SATUAN.fromMap(Map<String, dynamic> data) => SATUAN(
        id: makeInt(data['id']),
        satuan: makeStr(data['satuan']),
        gambar: makeStr(data['gambar']),
        deskripsi: makeStr(data['deskripsi']),
        aktif: makeInt(data['aktif']),
        updated: makeStr(data['updated']),
      );

  Map<String, String?> toMap() => {
        'id': id.toString(),
        'satuan': satuan,
        'gambar': gambar,
        'deskripsi': deskripsi,
        'aktif': aktif.toString(),
        'updated': updated,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SATUAN].
  factory SATUAN.fromJson(String data) {
    return SATUAN.fromMap(json.decode(data) as Map<String, String?>);
  }

  /// `dart:convert`
  ///
  /// Converts [SATUAN] to a JSON string.
  String toJson() => json.encode(toMap());

  SATUAN copyWith({
    int? id,
    String? satuan,
    String? gambar,
    String? deskripsi,
    int? aktif,
    String? updated,
  }) {
    return SATUAN(
      id: id ?? this.id,
      satuan: satuan ?? this.satuan,
      gambar: gambar ?? this.gambar,
      deskripsi: deskripsi ?? this.deskripsi,
      aktif: aktif ?? this.aktif,
      updated: updated ?? this.updated,
    );
  }


}
