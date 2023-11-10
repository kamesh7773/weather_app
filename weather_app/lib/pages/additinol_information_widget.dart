// ---------------------------
// Additinol information class
// ---------------------------

import 'package:flutter/material.dart';

class AdditinolInformation extends StatelessWidget {
  final IconData icon;
  final String lable;
  final String value;
  const AdditinolInformation(
      {super.key,
      required this.icon,
      required this.lable,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          lable,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }
}
