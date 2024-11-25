import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:leontech/core/models/transaksi/transaksi.dart';
import 'package:leontech/core/services/penjualan.dart';
import 'package:leontech/core/utils/function.dart';
import 'package:leontech/core/utils/function_string.dart';
import 'package:leontech/core/widgets/editor/customtext.dart';
import 'package:leontech/features/home/widgets/dialogs/errorresponse.dart';

class ListPenjualan extends StatefulWidget {
  const ListPenjualan({super.key});

  @override
  State<ListPenjualan> createState() => _ListPenjualanState();
}

class _ListPenjualanState extends State<ListPenjualan> {
  bool isSearching = false;
  final searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 1000);
  static const int _pageSize = 20; // Jumlah item per halaman
  final PagingController<int, TRANSAKSI> _pagingController = PagingController(firstPageKey: 0);

  List<String>? fields = [
    'id',
    'notrans',
    'tanggal',
    'kontak',
    'idkontak',
    'pegawai',
    'nilaitotal',
  ];
  Future<void> _fetchPage(int pageKey) async {
    List<String>? filteredFields;
    String? filterWords;
    if (searchController.text != '' && isSearching) {
      filteredFields = ['kontak', 'notrans'];
      filterWords = searchController.text;
    }
    try {
      final newItems = await PenjualanService.fetch(pageKey, _pageSize, fields: fields, filteredFields: filteredFields, filterWords: filterWords);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error, s) {
      _pagingController.error = ErrorResponse(error);

      dp("error: ${error.runtimeType}");
      dp(error.toString());
      dp(s.toString());
      if (!mounted) return;
    }
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: isSearching
              ? TextField(
                  controller: searchController,
                  decoration: const InputDecoration(hintText: 'Cari Nota', border: InputBorder.none, fillColor: Colors.white, filled: true),
                  onChanged: (value) {
                    _debouncer.run(() {
                      setState(() {
                        _pagingController.nextPageKey = 0;

                        _pagingController.refresh();
                      });
                    });
                  },
                )
              : const Text('Penjualan'),
          actions: [
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  if (!isSearching) {
                    _pagingController.nextPageKey = 0;
                    _pagingController.refresh();
                  }
                });
              },
            ),
          ]),
      body: PagedListView<int, TRANSAKSI>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<TRANSAKSI>(
            newPageErrorIndicatorBuilder: (context) {
              return (_pagingController.error is Widget) ? _pagingController.error : Center(child: Text("${_pagingController.error}"));
            },
            firstPageErrorIndicatorBuilder: (context) {
              return (_pagingController.error is Widget) ? _pagingController.error : Center(child: Text("${_pagingController.error}"));
            },
            firstPageProgressIndicatorBuilder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
            newPageProgressIndicatorBuilder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
            itemBuilder: (context, item, index) {
              return ItemPenjualan(_pagingController, item, index);
            },
          )),
    );
  }
}

class ItemPenjualan extends StatelessWidget {
  final TRANSAKSI item;
  final int index;
  final bool sales;
  final PagingController pagingController;
  const ItemPenjualan(this.pagingController, this.item, this.index, {this.sales = false, super.key});

  @override
  Widget build(BuildContext context) {
    bool sama = (index == 1);
    if (index > 0) {
      sama = (formattanggal(item.tanggal) == formattanggal(pagingController.itemList![index - 1].tanggal));
    }

    return Column(
      children: [
        if (index > 0 && !sama) const Divider(thickness: 2),
        ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.note_alt_outlined, color: Colors.white),
            ),
            title: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextStandard(
                        text: item.kontak ?? '',
                        fontWeight: FontWeight.bold,
                        maxlines: 2,
                      ),
                      CustomTextStandard(
                        text: 'Invoice: ${item.notrans}',
                        fontSize: 10.0,
                        color: Colors.grey,
                      ),
                      CustomTextStandard(
                        text: 'Tanggal: ${formattanggal(item.tanggal, 'dd/MM/yyyy HH:mm')}',
                        fontSize: 10.0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!sales) CustomTextStandard(text: item.sales ?? ''),
                      CustomTextStandard(
                        text: '${formatuang(item.nilaitotal)}',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                      if (item.status != null)
                        CustomTextStandard(
                          text: item.status.toString(),
                          fontSize: 12.0,
                          color: getStatusColor(item.status.toString()),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () => Get.toNamed('/penjualan/rincian', arguments: item) //InvoiceItemDetailPage(item: item),{

            ),
        //if (!sama) const Divider(thickness: 2)
      ],
    );
  }
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'lunas':
      return Colors.green;
    case 'belum lunas':
      return Colors.pink;
    case 'belum bayar':
      return Colors.red;
    default:
      return Colors.black;
  }
}
