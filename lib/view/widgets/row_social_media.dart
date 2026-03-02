import 'package:flutter/material.dart';

class SmediaContainer extends StatelessWidget {
  const SmediaContainer({
    super.key,
    required this.height,
    required this.width,
    required this.link,
    required this.onTap,
  });

  final double height;
  final double width;
  final String link;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height * 0.07,
        width: width * 0.2,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.15),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.network(
          link,
          fit: BoxFit.contain,

          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
