import 'package:flutter/material.dart';

import '../util/method.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.h,
      required this.label,
      required this.touch,
      required this.colorBtn,
      required this.textColor});

  final double h;
  final String label;
  final Function touch;
  final Color colorBtn, textColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      child: MaterialButton(
        onPressed: () {
          touch();
        },
        color: colorBtn,
        minWidth: double.infinity,
        height: h * 0.1,
        child: Text(
          label,
          style: customFonts(17, textColor, FontWeight.w200),
        ),
      ),
    );
  }
}
