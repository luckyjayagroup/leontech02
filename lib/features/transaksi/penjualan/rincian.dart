import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:leontech/core/models/kontak.dart';
import 'package:leontech/core/models/transaksi/detail.dart';
import 'package:leontech/core/models/transaksi/transaksi.dart';
import 'package:leontech/core/services/penjualan.dart';
import 'package:leontech/core/utils/function_string.dart';
import 'package:leontech/core/widgets/editor/customtext.dart';
import 'package:leontech/features/home/widgets/dialogs/errorresponse.dart';

class RincianPenjualan extends StatefulWidget {
  final TRANSAKSI item;

  const RincianPenjualan(this.item, {super.key});

  @override
  State<RincianPenjualan> createState() => _RincianPenjualanState();
}

class _RincianPenjualanState extends State<RincianPenjualan> {
  var pageSize = 10; // jumlah records per loading
  final pagingController = PagingController<int, DETAIL>(firstPageKey: 0);
  final pagingBarangKosongController = PagingController<int, DETAIL>(firstPageKey: 0);
  final pagingPembayaranController = PagingController<int, dynamic>(firstPageKey: 0);
  // final ac = Get.find<AppController>();
  var item = TRANSAKSI();

  @override
  void initState() {
    item = widget.item;
    _getTransaksi();

    pagingBarangKosongController.addPageRequestListener((pageKey) {});
    pagingBarangKosongController.addPageRequestListener((pageKey) {});

    pagingPembayaranController.addPageRequestListener((pageKey) {
      _fetchPagePembayaran(pageKey);
    });
    super.initState();
  }

  _getTransaksi() async {
    try {
      item = await PenjualanService.byId(widget.item.id) ?? item;
      pagingController.itemList = null;
      if (item.detail != null) {
        pagingController.appendLastPage(item.detail!.where((e) => (e.qtynota ?? 0) > 0).toList());
        pagingBarangKosongController.appendLastPage(item.detail!.where((e) => (e.qtynota ?? 0) == 0).toList());
      } else {
        pagingController.appendLastPage([]);
        pagingBarangKosongController.appendLastPage([]);
      }
    } catch (e, s) {
      pagingController.error = ErrorResponse(e);
      pagingBarangKosongController.error = ErrorResponse(e);

      dp("error: $e");
      dp("s: $s");
    }

    setState(() {});
  }

