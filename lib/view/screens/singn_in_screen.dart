import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_estate/controllers/sign_in_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:urban_estate/view/screens/page_view/page_view.dart';
import 'package:urban_estate/view/screens/welcome_screen.dart'
    hide OnboardingScreen;
import 'package:urban_estate/view/screens/sign_up_screen.dart';
import 'package:urban_estate/view/widgets/clickCartText.dart';
import 'package:urban_estate/view/widgets/custom_button.dart';
import 'package:urban_estate/view/widgets/row_social_media.dart';
import 'package:urban_estate/view/widgets/textfield_for_auth.dart';

class SingnInScreen extends StatefulWidget {
  const SingnInScreen({super.key});

  @override
  State<SingnInScreen> createState() => _SingnInScreenState();
}

class _SingnInScreenState extends State<SingnInScreen> {
  late final SignInController signInController;

  @override
  void initState() {
    super.initState();
    signInController = Get.put(SignInController());
  }

  @override
  Widget build(BuildContext context) {
    // final SignInController controller = Get.put(SignInController());

    final size = MediaQuery.of(context).size;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Form(
            key: signInController.informKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.06),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 50,
                        width: 50,
                      ),
                      const SizedBox(width: 8),
                      Clickcarttext(fontSize: size.height * 0.03),
                    ],
                  ),

                  SizedBox(height: size.height * 0.08),

                  Text(
                    'Sign in your account',
                    style: poppinsSemiBold.copyWith(
                      fontSize: 26,
                      color: AppColors.mainTextColor,
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),

                  TextfieldForAuth(
                    label: 'Email',
                    hint: 'Enter your Email',
                    controller: signInController.emailController,
                  ),

                  SizedBox(height: size.height * 0.02),

                  TextfieldForAuth(
                    label: 'Password',
                    hint: 'Enter your Password',
                    obscureText: true,
                    controller: signInController.passwordController,
                  ),

                  SizedBox(height: size.height * 0.05),

                  /// BUTTON
                  Obx(
                    () => signInController.isLoading.value
                        ? const CircularProgressIndicator()
                        : CustomButton(
                          textColor: AppColors.mainTextColor,
                            color: AppColors.primaryButtonColor,
                            label: 'SIGN IN',
                            onTap: () {
                              if (signInController.informKey.currentState!
                                  .validate()) {
                                print("Login Valid");
                                Get.to(() => const OnboardingScreen());
                              }
                            },
                          ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  Text(
                    'or sign in with',
                    style: poppinsRegular.copyWith(fontSize: 16),
                  ),

                  SizedBox(height: size.height * 0.025),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmediaContainer(
                        height: height,
                        width: width,
                        onTap: () {
                          //       if (signInController.emailController.text !=
                          //     signInController.confirmpassController.text) {
                          //   toastification.show(
                          //     context: context,
                          //     title: Text('Sign Up Failed'),
                          //     description: Text(
                          //       'Password and Confirm Password do not match',
                          //     ),
                          //     type: ToastificationType.error,
                          //   );
                          //   return;
                          // }
                        },

                        link:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                      ),
                      const SizedBox(width: 20),
                      SmediaContainer(
                        height: height,
                        width: width,
                        onTap: () {},
                        link:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Facebook_Logo_%282019%29.png/600px-Facebook_Logo_%282019%29.png',
                      ),
                      const SizedBox(width: 20),
                      SmediaContainer(
                        height: height,
                        width: width,
                        onTap: () {},
                        link:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/X_logo_2023.svg/600px-X_logo_2023.svg.png',
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.03),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: poppinsRegular.copyWith(fontSize: 13),
                      ),
                      InkWell(
                        onTap: () => Get.to(() => const SignUpScreen()),
                        child: Text(
                          ' SIGN UP',
                          style: poppinsRegular.copyWith(
                            fontSize: 13,
                            color: AppColors.secondryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
