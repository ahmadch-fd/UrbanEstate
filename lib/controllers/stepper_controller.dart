import 'package:get/get.dart';

class StepperController extends GetxController {
  var currentStep = 0.obs;

  void setCurrentStep(int step) {
    currentStep.value = step;
  }
}
