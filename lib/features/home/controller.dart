import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:leontech/core/models/dashboard/chart.dart';
import 'package:leontech/core/models/dashboard/dash_b.dart';
import 'package:leontech/core/models/dashboard/omset.dart';
import 'package:leontech/core/models/dashboard/top.dart';
import 'package:leontech/core/services/fastscript.dart';
import 'package:leontech/core/utils/function_string.dart';
import 'package:leontech/core/widgets/charts/model.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(() => HomePageController());

  }
}

HomePageController getHomeController() {
  if (Get.isRegistered<HomePageController>()) {
    return Get.find<HomePageController>();
  }
  return Get.put(HomePageController());
}

class HomePageController extends GetxController {
  var rl = [].obs;
  var totalRL = 0.0.obs;
  var ddashb = DashB().obs;
  var domsetchart = Chart().obs;
  var dlistTop10 = <Top10>[].obs;
  var dtop10customer = <Top10>[].obs;
  var dtop10item = <Top10>[].obs;
  var dtop10kabupaten = <Top10>[].obs;
  var dtop10Sales = <Top10>[].obs;
  var trigger = 0.obs;
  var dechart = <XBarData2>[].obs;
  Rx<int> tgIndex = (-1).obs;
  var statusx = 'kh'.obs();

  @override
  void onInit() {
    statusx = 'memulai';
    getData();
    super.onInit();
  }

  settouchedGroupIndex(int val) {
    tgIndex.value = val;
    update();
  }

 
  List<XBarData2> _getchart() {
    var dx = <XBarData2>[];
    for (var y in domsetchart.value.omset) {
      double pelunasan = 0;
      double tempo = 0;
      if (kIsWeb) {
        pelunasan = domsetchart.value.pelunasan
            .firstWhere((e) => e.tahun == y.tahun && e.bulan == y.bulan,
                orElse: () => Omset(tahun: y.tahun, bulan: y.bulan, total: 0))
            .total;
        tempo = domsetchart.value.tempo
            .firstWhere((e) => e.tahun == y.tahun && e.bulan == y.bulan,
                orElse: () => Omset(tahun: y.tahun, bulan: y.bulan, total: 0))
            .total;
      } else {
        pelunasan = domsetchart.value.pelunasan
            .firstWhere((e) => e.tahun == y.tahun && e.bulan == y.bulan,
                orElse: () => Omset(tahun: y.tahun, bulan: y.bulan, total: 0))
            .total;
        tempo = domsetchart.value.tempo
            .firstWhere((e) => e.tahun == y.tahun && e.bulan == y.bulan,
                orElse: () => Omset(tahun: y.tahun, bulan: y.bulan, total: 0))
            .total;
      }

      dx.add(XBarData2(y.bulan, y.total, pelunasan, tempo));
    }
    return dx;
  }

  Future<void> getData([bool withloading = false]) async {
  
setProses('download data dashboard');
    getRL();
    getGlobal();
    getTop10();
    getChart();

  }
  getChart()async{
    try {
      trigger++;
     
      setProses('download data dashboard');
      
      // await executeSql3('select * from periodicglobal');
    var res1 = await FastScript.execByid(1);
    if (res1 != null) {
      
        var alldata = res1.map((e) => Omset.fromMap(e)).toList();
        domsetchart.value.omset = alldata.where((e) => e.tipe == 1).toList();
        domsetchart.value.pelunasan =
            alldata.where((e) => e.tipe == 2).toList();
        domsetchart.value.tempo = alldata.where((e) => e.tipe == 3).toList();
      }
      
      dechart.value = _getchart();
      
      
      
      setProses('inisialisasi dashboard selesai');

      trigger++;
      statusx = "ok";
      update();
    } catch (e, s) {
      dp("error: $e\nstacktrace: $s");
    }
  }
getGlobal()async{
  //await executeSql('call omsetglobal');
       var res3 = await FastScript.execByid(3);
      if (res3 != null) {
        if (res3.isNotEmpty) {
         
          ddashb.value = DashB.fromMap(res3.first[0]);
        } else {
          ddashb.value = DashB();
        }
      }
      update();
}
getTop10()async{

// await executeSql3('call top10_global');
      var res2 = await FastScript.execByid(2);
      
      if (res2 != null) {
       List<Top10> allTop10 = res2.first.map<Top10>((e) => Top10.fromMap(e)).toList();

        dlistTop10.value = allTop10;
        dtop10customer.value = allTop10.where((e) => e.tipe == 2).toList();
        dtop10item.value = allTop10.where((e) => e.tipe == 1).toList();
        dtop10kabupaten.value = allTop10.where((e) => e.tipe == 3).toList();
        dtop10Sales.value = allTop10.where((e) => e.tipe == 4).toList();
      }
      update();}


  getRL()async{
  
    rl.value = await FastScript.execByNama('rekaprugilaba')??[];
    trigger++;
    totalRL.value = rl.fold(0.0, (sum, e) => sum + (double.tryParse(e['mutasi'].toString())??0));
    update();
       

  }
}
