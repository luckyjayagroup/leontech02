

import 'package:flutter/material.dart';

const String homepageimg = 'https://images.luckyjayagroup.com/sparepart/';
const String urlHome2 = 'https://ljmitdivisi.com/ljmbaru/web';
const String urlBase = 'https://ljmitdivisi.com/ljmbaru/api';
const Map<String, dynamic> apikey = {'key':'xskjdfhshdfsf'};
const String urlApi = 'api.luckyjayagroup.my.id';
const String urlExec = 'luckyjayagroup.com';
const String urlExcadd2 = 'leontechdirect/proses.php';

String prosestxt = '';

enum TipeOperator { none, sales, gudang, admin, direksi, customer, umum }

bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < 600;
}

bool isTablet(BuildContext context) {
  return MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1200;
}

bool isDesktop(BuildContext context) {
  return MediaQuery.of(context).size.width >= 1200;
}