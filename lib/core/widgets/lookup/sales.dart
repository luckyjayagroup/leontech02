import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leontech/core/models/kontak.dart';
import 'package:leontech/core/services/kontak.dart';
import 'package:leontech/core/widgets/dialogs/template_paginate_table.dart';
import 'package:leontech/core/widgets/editor/customtextfield.dart';

class PilihSales extends StatefulWidget {
  final Function(KONTAK?)? onPilih;
  final KONTAK? initial;
  final Widget? child;
  const PilihSales({super.key, this.initial, this.onPilih, this.child});

  @override
  State<PilihSales> createState() => _PilihSalesState();
}

class _PilihSalesState extends State<PilihSales> {
  KONTAK? selected;
  String sql = "SELECT * FROM kontak where p = 1 and aktif = 1 and jabatan = 'SALES' order by nama";
  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    selected = widget.initial;
    if (widget.initial != null) {
      if (widget.initial!.nama == null) {
        selected = await KontakService.byId(widget.initial!.id);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: widget.child ?? IgnorePointer(child: CustomTextField(readOnly: true, controller: TextEditingController(text: selected?.kode ?? 'Pilih Sales'), label: 'Sales', suffixIcon: Icons.arrow_forward_ios_outlined)),
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
                    child: const Text('Pilih Sales :', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                      child: TablePaginate(
                          itemBuilder: (context, itemx, index) {
                            var item = KONTAK.fromMap(itemx);
                            return ListTile(
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
