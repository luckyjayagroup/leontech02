import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:leontech/core/models/barangmerk.dart';
import 'package:leontech/core/services/barang/merk.dart';
import 'package:leontech/core/utils/function.dart';
import 'package:leontech/core/utils/function_string.dart';
import 'package:leontech/core/widgets/editor/customtext.dart';

class ListMerk extends StatefulWidget {
  const ListMerk({super.key});

  @override
  State<ListMerk> createState() => _ListMerkState();
}

class _ListMerkState extends State<ListMerk> {
  bool isSearching = false;
  final searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  static const int _pageSize = 10; // Jumlah item per halaman
  final PagingController<int, BARANGMERK> _pagingController =
      PagingController(firstPageKey: 1);

  // Fungsi untuk memuat lebih banyak barang (pagination)
  Future<void> _fetchPage(int pageKey) async {
    List<String>? fields;
    List<String>? filteredFields;
    String? filterWords;
    if (searchController.text != '' && isSearching) {
      filteredFields = ['merk'];
      filterWords = searchController.text;
    }
    try {
      final newItems = await MerkService.fetch(pageKey, _pageSize,
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
                    hintText: 'Cari Merk',
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
              : const CustomTextAppBar(text: 'Daftar Merk', fontSize: 14),
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
      body: PagedListView<int, BARANGMERK>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<BARANGMERK>(
          itemBuilder: (context, item, index) {
            return ListTile(
              dense: true,
              onTap: () => Get.toNamed('/merkbarang/view', arguments: item.id),
              title: Text(item.merk??'',style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.edit_note_rounded),
              
            );
          },
          firstPageProgressIndicatorBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
          newPageProgressIndicatorBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
          noItemsFoundIndicatorBuilder: (context) =>
              const Center(child: Text('Tidak ada merk yang ditemukan')),
        ),
      ),
    );
  }
}
