import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leontech/core/models/barangjenis.dart';
import 'package:leontech/core/widgets/editor/customtextfield.dart';
import 'package:leontech/theme.dart';

import 'template_paginate_table_url.dart';

class PilihJenis extends StatefulWidget {
  final Function(BARANGJENIS?)? onPilih;
  final BARANGJENIS? initial;
  final Widget? child;
  final TextEditingController? controller;
  final bool enabled;
  const PilihJenis({this.child, this.controller, this.initial, this.onPilih, this.enabled=true, super.key});

  @override
  State<PilihJenis> createState() => _PilihJenisState();
}

class _PilihJenisState extends State<PilihJenis> {
  BARANGJENIS? selected;
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
          controller: TextEditingController(text: selected?.jenis ?? 'Pilih Jenis'),
          label: 'Jenis',
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
                      child: const Text('Pilih Jenis :', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                        child: TablePaginateUrl(
                          title: 'Daftar Jenis',
                          path: '/jenisbarang',
                          filter: const ['jenis'],
                            itemBuilder: (context, itemx, index) {
                              var item = BARANGJENIS.fromMap(itemx);
                              return ListTile(
                                  selectedTileColor: customTema.appBarTheme.backgroundColor,
                                  selected: (item.id == selected?.id),
                                  dense: true,
                                  visualDensity: const VisualDensity(vertical: -4),
                                  title: Text(item.jenis ?? ''),
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
