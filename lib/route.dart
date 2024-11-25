import 'package:get/get.dart';
import 'package:leontech/core/models/transaksi/transaksi.dart';
import 'package:leontech/features/auth/login.dart';
import 'package:leontech/features/home/homepage.dart';
import 'package:leontech/features/master/barang/list.dart';
import 'package:leontech/features/master/barang/view.dart';
import 'package:leontech/features/master/env/edit.dart';
import 'package:leontech/features/master/env/list.dart';
import 'package:leontech/features/master/merk/list.dart';
import 'package:leontech/features/transaksi/penjualan/list.dart';
import 'package:leontech/features/transaksi/penjualan/rincian.dart';
import 'features/auth/auth_middleware.dart';
import 'features/auth/data/list.dart';
import 'features/home/controller.dart';
import 'features/master/barang/edit.dart';

var rPage = [
  GetPage(name: '/', page: () => const HomePage(), binding: HomeBinding(), middlewares: [AuthMiddleware()]),
  GetPage(name: '/users', page: () => const UsersListPage(), middlewares: [AuthMiddleware()]),
  GetPage(name: '/env', page: () => const ListEnv(), middlewares: [AuthMiddleware()]),
  GetPage(name: '/env/edit', page: () => EnvEditor(Get.arguments), middlewares: [AuthMiddleware()]),
  GetPage(name: '/merkbarang', page: () => const ListMerk(), middlewares: [AuthMiddleware()]),
  GetPage(name: '/barang', page: () => const BarangPage(), middlewares: [AuthMiddleware()]),
  GetPage(name: '/barang/view', page: () => ViewBarang(Get.arguments), middlewares: [AuthMiddleware()]),
  GetPage(name: '/barang/edit', page: () => EditBarang(Get.arguments), middlewares: [AuthMiddleware()]),
  GetPage(name: '/login', page: () => const LoginPage()),
  GetPage(name: '/penjualan', page: () => const ListPenjualan()),
  GetPage(name: '/penjualan/rincian', page: () => RincianPenjualan(Get.arguments ?? TRANSAKSI())),
];

class InitialScreenBindings implements Bindings {
  InitialScreenBindings();

  @override
  void dependencies() {
    Get.put(() => HomePageController());
  }
}
