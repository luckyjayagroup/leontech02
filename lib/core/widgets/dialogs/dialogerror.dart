import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leontech/core/utils/function_string.dart';
Duration _duration = const Duration(seconds: 0);
String _pesanText = '';
bool _pesan = false;
Color _warnaPesan = Colors.white.withOpacity(.8);
Color _warnaPesanText = Colors.black;
doError(String kesalahan) {
  // pesanError1(kesalahan);
  dp('kesalahan : $kesalahan');
}


void pesanError(String pesan, {Duration durasi = const Duration(seconds: 10)}) {
  dp(pesan);
  Function? sheetSetState;
  void addTime() {
    if (sheetSetState == null) return;

    sheetSetState!(() {
      final seconds = _duration.inSeconds + 1;
      _duration = Duration(seconds: seconds);
      if (_duration == durasi) Get.back();
    });
  }

  _warnaPesanText = Colors.white;
  _warnaPesan = Colors.redAccent[700]!.withOpacity(0.8);
  _pesanText = pesan;
  if (_pesan == true) {
    _duration = const Duration(seconds: 0);
    return;
  } else {
    _duration = const Duration(seconds: 0);

    Timer timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
    _pesan = true;
    showModalBottomSheet<void>(
        elevation: 0,
        barrierColor: Colors.black.withAlpha(1),
        backgroundColor: Colors.transparent,
        context: Get.context!,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              sheetSetState = setState;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    //side: BorderSide(color: Colors.red, width: 5),
                  ),
                  color: _warnaPesan,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
                            child: Text("Tutup ${((durasi.inSeconds - _duration.inSeconds) > 60) ? '' : durasi.inSeconds - _duration.inSeconds}"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 40),
                          child: Text(
                            _pesanText,
                            style: TextStyle(color: _warnaPesanText),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).then((value) {
      _pesan = false;
      timer.cancel();
    });
  }
}
