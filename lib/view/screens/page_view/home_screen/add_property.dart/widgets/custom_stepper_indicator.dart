import 'package:flutter/material.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/step_circle.dart';

class CustomStepperIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const CustomStepperIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: List.generate(totalSteps * 2 - 1, (index) {
          if (index.isOdd) {
            // Connector line
            final stepIndex = index ~/ 2;
            final isCompleted = stepIndex < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                color: isCompleted ? AppColors.primary : AppColors.border,
              ),
            );
          } else {
            // Step circle
            final stepIndex = index ~/ 2;
            final isCompleted = stepIndex < currentStep;
            final isCurrent = stepIndex == currentStep;

            return _StepCircle(
              stepNumber: stepIndex + 1,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
            );
          }
        }),
      ),
    );
  }
}
class _StepCircle extends StatelessWidget {
  final int stepNumber;
  final bool isCompleted;
  final bool isCurrent;

  const _StepCircle({
    required this.stepNumber,
    required this.isCompleted,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    Widget child;

    if (isCompleted) {
      bgColor = AppColors.primary;
      borderColor = AppColors.primary;
      child = const Icon(Icons.check, size: 14, color: Colors.white);
    } else if (isCurrent) {
      bgColor = Colors.white;
      borderColor = AppColors.primary;
      child = Text(
        '$stepNumber',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      );
    } else {
      bgColor = Colors.white;
      borderColor = AppColors.border;
      child = Text(
        '$stepNumber',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade400,
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Center(child: child),
    );
  }
}