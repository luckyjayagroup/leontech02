import 'package:flutter/material.dart';
import 'package:leontech/core/widgets/loaders/color_loader_3.dart';

Widget showloading({Function()? onPressed}) {
  return Material(
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ColorLoader3(radius: 20, dotRadius: 5),
          const SizedBox(height: 5),
          // Obx(() =>
          const Text(
            " dbc.prosesText.value",
            style: TextStyle(color: Colors.black),
            //   )
          ),
          (onPressed != null)
              ? SizedBox(
                  height: 20,
                  child: ElevatedButton(onPressed: onPressed, child: const Text("batal")),
                )
              : Container(),
        ],
      ),
    ),
  );
}