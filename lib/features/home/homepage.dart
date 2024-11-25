import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:leontech/core/utils/env.dart';
import 'package:leontech/core/utils/function_string.dart';
import 'package:leontech/core/utils/userdata.dart';
import 'package:leontech/features/auth/auth_middleware.dart';
import 'package:leontech/features/home/widgets/animasi/adapter_view.dart';
import 'package:leontech/theme.dart';

import 'controller.dart';
import 'widgets/animasi/everythinview.dart';
import 'widgets/animasi/info_view.dart';
import 'widgets/animasi/playground_view.dart';
import 'widgets/animasi/visualview.dart';
import 'widgets/chart.dart';
import 'widgets/top10.dart';

var _items = [
  {"item": "Pelanggan", "icon": Icons.face, "route": "/users"},
  {"item": "Barang", "icon": Icons.phone_android, "route": "/barang"},
  {
    "item": "Merk",
    "icon": Icons.branding_watermark_outlined,
    "route": "/merkbarang"
  },
  {"item": "Env", "icon": Icons.event_note, "route": "/env"},
  {"item": "Pelanggan", "icon": Icons.face, "route": "/pelanggan"},
  {"item": "Pelanggan", "icon": Icons.face, "route": "/pelanggan"},
  {"item": "Pelanggan", "icon": Icons.face, "route": "/pelanggan"},
  {"item": "Pelanggan", "icon": Icons.face, "route": "/pelanggan"},
  {"item": "Pelanggan", "icon": Icons.face, "route": "/pelanggan"},
  {"item": "Pelanggan", "icon": Icons.face, "route": "/pelanggan"},
];

class HomePage extends StatefulWidget {
  static final List<TabInfo> tabs = [
    TabInfo(Icons.home, (_) => _body(), 'Homepage', 'Halaman Utama Aplikasi.'),
    TabInfo(Icons.info_outline, (_) => InfoView(key: UniqueKey()), 'Info',
        'Simple example of Widget & List animations.'),
    TabInfo(
        Icons.palette_outlined,
        (_) => VisualView(fontSize: 60, key: UniqueKey()),
        'Visual',
        'Visual effects like saturation, tint, & blur.'),
    TabInfo(Icons.format_list_bulleted, (_) => const AdapterView(), 'Adapters',
        'Animations driven by scrolling & user input.'),
    TabInfo(Icons.grid_on_outlined, (_) => const EverythingView(),
        'Kitchen Sink', 'Grid view of effects with default settings.'),
    TabInfo(Icons.science_outlined, (_) => PlaygroundView(key: UniqueKey()),
        'Playground', 'A blank canvas for experimenting.'),
  ];
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _viewIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Lucky Jaya Group",
          style: TextStyle(color: Colors.black),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .shimmer(duration: 1200.ms, color: Colors.deepOrange)
            .animate() // this wraps the previous Animate in another Animate
            .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
            .slide(),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) async {
              switch (result) {
                case 'Profile':
                  dp('Profile diklik');
                  break;
                case 'Keranjang':
                  dp('Keranjang diklik');
                  break;
                case 'Riwayat':
                  dp('Riwayat diklik');
                  break;
                case 'Logout':
                  await handleSignOut();
                  break;
              }
              dp('Menu $result diklik');
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                enabled: false,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(auth.user?.photoUrl ??
                          'https://th.bing.com/th/id/OIP.PztowP3ljup0SM75tkDimQHaHa?rs=1&pid=ImgDetMain'),
                      radius: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      auth.user?.displayName ?? 'Guest',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      auth.user?.email ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Divider(),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Keranjang',
                child: ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text('Keranjang'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Riwayat',
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Riwayat'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(auth.user?.photoUrl ??
                    'https://th.bing.com/th/id/OIP.PztowP3ljup0SM75tkDimQHaHa?rs=1&pid=ImgDetMain'
                        'https://th.bing.com/th/id/OIP.PztowP3ljup0SM75tkDimQHaHa?rs=1&pid=ImgDetMain'), // Replace with your profile picture URL
                radius: 20,
              ),
            ),
          ),

          // Menambahkan tombol Sign Out
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _viewIndex,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedItemColor: const Color(0xFF80DDFF),
        unselectedItemColor: const Color(0x998898A0),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2A2B2F),
        elevation: 0,
        onTap: (index) => setState(() => _viewIndex = index),
        items: [
          for (final tab in HomePage.tabs)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              label: tab.label,
            )
        ],
      ),
      body: 
      isMobile(context)
                ? HomePage.tabs[_viewIndex].builder(context)
                : Center(
                    child: SizedBox(width: 600, child: HomePage.tabs[_viewIndex].builder(context)),
                  ) 
    );
  }
}

Widget _body() {
  final c = getHomeController();
  return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Saldo Kas Devisi'),
                        Obx(() => Text(
                              formatuang(c.ddashb.value.kas),
                              style: const TextStyle(fontSize: 20),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Saldo Kas Global'),
                        Obx(() => Text(
                              formatuang(c.ddashb.value.kasglobal),
                              style: const TextStyle(fontSize: 20),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Obx(() => (c.rl.isNotEmpty)
              ? SizedBox(
                  height: 28 * (c.rl.length.toDouble() + 1),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                          itemCount: c.rl.length + 1,
                          itemBuilder: (context, index) {
                            if ((index < c.rl.length)) {
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(c.rl[index]['namaklasifikasi'] ?? '',
                                        style: TextStyle(
                                          color: ((makeDouble(c.rl[index]
                                                          ['mutasi']) ??
                                                      0) >
                                                  0)
                                              ? Colors.blue
                                              : Colors.red,
                                        )),
                                    Text(formatuang(c.rl[index]['mutasi']),
                                        style: TextStyle(
                                          color: ((makeDouble(c.rl[index]
                                                          ['mutasi']) ??
                                                      0) >
                                                  0)
                                              ? Colors.blue
                                              : Colors.red,
                                        )),
                                  ]);
                            } else {
                              return 
                                   Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                        Text("Laba",
                                            style: (c.totalRL.value > 0)
                                                ? tstebalbiru
                                                : tstebalmerah),
                                        Text(formatuang(c.totalRL.value),
                                            style: (c.totalRL.value > 0)
                                                ? tstebalbiru
                                                : tstebalmerah),
                                      ]);
                            }
                          }),
                    ),
                  ))
              : Container()),
          const Divider(),
          Obx(() => Container(
              margin: const EdgeInsets.all(10),
              height: 300,
              child: OmsetGlobal(
                c,
                c.dechart,
                touchedGroupIndex: c.tgIndex.value,
              ))),
          SizedBox(height: 300, child: chartTop10(c, arah: Axis.horizontal)),
          const Divider(),
          SizedBox(
            height: (kIsWeb)
                ? 140
                : (Platform.isWindows)
                    ? 200
                    : 130,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              //shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 4 / 5,
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),

              itemCount: _items.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Get.toNamed(_items[index]['route'].toString()),
                  splashColor: Colors.blueGrey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(_items[index]['icon'] as IconData, size: 45),
                        Text(_items[index]['item'].toString(),
                            style: const TextStyle(fontSize: 12)),
                      ]),
                );
              },
            ),
          ),
        ],
      ));
}

class TabInfo {
  const TabInfo(this.icon, this.builder, this.label, this.description);

  final IconData icon;
  final WidgetBuilder builder;
  final String label;
  final String description;
}

