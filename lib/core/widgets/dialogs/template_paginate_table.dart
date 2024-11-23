import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:leontech/core/services/api.dart';
import 'package:leontech/core/utils/function_string.dart';

class TablePaginate extends StatefulWidget {
  final String sql;
  final String? order;
  final List<String>? filter;
  final String title;
  final Widget? floatingActionButton;
  final PagingController<int, dynamic>? controller;
  final Widget Function(BuildContext, dynamic, int) itemBuilder;

  const TablePaginate({required this.itemBuilder, required this.sql, super.key, this.order, this.filter, this.title = 'Daftar Data', this.floatingActionButton, this.controller});

  @override
  State<TablePaginate> createState() => _TablePaginateState();
}

class _TablePaginateState extends State<TablePaginate> {
  var pageSize = 10; // jumlah records per loading
  var pagingController = PagingController<int, dynamic>(firstPageKey: 0);

  final _searchController = TextEditingController();

  _fetchPage(int pageKey) async {
    var sql = widget.sql;

    if (_searchController.text.isNotEmpty && widget.filter != null) {
      sql = addWhere(sql, createWhere(_searchController.text, widget.filter!));
    }

    if (widget.order != null) {
      sql = "$sql ORDER BY ${widget.order!}";
    }
    sql += " LIMIT $pageSize OFFSET $pageKey";
    final newItems = await executeSQL(sql);
    if (newItems.isNotEmpty) {
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } else {
      pagingController.appendLastPage([]);
    }
  }

  @override
  void initState() {
    if (widget.controller != null) {
      pagingController = widget.controller!;
    }
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        child: CustomScrollView(
          slivers: <Widget>[
            // SliverAppBar with floating and pinned properties
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
                onSubmitted: (value) {
                  pagingController.nextPageKey = 0;
                  pagingController.refresh();
                  setState(() {});
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
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate<dynamic>(
                itemBuilder: widget.itemBuilder,
                firstPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
                newPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
                noItemsFoundIndicatorBuilder: (_) => const Center(child: Text('No items found')),
              ),
            ),
          ],
        ));
  }
}

class TablePaginate2 extends StatefulWidget {
  final String sql;
  final String? order;
  final String? filter;
  final String title;
  final Widget? floatingActionButton;
  final PagingController<int, dynamic>? controller;
  final Widget Function(BuildContext, dynamic, int) itemBuilder;

  const TablePaginate2({required this.itemBuilder, required this.sql, super.key, this.order, this.filter, this.title = 'Daftar Data', this.floatingActionButton, this.controller});

  @override
  State<TablePaginate2> createState() => _TablePaginate2State();
}

class _TablePaginate2State extends State<TablePaginate2> {
  var pageSize = 10; // jumlah records per loading
  var pagingController = PagingController<int, dynamic>(firstPageKey: 0);

  final _searchController = TextEditingController();

  _fetchPage(int pageKey) async {
    var sql = widget.sql;

    if (_searchController.text.isNotEmpty && widget.filter != null) {
      sql = addWhere(sql, widget.filter!.toLowerCase().replaceAll('like', "LIKE '%${_searchController.text.toLowerCase()}%'"));
    }

    if (widget.order != null) {
      sql = "$sql ORDER BY ${widget.order!}";
    }
    sql += " LIMIT $pageSize OFFSET $pageKey";

    final newItems = await executeSQL(sql);
    if (newItems.isNotEmpty) {
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } else {
      pagingController.appendLastPage([]);
    }
  }

  @override
  void initState() {
    if (widget.controller != null) {
      pagingController = widget.controller!;
    }
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        child: CustomScrollView(
          slivers: <Widget>[
            // SliverAppBar with floating and pinned properties
            SliverAppBar(
              toolbarHeight: 100,
              primary: false,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              pinned: false, // Keep app bar pinned at the top
              floating: true, // Float app bar upwards
              title: Column(
                children: [
                  TextField(
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
                                  pagingController.refresh(); // Refresh the list
                                });
                              },
                            )
                          : null,

                      // helperText: 'Pencarian data2',
                      border: const UnderlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      // Trigger a new search when the text changes
                      setState(() {});
                      pagingController.refresh();
                    },
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Pelanggan',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'Invoice',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        // flex: 1.5,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Piutang',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              // actions: [
              //   Padding(
              //     padding: const EdgeInsets.only(right: 8.0),
              //     child: PopupMenuButton<String>(
              //       elevation: 0,
              //       onSelected: (value) {
              //         // Handle item selection
              //         switch (value) {
              //           case 'settings':
              //             // Implement your settings action
              //             break;
              //           case 'selectColumn':
              //             // Implement your select column action
              //             break;
              //         }
              //       },
              //       itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              //         const PopupMenuItem<String>(
              //           value: 'settings',
              //           child: ListTile(
              //             leading: Icon(Icons.settings),
              //             title: Text('Pengaturan'),
              //           ),
              //         ),
              //         const PopupMenuItem<String>(
              //           value: 'selectColumn',
              //           child: ListTile(
              //             leading: Icon(Icons.view_column),
              //             title: Text('Pilih Kolom'),
              //           ),
              //         ),
              //       ],
              //       child: const Icon(Icons.more_vert, color: Colors.grey),
              //     ),
              //   ),
              // ],
            ),
            // SliverPagedList for dynamic list with pagination
            PagedSliverList<int, dynamic>(
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate<dynamic>(
                itemBuilder: widget.itemBuilder,
                firstPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
                newPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator()),
                noItemsFoundIndicatorBuilder: (_) => const Center(child: Text('No items found')),
              ),
            ),
          ],
        ));
  }
}
