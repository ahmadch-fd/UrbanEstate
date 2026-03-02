// import 'package:flutter/material.dart';
// import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/custom_app_bar.dart';
// import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/stepper.dart';

// class AddProperty extends StatelessWidget {
//   const AddProperty({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             CustomAppBar(),
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: CustomStepper(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/post_property_screen_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/steps_for_stepper/step1.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/steps_for_stepper/step2.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/steps_for_stepper/step3.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/steps_for_stepper/step4.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/custom_app_bar.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/custom_primary_button.dart';
import 'package:urban_estate/view/screens/page_view/home_screen/add_property.dart/widgets/custom_stepper_indicator.dart';
// import '../controllers/post_property_controller.dart';
// import '../widgets/reusable_widgets.dart';
// import 'step1_property_details.dart';
// import 'step2_location.dart';
// import 'step3_pricing.dart';
// import 'step4_features.dart';

class PostPropertyScreen extends StatelessWidget {
  const PostPropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostPropertyController());
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: CustomAppBar(),
      ),
      // Use resizeToAvoidBottomInset to ensure the keyboard doesn't hide your button
      //   resizeToAvoidBottomInset: true,
      body: Obx(() {
        final step = controller.currentStep.value;
        return Column(
          children: [
            // Fixed Stepper Indicator
            Container(
              color: Colors.white,
              child: CustomStepperIndicator(totalSteps: 4, currentStep: step),
            ),

            // Scrollable Form Area
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: KeyedSubtree(
                  key: ValueKey<int>(step),
                  child: SingleChildScrollView(
                    // Physics ensures smooth scrolling even with short content
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: _buildStepContent(step, controller),
                  ),
                ),
              ),
            ),

            // Fixed Bottom Button Area
            // This ensures the "Next" button is always easily accessible
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withValues(alpha: 0.05),
            //         blurRadius: 10,
            //         offset: const Offset(0, -5),
            //       ),
            //     ],
            //   ),

            //   // child: PrimaryButton(
            //   //   label: step == 3 ? 'Submit' : 'Next',
            //   //   onTap: () {
            //   //     if (step == 0 && controller.validateStep1())
            //   //       controller.nextStep();
            //   //     else if (step == 1 && controller.validateStep2())
            //   //       controller.nextStep();
            //   //     else if (step == 2 && controller.validateStep3())
            //   //       controller.nextStep();
            //   //     else if (step == 3)
            //   //       controller.submitForm();
            //   //   },
            //   // ),
            // ),
            SizedBox(height: height * 0.1),
          ],
        );
      }),
    );
  }

  Widget _buildStepContent(int step, PostPropertyController controller) {
    switch (step) {
      case 0:
        return Step1PropertyDetails(controller: controller);
      case 1:
        return Step2Location(controller: controller);
      case 2:
        return Step3Pricing(controller: controller);
      case 3:
        return Step4Features(controller: controller);
      default:
        return const SizedBox.shrink();
    }
  }
}
