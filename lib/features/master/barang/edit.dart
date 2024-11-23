// ignore: unused_import
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leontech/core/models/barang.dart';
import 'package:leontech/core/models/baranggolongan.dart';
import 'package:leontech/core/models/barangjenis.dart';
import 'package:leontech/core/models/barangkategori.dart';
import 'package:leontech/core/models/barangkelompok.dart';
import 'package:leontech/core/models/barangmerk.dart';
import 'package:leontech/core/models/kontak.dart';
import 'package:leontech/core/models/satuan.dart';
import 'package:leontech/core/services/barang/barang.dart';
import 'package:leontech/core/utils/env.dart';
import 'package:leontech/core/utils/function_string.dart';
import 'package:leontech/core/widgets/button.dart';
import 'package:leontech/core/widgets/editor/customtextfield.dart';
import 'package:leontech/core/widgets/lookup/golongan.dart';
import 'package:leontech/core/widgets/lookup/jenis.dart';
import 'package:leontech/core/widgets/lookup/kategori.dart';
import 'package:leontech/core/widgets/lookup/kelompok.dart';
import 'package:leontech/core/widgets/lookup/merk.dart';
import 'package:leontech/core/widgets/lookup/satuan.dart';
import 'package:leontech/core/widgets/lookup/supplier.dart';

import 'uploadimage.dart';

class EditBarang extends StatefulWidget {
  final BARANG data;
  final String? judul;

  const EditBarang(
    this.data, {
    super.key,
    this.judul,
  });

  @override
  State createState() => _EditBarangState();
}

class _EditBarangState extends State<EditBarang> {
  bool gantigambar = false;
  String fileGambar ='';
  dynamic gambarbaru;
  BARANG newdata = BARANG();
// Variabel untuk menyimpan gambar

