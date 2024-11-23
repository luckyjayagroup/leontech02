import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leontech/core/models/kontak.dart';
import 'package:leontech/core/services/kontak.dart';
import 'package:leontech/core/widgets/dialogs/template_paginate_table.dart';
import 'package:leontech/core/widgets/editor/customtextfield.dart';
import 'package:leontech/theme.dart';

class PilihPelanggan extends StatefulWidget {
  final Function(KONTAK?)? onPilih;
  final KONTAK? initial;
  final Widget? child;
  const PilihPelanggan({super.key, this.initial, this.onPilih, this.child});

  @override
  State<PilihPelanggan> createState() => _PilihPelangganState();
}

class _PilihPelangganState extends State<PilihPelanggan> {
  KONTAK? selected;
  String sql = "SELECT * FROM kontak where c = 1 and aktif = 1 order by nama";
  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    selected = widget.initial;
    if (widget.initial != null) {
      if (widget.initial!.nama == null || widget.initial!.kode == null) {
        selected = await KontakService.byId(widget.initial!.id);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: widget.child ??
          IgnorePointer(
              child: CustomTextField(
            readOnly: true,
            controller: TextEditingController(text: selected?.kode ?? 'Pilih Pelanggan'),
            label: 'Pelanggan *',
            suffixIcon: Icons.arrow_forward_ios_outlined,
          )),
      onTap: () {
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
                    child: const Text('Pilih Pelanggan :', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: TablePaginate(
                          filter: const ['kode', 'nama', 'alamat_kirim'],
                          itemBuilder: (context, itemx, index) {
                            var item = KONTAK.fromMap(itemx);
                            return ListTile(
                                selectedTileColor: customTema.appBarTheme.backgroundColor,
                                selected: (item.id == selected?.id),
                                dense: true,
                                visualDensity: const VisualDensity(vertical: -4),
                                title: Text(item.nama ?? ''),
                                onTap: () {
                                  selected = item;
                                  widget.onPilih?.call(item);
                                  setState(() {});
                                  Get.back(result: item);
                                });
                          },
                          sql: sql)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
