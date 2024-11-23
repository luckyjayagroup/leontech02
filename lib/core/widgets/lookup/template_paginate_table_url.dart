import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:leontech/core/utils/env.dart';
import 'package:http/http.dart' as http;
import 'package:leontech/core/utils/function.dart';
import 'package:leontech/core/utils/function_string.dart';

class TablePaginateUrl extends StatefulWidget {
  final String path;
  final Map<String, dynamic>? query;
  final String? order;
  final List<String>? fields;
  final List<String>? filter;
  final String title;
  final bool pencarian;

  final Widget? floatingActionButton;
  final PagingController<int, dynamic>? controller;
  final Widget Function(BuildContext, dynamic, int) itemBuilder;

  const TablePaginateUrl(
      {required this.itemBuilder,
      required this.path,
      this.query,
      super.key,
      this.order,
      this.fields,
      this.filter,
      this.title = 'Daftar Data',
      this.floatingActionButton,
      this.controller,
      this.pencarian = true});

  @override
  State<TablePaginateUrl> createState() => _TablePaginateUrlState();
}

class _TablePaginateUrlState extends State<TablePaginateUrl> {
  var pageSize = 10; // jumlah records per loading
  var pagingController = PagingController<int, dynamic>(firstPageKey: 0);
 final _debouncer = Debouncer(milliseconds: 500);
  final _searchController = TextEditingController();

  _fetchPage(int pageKey) async {
    final Map<String, String> queryParameters = {
      'page': pageKey.toString(),
      'limit': pageSize.toString(),
    };

    // Menambahkan fields ke query parameters jika tersedia
    if (widget.fields != null) {
      queryParameters['fields'] = widget.fields!.join(', ');
    }

    if (_searchController.text.isNotEmpty && widget.filter != null) {
      queryParameters['filterWords'] = _searchController.text;
      queryParameters['filteredFields'] = widget.filter!.join(', ');
    }

    var response =
        await http.get(Uri.https(urlApi, widget.path, queryParameters));
    List? newItems;
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(decryptData(response.body));
      newItems = jsonResponse['data'] as List;
    } else {
      dp("$urlApi${widget.path} $queryParameters: ${response.statusCode}");
      throw Exception('Failed to load data');
    }
    if (newItems.isEmpty) {
      pagingController.appendLastPage([]);
    } else {
      if (newItems.isNotEmpty) {
        final isLastPage = newItems.length < pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        pagingController.appendLastPage([]);
      }
    }
  }

  @override
  void initState() {
    if (widget.controller != null) {
      pagingController = widget.controller!;
    }
    if (widget.controller != null) {
      widget.controller!.addPageRequestListener((pageKey) {
        _fetchPage(pageKey);
      });
    } else {
      pagingController.addPageRequestListener((pageKey) {
        _fetchPage(pageKey);
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.cancel();
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        child: CustomScrollView(
          slivers: <Widget>[
            // SliverAppBar with floating and pinned properties
            if (widget.pencarian)
              SliverAppBar(
                toolbarHeight: 80,
                primary: false,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                pinned: false, // Keep app bar pinned at the top
                floating: true, // Float app bar upwards
                title: TextField(
                  controller: _searchController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    // fillColor: Colors.white,
                    // filled: true,
                    prefixIcon: const Icon(Icons.search),

                    suffixIcon: (_searchController.text.isNotEmpty)
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                pagingController.nextPageKey = 0;
                                pagingController.refresh(); // Refresh the list
                              });
                            },
                          )
                        : null,

                    helperText: 'Pencarian data',
                    border: const UnderlineInputBorder(),
                  ),
                  onChanged: (value) {
                   _debouncer.run(() {
                    pagingController.nextPageKey = 0;
                    pagingController.refresh();
                  });
                  },
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: PopupMenuButton<String>(
                      elevation: 0,
                      onSelected: (value) {
                        // Handle item selection
                        switch (value) {
                          case 'settings':
                            // Implement your settings action
                            break;
                          case 'selectColumn':
                            // Implement your select column action
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'settings',
                          child: ListTile(
                            leading: Icon(Icons.settings),
                            title: Text('Pengaturan'),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'selectColumn',
                          child: ListTile(
                            leading: Icon(Icons.view_column),
                            title: Text('Pilih Kolom'),
                          ),
                        ),
                      ],
                      child: const Icon(Icons.more_vert, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            // SliverPagedList for dynamic list with pagination
            PagedSliverList<int, dynamic>(
              pagingController: widget.controller ?? pagingController,
              builderDelegate: PagedChildBuilderDelegate<dynamic>(
                itemBuilder: widget.itemBuilder,
                firstPageProgressIndicatorBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                newPageProgressIndicatorBuilder: (_) =>
                    const Center(child: CircularProgressIndicator()),
                noItemsFoundIndicatorBuilder: (_) =>
                    const Center(child: Text('No items found')),
              ),
            ),
          ],
        ));
  }
}
