import 'package:flutter/material.dart';

import '../util/method.dart';

class FormWidget extends StatelessWidget {
  const FormWidget(
      {super.key,
      required this.h,
      required this.label,
      required this.intText,
      required this.type,
      required this.controllerText,
      required this.useIcon,
      this.obscure = false});

  final double h;
  final String label;
  final String intText;
  final TextEditingController controllerText;
  final TextInputType type;
  final bool useIcon;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    controllerText.text = intText;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(h * 0.02)),
      child: Container(
        padding: EdgeInsets.all(h * 0.01),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: customFonts(20, Colors.black, FontWeight.bold)),
            SizedBox(height: h * 0.01),
            TextFormField(
              controller: controllerText,
              keyboardType: type,
              obscureText: obscure,
              style: customFonts(
                  17, const Color.fromARGB(255, 83, 83, 83), FontWeight.bold),
              decoration: InputDecoration(
                  border: const UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 253, 253, 253),
                  // hintText: intText,
                  hintStyle: customFonts(17, Colors.grey, FontWeight.bold),
                  suffixIcon: useIcon
                      ? IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.visibility,
                            size: 24,
                            color: Colors.grey,
                          ),
                        )
                      : null),
              cursorColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
