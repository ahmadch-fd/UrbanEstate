import 'package:flutter/material.dart';
import 'package:urban_estate/utils/responsive.dart';

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

  String get _label {
    final lowerLink = link.toLowerCase();
    if (lowerLink.contains('google')) return 'G';
    if (lowerLink.contains('facebook')) return 'f';
    if (lowerLink.contains('x_logo') || lowerLink.contains('twitter')) {
      return 'X';
    }
    return '?';
  }

  Color get _color {
    final lowerLink = link.toLowerCase();
    if (lowerLink.contains('google')) return const Color(0xFF4285F4);
    if (lowerLink.contains('facebook')) return const Color(0xFF1877F2);
    if (lowerLink.contains('x_logo') || lowerLink.contains('twitter')) {
      return Colors.black;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: responsive.socialButtonHeight,
        width: responsive.socialButtonWidth,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.15),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            _label,
            style: TextStyle(
              color: _color,
              fontSize: responsive.font(24),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
