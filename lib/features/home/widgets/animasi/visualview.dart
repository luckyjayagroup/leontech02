import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VisualView extends StatelessWidget {
  final double fontSize;
  const VisualView({this.fontSize= 20,super.key});

  @override
  Widget build(BuildContext context) {
    // create our stylish text:
    Widget title =  Text(
      'Luckyjaya Group\nSparepart',
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: fontSize,
        color: const Color(0xFF666870),
        height: 0.9, //letterSpacing: -5,
      ),
    );

    // add a rainbow gradient:
    // I'm lazy so I'll just apply a ShimmerEffect, use a ValueAdapter to
    // pause it half way, and let it handle the details
    title = title.animate(adapter: ValueAdapter(0.5)).shimmer(
      colors: [
        const Color(0xFFFFFF00),
        const Color(0xFF00FF00),
        const Color(0xFF00FFFF),
        const Color(0xFF0033FF),
        const Color(0xFFFF00FF),
        const Color(0xFFFF0000),
        const Color(0xFFFFFF00),
      ],
    );

    // sequence some visual effects
    title = title
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .saturate(delay: 1000.ms, duration: 5000.ms)
        .then() // set baseline time to previous effect's end time
        .tint(color: const Color(0xFF80DDFF))
        .then()
        .blurXY(end: 24)
        .fadeOut();

    return Padding(padding: const EdgeInsets.all(24), child: title);
  }
}