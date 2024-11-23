import 'package:flutter/material.dart';
import 'dart:math';


class FlipLoader extends StatefulWidget {
  final Color loaderBackground;
  final Color iconColor;
  final IconData icon;
  final String animationType;
  final String shape;
  final bool rotateIcon;

  const FlipLoader({super.key, this.loaderBackground = Colors.redAccent, this.iconColor = Colors.white, this.icon = Icons.sync, this.animationType = "full_flip", this.shape = "square", this.rotateIcon = true});

  @override
  // ignore: no_logic_in_create_state
  State<FlipLoader> createState() => _FlipLoaderState(loaderBackground, iconColor, icon, animationType, shape, rotateIcon);
}

class _FlipLoaderState extends State<FlipLoader> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> rotationHorizontal;
  late Animation<double> rotationVertical;
  late Color loaderColor;
  late Color iconColor;
  late IconData icon;
  late Widget loaderIconChild;
  late String animationType;
  late String shape;
  late bool rotateIcon;

  _FlipLoaderState(this.loaderColor, this.iconColor, this.icon, this.animationType, this.shape, this.rotateIcon);

  @override
  void initState() {
    super.initState();

    controller = createAnimationController(animationType);

    controller.addStatusListener((status) {
      // Play animation backwards and forwards for full flip
      if (animationType == "half_flip") {
        if (status == AnimationStatus.completed) {
          setState(() {
            controller.repeat();
          });
        }
      }
      // play animation on repeat for half flip
      else if (animationType == "full_flip") {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            controller.forward();
          });
        }
        if (status == AnimationStatus.completed) {
          setState(() {
            controller.repeat();
          });
        }
      }
      // custom animation state
      else {
        
      }
    });

    controller.forward();
  }

  AnimationController createAnimationController([String type = 'full_flip']) {
    AnimationController animCtrl;

    switch (type) {
      case "half_flip":
        animCtrl = AnimationController(duration: const Duration(milliseconds: 4000), vsync: this);

        // Horizontal animation
        rotationHorizontal = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animCtrl, curve: const Interval(0.0, 0.50, curve: Curves.linear)));

        // Vertical animation
        rotationVertical = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animCtrl, curve: const Interval(0.50, 1.0, curve: Curves.linear)));
        break;
      case "full_flip":
      default:
        animCtrl = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

        rotationHorizontal = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animCtrl, curve: const Interval(0.0, 0.50, curve: Curves.linear)));
        rotationVertical = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animCtrl, curve: const Interval(0.50, 1.0, curve: Curves.linear)));
        break;
    }

    return animCtrl;
  }

  @override
  Widget build(BuildContext context) {
    if (animationType == "half_flip") {
      return buildHalfFlipper(context);
    } else {
      return buildFullFlipper(context);
    }
  }

  Widget buildHalfFlipper(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.006)
            ..rotateX(sin(2 * pi * rotationVertical.value))
            ..rotateY(sin(2 * pi * rotationHorizontal.value)),
          alignment: Alignment.center,
          child: Container(
              decoration: BoxDecoration(
                shape: shape == "circle" ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: shape == "circle" ? null : const BorderRadius.all(Radius.circular(8.0)),
                color: loaderColor,
              ),
              width: 40.0,
              height: 40.0,
              child: rotateIcon == true
                  ? RotationTransition(
                      turns: rotationHorizontal.value == 1.0 ? rotationVertical : rotationHorizontal,
                      child: Center(
                        child: Icon(
                          icon,
                          color: iconColor,
                          size: 20.0,
                        ),
                      ),
                    )
                  : Center(
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 20.0,
                      ),
                    )),
        );
      },
    );
  }

  Widget buildFullFlipper(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.006)
            ..rotateX((2 * pi * rotationVertical.value))
            ..rotateY((2 * pi * rotationHorizontal.value)),
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              shape: shape == "circle" ? BoxShape.circle : BoxShape.rectangle,
              borderRadius: shape == "circle" ? null : const BorderRadius.all(Radius.circular(8.0)),
              color: loaderColor,
            ),
            width: 40.0,
            height: 40.0,
            child: Center(
              child: Icon(
                icon,
                color: iconColor,
                size: 20.0,
              ),
            ),
          ),
        );
      },
    );
  }
}