  _fetchPagePembayaran(int pageKey) async {
    // dp("item:=> ${item}");

    /* final newItems = [];
    // final newItems = await executeSql(sql);
    if (newItems.isNotEmpty) {
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        pagingPembayaranController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingPembayaranController.appendPage(newItems, nextPageKey);
      }
    } else {
      pagingPembayaranController.appendLastPage([]);
    }
    setState(() {}); */
    pagingPembayaranController.appendLastPage([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // forceMaterialTransparency: true,
        // backgroundColor: Colors.white,
        title: const CustomTextStandard(
          text: 'Rincian Invoice Penjualan',
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                showDragHandle: true,
                backgroundColor: Colors.white,
                context: context,
                builder: (BuildContext context) {
                  return Wrap(
                    children: [
                      ListTile(
                          leading: GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // Fungsi untuk menutup modal
                            },
                            child: const Icon(Icons.cancel),
                          ),
                          title: const CustomTextStandard(
                            text: 'Lainnya',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.print),
                        title: const Text('Cetak'),
                        onTap: () {
                          // Implementasi untuk mencetak
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.chat),
                        title: const Text('WhatsApp'),
                        onTap: () {
                          // Implementasi untuk berbagi ke WhatsApp
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.share),
                        title: const Text('Bagikan'),
                        onTap: () {
                          item.detail = pagingController.itemList; // pagingController.itemList!.map((e) => DETAIL.fromMap(e)).toList();
                          // Get.to(() => TransactionNoteApp(item));
                          // Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Ubah'),
                        onTap: () {
                          // Implementasi untuk mengubah
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text('Hapus'),
                        onTap: () {
                          // Implementasi untuk menghapus
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
        _dataPelanggan(context),

        const Divider(height: 20, thickness: 2),
        // const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Expanded(child: CustomTextStandard(text: 'Invoice', color: Colors.grey, fontSize: 11)),
              Expanded(child: CustomTextStandard(text: ': ${item.id}', fontSize: 11)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Expanded(child: CustomTextStandard(text: 'Tanggal', color: Colors.grey, fontSize: 11)),
              Expanded(child: CustomTextStandard(text: ": ${formattanggal(item.tanggal, 'EEEE, dd MMMM yyyy HH:mm:ss')}", fontSize: 11)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Expanded(child: CustomTextStandard(text: 'Jatuh Tempo', color: Colors.grey, fontSize: 11)),
              Expanded(child: CustomTextStandard(text: ": ${formattanggal(item.tempo, 'EEEE, dd MMMM yyyy')}", fontSize: 11)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Expanded(child: CustomTextStandard(text: 'Cabang', color: Colors.grey, fontSize: 11)),
              Expanded(child: CustomTextStandard(text: ": ${item.devisi}", fontSize: 11)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Expanded(child: CustomTextStandard(text: 'Gudang', color: Colors.grey, fontSize: 11)),
              Expanded(child: CustomTextStandard(text: ': ${item.lokasi}', fontSize: 11)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Expanded(child: CustomTextStandard(text: 'Sales', color: Colors.grey, fontSize: 11)),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          showDragHandle: true,
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (BuildContext context) {
                            return Wrap(
                              children: [
                                ListTile(
                                  title: const CustomTextStandard(
                                    text: 'Dibuat Oleh',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context); // Fungsi untuk menutup modal
                                    },
                                    child: const Icon(Icons.cancel),
                                  ),
                                ),
                                const Divider(),
                                ListTile(
                                  title: const CustomTextStandard(text: 'Nama Pengguna', color: Colors.grey),
                                  trailing: CustomTextStandard(text: item.pegawai ?? ''),
                                ),
                                ListTile(
                                  title: const CustomTextStandard(text: 'Tanggal', color: Colors.grey),
                                  trailing: CustomTextStandard(text: formattanggal(item.tanggal, 'EEEE, dd MMMM yyyy')),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: CustomTextStandard(text: ': ${item.pegawai}', color: Colors.red, fontSize: 11))),
            ],
          ),
        ),

        if (pagingPembayaranController.itemList?.isNotEmpty ?? false)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomTextStandard(text: 'Pembayaran', fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        if (pagingPembayaranController.itemList?.isNotEmpty ?? false) const Divider(),
        SizedBox(
          height: (pagingPembayaranController.itemList == null) ? 0 : (pagingPembayaranController.itemList?.length ?? 0) * 30,
          child: PagedListView<int, dynamic>(
            pagingController: pagingPembayaranController,
            builderDelegate: PagedChildBuilderDelegate<dynamic>(
              itemBuilder: (context, item, index) {
                var data = TRANSAKSI.fromMap(item);
                return ListTile(
                  visualDensity: const VisualDensity(vertical: -4),
                  dense: true,
                  onTap: () => Get.toNamed('/piutang/pelunasan/rincian', arguments: data),
                  leading: CustomTextStandard(text: data.id.toString(), textAlign: TextAlign.right),
                  title: CustomTextStandard(text: formatuang(data.bayar)),
                  trailing: CustomTextStandard(text: formattanggal(data.tanggal)),
                );
              },
            ),
          ),
        ),
        const Divider(
          height: 10,
          thickness: 2,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomTextStandard(text: 'Rincian Penjualan', fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Expanded(
            child: ((item.saldo ?? 0) == 0)
                ? Stack(children: [
                    SingleChildScrollView(child: _rincianInvoicePenjualan(context)),
                    const Center(
                      child: Opacity(
                        opacity: 0.1,
                        child: const Text(
                          'LUNAS',
                          style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ])
                : SingleChildScrollView(child: _rincianInvoicePenjualan(context))),
      ]),
      bottomNavigationBar: SizedBox(
        height: 110, // Set ukuran height yang sesuai untuk BottomAppBar
        child: _bottomBar(context),
      ),
    );
  }

  Widget _dataPelanggan(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Expanded(
              child: Column(
            children: [
              CircleAvatar(radius: 40, backgroundColor: Colors.red, child: Icon(Icons.person, size: 60, color: Colors.white)),
            ],
          )),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: CustomTextStandard(text: item.kontak ?? '', color: Colors.grey, fontSize: 10)),
                      InkWell(onTap: () => Get.toNamed('/kontak/pelanggan/detail', arguments: {"kontak": KONTAK(id: item.idkontak)}), child: const Icon(Icons.edit, size: 14)),
                    ],
                  ),
                  CustomTextStandard(
                    text: item.namakontak ?? '',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    maxlines: 2,
                  ),
                  CustomTextStandard(
                    text: item.alamat_kirim,
                    fontSize: 11,
                    maxlines: 4,
                  ),
                  /* Row(
                    children: [
                      Icon(
                        Icons.phone_android,
                        size: 12,
                      ),
                      Expanded(child: CustomTextStandard(text: 'No. Telephone : $telephoneNumber', fontSize: 11)),
                      InkWell(
                        onTap: () {
                          _copyToClipboard(context, telephoneNumber);
                        },
                        child: Icon(
                          Icons.copy,
                          size: 12,
                        ),
                      ),
                    ],
                  ), */
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rincianInvoicePenjualan(BuildContext context) {
    return Column(
      children: [
        // ListTile(
        //   title: const CustomTextStandard(text: 'Daftar Produk', fontSize: 16, fontWeight: FontWeight.bold),
        //   trailing: GestureDetector(onTap: () => Get.back(), child: const Icon(Icons.cancel)),
        // ),
        // const Divider(),
        PagedListView<int, DETAIL>(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<DETAIL>(
            newPageErrorIndicatorBuilder: (context) {
              return (pagingController.error is Widget) ? pagingController.error : Center(child: Text("${pagingController.error}"));
            },
            firstPageErrorIndicatorBuilder: (context) {
              return (pagingController.error is Widget) ? pagingController.error : Center(child: Text("${pagingController.error}"));
            },
            firstPageProgressIndicatorBuilder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
            newPageProgressIndicatorBuilder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
            itemBuilder: (context, item, index) {
              var data = item;
              return ListTile(
                visualDensity: const VisualDensity(vertical: -4),
                dense: true,
                title: CustomTextStandard(text: data.nama),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextStandard(
                      text: data.kode ?? '',
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                    if ((data.qtynota ?? 0) < (data.proses)) CustomTextStandard(text: 'Order: ${formatangka(data.proses)} ${data.satuan}', color: Colors.blue),
                    CustomTextStandard(
                      text: '${formatangka(data.qtynota)} ${data.satuan} @ ${formatuang(data.harga)}',
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ],
                ),
                trailing: CustomTextStandard(
                  text: formatuang(data.jumlah),
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        PagedListView<int, DETAIL>(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          pagingController: pagingBarangKosongController,
          builderDelegate: PagedChildBuilderDelegate<DETAIL>(
            firstPageProgressIndicatorBuilder: (context) => const Text(''),
            noItemsFoundIndicatorBuilder: (context) => const Center(child: CustomTextStandard(text: 'Semua Orderan Terpenuhi', color: Colors.green)),
            itemBuilder: (context, item, index) {
              var data = item;
              if (index == 0) {
                return Column(
                  children: [
                    const Divider(),
                    const Center(child: CustomTextStandard(text: 'Item Tidak Terpenuhi', color: Colors.red)),
                    ListTile(
                      visualDensity: const VisualDensity(vertical: -4),
                      dense: true,
                      title: CustomTextStandard(text: data.nama, color: Colors.grey),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextStandard(text: data.kode ?? '', color: Colors.grey),
                          CustomTextStandard(text: '${formatangka(data.qty)} ${data.satuan} @ ${formatuang(data.harga)}', color: Colors.grey),
                        ],
                      ),
                      trailing: CustomTextStandard(text: formatuang(data.jumlah), color: Colors.grey),
                    )
                  ],
                );
              }
              return ListTile(
                visualDensity: const VisualDensity(vertical: -4),
                dense: true,
                title: CustomTextStandard(text: data.nama, color: Colors.grey),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextStandard(text: data.kode ?? '', color: Colors.grey),
                    CustomTextStandard(text: '${formatangka(data.qty)} ${data.satuan} @ ${formatuang(data.harga)}', color: Colors.grey),
                  ],
                ),
                trailing: CustomTextStandard(text: formatuang(data.jumlah), color: Colors.grey),
              );
            },
          ),
        ),
        // const Divider(),
        // Padding(
        //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       const CustomTextStandard(text: 'Sub Total'),
        //       CustomTextStandard(text: formatuang(item.nilai)),
        //     ],
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       const CustomTextStandard(text: 'Diskon'),
        //       CustomTextStandard(text: formatuang(item.diskon)),
        //     ],
        //   ),
        // ),
        // const Padding(
        //   padding: EdgeInsets.only(left: 16.0, right: 16.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [CustomTextStandard(text: 'PPN'), CustomTextStandard(text: 'Rp. 0')],
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       const CustomTextStandard(text: 'Total', fontSize: 14, fontWeight: FontWeight.bold),
        //       CustomTextStandard(text: formatuang(item.nilaitotal), fontSize: 14, fontWeight: FontWeight.bold),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _bottomBar(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Divider(height: 10, thickness: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const CustomTextStandard(text: 'Sub Total', fontSize: 11), CustomTextStandard(text: formatuang(item.nilaitotal), fontSize: 11)],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const CustomTextStandard(text: 'Diskon', fontSize: 11), CustomTextStandard(text: formatuang(item.diskon), fontSize: 11)],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [CustomTextStandard(text: 'PPN', fontSize: 11), CustomTextStandard(text: 'Rp. 0', fontSize: 11)],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const CustomTextStandard(text: 'Total', fontWeight: FontWeight.bold), CustomTextStandard(text: formatuang(item.nilaitotal), fontWeight: FontWeight.bold)],
          ),
        )
      ],
    );
  }
}
