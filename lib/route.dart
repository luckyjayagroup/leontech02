import 'package:get/get.dart';
import 'package:leontech/features/auth/login.dart';
import 'package:leontech/features/home/homepage.dart';
import 'package:leontech/features/master/barang/list.dart';
import 'package:leontech/features/master/barang/view.dart';
import 'package:leontech/features/master/env/edit.dart';
import 'package:leontech/features/master/env/list.dart';
import 'package:leontech/features/master/merk/list.dart';
import 'features/auth/auth_middleware.dart';
import 'features/auth/data/list.dart';
import 'features/home/controller.dart';
import 'features/master/barang/edit.dart';

var rPage = [
  GetPage(
    name: '/',
    page: () {
      return const HomePage();
    },
    binding: HomeBinding(),
    middlewares: [AuthMiddleware()], // Menambahkan middleware pada halaman Home
  ),
  GetPage(
      name: '/users',
      page: () => const UsersListPage(),
      middlewares: [AuthMiddleware()]),
  GetPage(
      name: '/env',
      page: () => const ListEnv(),
      middlewares: [AuthMiddleware()]),
  GetPage(
      name: '/env/edit',
      page: () {
        return EnvEditor(Get.arguments);
      },
      middlewares: [AuthMiddleware()]),

  // Halaman merk barang (memerlukan login)
  GetPage(
    name: '/merkbarang',
    page: () => const ListMerk(),
    middlewares: [AuthMiddleware()], // Menambahkan middleware pada halaman Merk
  ),

  // Halaman barang (memerlukan login)
  GetPage(
    name: '/barang',
    page: () => const BarangPage(),
    middlewares: [
      AuthMiddleware()
    ], // Menambahkan middleware pada halaman Barang
  ),

  // Halaman view barang (memerlukan login)
  GetPage(
    name: '/barang/view',
    page: () {
      return ViewBarang(Get.arguments);
    },
    middlewares: [
      AuthMiddleware()
    ], // Menambahkan middleware pada halaman View Barang
  ),

  // Halaman edit barang (memerlukan login)
  GetPage(
    name: '/barang/edit',
    page: () {
      return EditBarang(Get.arguments);
    },
    middlewares: [
      AuthMiddleware()
    ], // Menambahkan middleware pada halaman Edit Barang
  ),

  // Halaman login (tidak memerlukan middleware karena ini adalah halaman login)
  GetPage(name: '/login', page: () => const LoginPage()),
];
class InitialScreenBindings implements Bindings {

  InitialScreenBindings();

  @override
  void dependencies() {
    Get.put(() => HomePageController());
  }
}