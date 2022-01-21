import 'package:flutter/material.dart';

void showsnackbar(
    {required BuildContext context,
    IconData? icona,
    String? testo,
    Color? coloresfondo}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: coloresfondo,
      content: Row(
        children: [
          Icon(
            icona,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            testo!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          )
        ],
      ),
    ),
  );
}
