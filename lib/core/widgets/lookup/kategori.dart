import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leontech/core/models/barangkategori.dart';
import 'package:leontech/core/widgets/editor/customtextfield.dart';
import 'package:leontech/theme.dart';

import 'template_paginate_table_url.dart';

class PilihKategori extends StatefulWidget {
  final Function(BARANGKATEGORI?)? onPilih;
  final BARANGKATEGORI? initial;
  final Widget? child;
  final TextEditingController? controller;
  final bool enabled;
  const PilihKategori({this.child, this.controller, this.initial, this.onPilih, this.enabled=true, super.key});

  @override
  State<PilihKategori> createState() => _PilihKategoriState();
}

class _PilihKategoriState extends State<PilihKategori> {
  BARANGKATEGORI? selected;
  @override
  void initState() {
  selected = widget.initial;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child:
          widget.child ??
          IgnorePointer(
        child: CustomTextField(
          readOnly: true,
          controller: TextEditingController(text: selected?.kategori ?? 'Pilih Kategori'),
          label: 'Kategori',
          suffixIcon: Icons.arrow_forward_ios_outlined,
        ),
      ),
      onTap: () {
        if (widget.enabled) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.50,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text('Pilih Kategori :', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                        child: TablePaginateUrl(
                          title: 'Daftar Kategori',
                          path: '/kategoribarang',
                          filter: const ['kategori'],
                            itemBuilder: (context, itemx, index) {
                              var item = BARANGKATEGORI.fromMap(itemx);
                              return ListTile(
                                  selectedTileColor: customTema.appBarTheme.backgroundColor,
                                  selected: (item.id == selected?.id),
                                  dense: true,
                                  visualDensity: const VisualDensity(vertical: -4),
                                  title: Text(item.kategori ?? ''),
                                  onTap: () {
                                    selected = item;
                                    widget.onPilih?.call(item);
                                    setState(() {});
                                    Get.back(result: item);
                                  });
                            },
)),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