  @override
  void initState() {
    newdata = widget.data;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.judul ?? 'Tambah Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Menampilkan gambar jika ada
              UploadImageWidget(initialImage: newdata.fileGambar, onUpload: (v,f){
                dp("UploadImageWidget");
                gambarbaru = v;
                fileGambar = f;
                
                if(v is Uint8List ){
                  gantigambar = true;
                  dp("Uint8List\nf: $f");
                }else{
                  dp("v: $v f: $f");
                }
              },),

              /* GestureDetector(
                onTap: _pickImage, // Ganti gambar saat ditekan
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: const BoxDecoration(
                      // border: Border.all(color: Colors.blue, width: 1),
                      ),
                  child: _image == null
                      ? Image.asset('assets/no-image.png',
                          fit: BoxFit.cover) // Gambar dari assets
                      : Image.file(File(_image!.path),
                          fit: BoxFit.cover), // Gambar yang dipilih
                ),
              ), */

              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 40,
                      width: double.infinity,
                      color: Colors.grey,
                      child: const Text('INFORMASI BARANG'))),
              CustomTextField(
                controller: TextEditingController(text: newdata.kode),
                label: 'Kode Barang',
                onChanged: (v) {
                  newdata.kode = v;
                },
              ),
              CustomTextField(
                controller: TextEditingController(text: newdata.nama),
                floatingLabelBehavior:
                    CustomTextFieldFloatingLabelBehavior.always,
                label: 'Nama Barang',
                onChanged: (v) {
                  newdata.nama = v;
                },
              ),

              _inputMerkKategori(context),
              _inputGolonganJenis(context),
              _inputKelompokSatuan(context),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 40,
                      width: double.infinity,
                      color: Colors.grey,
                      child: const Text('DISTRIBUTOR'))),
              _inputSupplier(context),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 40,
                      width: double.infinity,
                      color: Colors.grey,
                      child: const Text('INFORMASI HARGA'))),

              _inputHargaBeli(context),
              _inputHargaSalesSpesial(context),
              _inputHargaPartaiEceran(context)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TombolSimpan(onPressed: () async{
          var res = await BarangService.update(newdata);
          if(gantigambar){
            await uploadImage('https://$urlApi/barang/${newdata.id}/img', newdata.id.toString(), gambarbaru, fileGambar, widget.data.gambar);
            newdata.gambar = fileGambar;
            newdata.fileGambar = "$homepageimg${BARANG.urlGambar}${newdata.gambar}";
            dp("newdata.fileGambar:${newdata.fileGambar}");
          }
          if (res) Get.back(result: newdata);
        }),
      ),
    );
  }

  Widget _inputMerkKategori(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: PilihMerk(
                initial: BARANGMERK(id: newdata.idmerk, merk: newdata.merk), onPilih: (v) {
          newdata.idmerk = v?.id;
          newdata.merk = v?.merk??'';
        })),
        const SizedBox(width: 10),
        Expanded(
            child: PilihKategori(
                initial: BARANGKATEGORI(
                    id: newdata.idkategori, kategori: newdata.kategori), onPilih: (v) {
          newdata.idkategori = v?.id;
          newdata.kategori = v?.kategori;
        },)),
      ],
    );
  }

  Widget _inputGolonganJenis(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: PilihGolongan(
          initial: BARANGGOLONGAN(id: newdata.idgol, nama: newdata.golongan),
          onPilih: (v) {
            newdata.idgol = v?.id;
            newdata.golongan = v?.nama;
          },
        )),
        const SizedBox(width: 10),
        Expanded(
          child: PilihJenis(
            initial: BARANGJENIS(id: newdata.idjenis, jenis: newdata.jenis),
            onPilih: (v) {
              newdata.idjenis = v?.id;
              newdata.jenis = v?.jenis;
            },
          ),
        ),
      ],
    );
  }

  Widget _inputKelompokSatuan(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: PilihKelompok(
          initial: BARANGKELOMPOK(
              id: newdata.idkelompok, kelompok: newdata.kelompok),
          onPilih: (v) {
            newdata.idkelompok = v?.id;
            newdata.kelompok = v?.kelompok;
          },
        )),
        const SizedBox(width: 10),
        Expanded(
            child: PilihSatuan(
          initial: SATUAN(id: newdata.idsatuan, satuan: newdata.satuan),
          onPilih: (v) {
            newdata.idsatuan = v?.id;
            newdata.satuan = v?.satuan ?? '';
          },
        )),
      ],
    );
  }

  Widget _inputSupplier(BuildContext context) {
    return PilihSupplier(
      initial: KONTAK(kode: newdata.supplier, nama: newdata.supplier),
      onPilih: (v) {
        newdata.supplier = v?.kode;
      },
    );
  }

  Widget _inputHargaBeli(BuildContext context) {
    return inputUang(
        controller: TextEditingController(text: formatuang(newdata.beli)),
        label: 'Harga Beli',
        onChanged: (v) {
          newdata.beli = makeDouble2(v) ?? 0;
        });
  }

  Widget _inputHargaSalesSpesial(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: inputUang(
              controller:
                  TextEditingController(text: formatuang(newdata.jual3)),
              label: 'Harga Sales',
              onChanged: (v) {
                newdata.jual3 = makeDouble2(v) ?? 0;
              }),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: inputUang(
              controller:
                  TextEditingController(text: formatuang(newdata.jual4)),
              label: 'Harga Spesial',
              onChanged: (v) {
                newdata.jual4 = makeDouble2(v) ?? 0;
              }),
        ),
      ],
    );
  }

  Widget _inputHargaPartaiEceran(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: inputUang(
              controller:
                  TextEditingController(text: formatuang(newdata.jual2)),
              label: 'Harga Partai',
              onChanged: (v) {
                newdata.jual2 = makeDouble2(v) ?? 0;
              }),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: inputUang(
              controller:
                  TextEditingController(text: formatuang(newdata.jual5)),
              label: 'Harga Eceran',
              onChanged: (v) {
                newdata.jual5 = makeDouble2(v) ?? 0;
              }),
        ),
      ],
    );
  }
}
