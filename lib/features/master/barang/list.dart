import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:leontech/core/models/barang.dart';
import 'package:leontech/core/services/barang/barang.dart';
import 'package:leontech/core/utils/function.dart';
import 'package:leontech/core/utils/function_string.dart';
import 'package:leontech/core/widgets/editor/customtext.dart';

class BarangPage extends StatefulWidget {
  const BarangPage({super.key});

  @override
  State<BarangPage> createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  bool isSearching = false;
  final searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  static const int _pageSize = 10; // Jumlah item per halaman
  final PagingController<int, BARANG> _pagingController =
      PagingController(firstPageKey: 1);

  // Fungsi untuk memuat lebih banyak barang (pagination)
  Future<void> _fetchPage(int pageKey) async {
    List<String>? fields = [
      'id',
      'kode',
      'nama',
      'jenis',
      'merk',
      'jual2 harga',
      'stok',
      'satuan'
    ];
    List<String>? filteredFields;
    String? filterWords;
    if (searchController.text != '' && isSearching) {
      filteredFields = ['kode', 'nama', 'merk'];
      filterWords = searchController.text;
    }
    try {
      final newItems = await BarangService.fetch(pageKey, _pageSize,
          fields: fields,
          filteredFields: filteredFields,
          filterWords: filterWords);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error, s) {
      dp(error.toString());
      dp(s.toString());
      if (!mounted) return;
      _pagingController.error = error;
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
  void dispose() {
    _pagingController.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: isSearching
              ? TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Cari Produk',
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  onChanged: (value) {
                      _debouncer.run(() {
                    _pagingController.nextPageKey = 0;
                    _pagingController.refresh();
                  });
                    
                  },
                )
              : const CustomTextAppBar(text: 'Daftar Barang', fontSize: 14),
          actions: [
            IconButton(
              icon: Icon(isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState((){
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                    _pagingController.nextPageKey = 0;
                    _pagingController.refresh();                  
                }
                
                });
              },
            ),
          ]),
      body: PagedListView<int, BARANG>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<BARANG>(
          itemBuilder: (context, item, index) {
            return ListTile(
              dense: true,
              visualDensity: const VisualDensity(vertical: -4),
              onTap: () => Get.toNamed('/barang/view', arguments: item.id),
              title: Text.rich(TextSpan(children: [
                TextSpan(text:item.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const TextSpan(text: ' '),
                TextSpan(text: item.merk, style: const TextStyle(color: Colors.blueGrey, fontSize: 14)),
              ])
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kode; ${item.kode}\nJenis: ${item.jenis}\nStok: ${formatangka(item.stok)}'),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(formatuang(item.harga),
                          textAlign: TextAlign.right)),
                ],
              ),
            );
          },
          firstPageProgressIndicatorBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
          newPageProgressIndicatorBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
          noItemsFoundIndicatorBuilder: (context) =>
              const Center(child: Text('Tidak ada barang')),
        ),
      ),
    );
  }
}
