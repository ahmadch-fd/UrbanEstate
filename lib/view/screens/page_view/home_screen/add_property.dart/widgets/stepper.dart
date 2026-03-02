import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress/step_progress.dart';
import 'package:urban_estate/controllers/stepper_controller.dart';

class CustomStepper extends StatelessWidget {
  const CustomStepper({super.key});

  // int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    StepProgressController _stepProgressController = StepProgressController(
      totalSteps: 5,
    );
    StepperController stepperController = Get.put(StepperController());

    return Obx(
      () => StepProgress(
        totalSteps: 5,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        controller: _stepProgressController,
        currentStep: stepperController.currentStep.value,
        // stepColor: Colors.grey[300],
      ),
    );
  }
}
