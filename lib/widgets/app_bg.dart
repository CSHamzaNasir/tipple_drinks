import 'package:flutter/material.dart';
import 'package:tipple_drinks/constant/app_assets.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      position: DecorationPosition.background,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(AppAssets.whiteBg),
        ),

        color: Colors.white,
      ),
      child: child,
    );
  }
}
