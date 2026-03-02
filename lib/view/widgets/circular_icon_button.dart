import 'package:flutter/material.dart';

// class CircularIconButton extends StatelessWidget {
//   const CircularIconButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ();
//   }
// }

Widget circleIconButton(
  IconData icon, {
  Color bgColor = const Color(0xFF004D40),
  void Function()? ontap,
}) {
  return InkWell(
    onTap: ontap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
  );
}
