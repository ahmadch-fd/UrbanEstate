import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:urban_estate/controllers/sign_up_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';
import 'package:urban_estate/utils/responsive.dart';
import 'package:urban_estate/view/screens/singn_in_screen.dart';
import 'package:urban_estate/view/widgets/custom_button.dart';
import 'package:urban_estate/view/widgets/row_social_media.dart';
import 'package:urban_estate/view/widgets/textfield_for_auth.dart';
import 'package:toastification/toastification.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final SignUpController signUpController;

  @override
  void initState() {
    super.initState();
    signUpController = Get.put(SignUpController());
  }

  void _showTermsAndConditions() {
    final responsive = Responsive.of(context);

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text(
            'Terms & Conditions',
            style: poppinsSemiBold.copyWith(
              fontSize: responsive.font(19),
              color: AppColors.mainTextColor,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              'By creating an Urban Estate account, you agree to use the app responsibly and provide accurate profile and property information.\n\n'
              'You must not post fake, misleading, illegal, offensive, or copied property listings.\n\n'
              'Property prices, predicted prices, images, addresses, and contact details are shared for property discovery and communication between users.\n\n'
              'You are responsible for the content you upload, including property photos, descriptions, and contact information.\n\n'
              'Urban Estate may remove posts, profiles, or content that violates these terms or affects user safety.\n\n'
              'Do not misuse messaging, spam other users, or share harmful files or content.\n\n'
              'The AI predicted price is an estimate only. It should not be treated as legal, financial, or guaranteed market advice.\n\n'
              'By continuing, you agree that you understand and accept these conditions.',
              style: poppinsRegular.copyWith(
                fontSize: responsive.font(13),
                height: 1.5,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: poppinsRegular.copyWith(color: Colors.grey.shade700),
              ),
            ),
            TextButton(
              onPressed: () {
                signUpController.hasAcceptedTerms.value = true;
                Navigator.of(context).pop();
              },
              child: Text(
                'Accept',
                style: poppinsSemiBold.copyWith(
                  color: AppColors.secondryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: signUpController.formKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30, top: 3),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.space(8)),
                  Text(
                    'Create your account',
                    style: poppinsSemiBold.copyWith(
                      fontSize: responsive.font(24),
                      color: AppColors.mainTextColor,
                    ),
                  ),
                  SizedBox(height: responsive.space(14)),
                  TextfieldForAuth(
                    label: 'Name',
                    hint: 'Enter your Username',
                    controller: signUpController.nameController,
                  ),
                  SizedBox(height: responsive.space(14)),
                  TextfieldForAuth(
                    label: 'Email',
                    hint: 'Enter your Email',
                    controller: signUpController.emailController,
                  ),
                  SizedBox(height: responsive.space(14)),
                  TextfieldForAuth(
                    label: 'Phone',
                    hint: 'Enter your Contact Number',
                    controller: signUpController.phoneController,
                  ),
                  SizedBox(height: responsive.space(14)),
                  TextfieldForAuth(
                    label: 'Password',
                    hint: 'Enter your Password',
                    obscureText: true,
                    controller: signUpController.passwordController,
                  ),
                  SizedBox(height: responsive.space(14)),
                  TextfieldForAuth(
                    label: 'Confirm Password',
                    hint: 'Enter your Confirm Password',
                    obscureText: true,
                    controller: signUpController.confirmpassController,
                  ),
                  SizedBox(height: responsive.space(4)),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: AppColors.secondryColor,
                          value: signUpController.hasAcceptedTerms.value,
                          onChanged: (value) {
                            signUpController.hasAcceptedTerms.value =
                                value ?? false;
                          },
                        ),
                        Text(
                          'I agree to the',
                          style: poppinsRegular.copyWith(
                            fontSize: responsive.font(13),
                          ),
                        ),
                        InkWell(
                          onTap: _showTermsAndConditions,
                          child: Text(
                            ' Terms & Conditions',
                            style: poppinsRegular.copyWith(
                              fontSize: responsive.font(13),
                              color: AppColors.secondryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => signUpController.isLoading.value
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            textColor: AppColors.mainTextColor,
                            color: AppColors.primaryButtonColor,
                            label: 'SIGN UP',
                            onTap: () async {
                              if (signUpController.passwordController.text !=
                                  signUpController
                                      .confirmpassController
                                      .text) {
                                toastification.show(
                                  autoCloseDuration: const Duration(seconds: 3),
                                  context: context,
                                  title: const Text('Sign Up Failed'),
                                  description: const Text(
                                    'Password and Confirm Password do not match',
                                  ),
                                  type: ToastificationType.error,
                                );
                                return;
                              }

                              if (signUpController.formKey.currentState!
                                  .validate()) {
                                final success = await signUpController.signUp();
                                if (success) {
                                  Get.offAll(() => const SingnInScreen());
                                }
                              }
                            },
                          ),
                  ),
                  SizedBox(height: responsive.space(10)),
                  Text(
                    'or sign up with',
                    style: poppinsRegular.copyWith(
                      fontSize: responsive.font(13),
                      color: const Color.fromARGB(255, 171, 169, 169),
                    ),
                  ),
                  SizedBox(height: responsive.space(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmediaContainer(
                        height: responsive.height,
                        width: responsive.width,
                        onTap: () => {},
                        link:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                      ),
                      SizedBox(width: responsive.space(16)),
                      SmediaContainer(
                        height: responsive.height,
                        width: responsive.width,
                        onTap: () => {},
                        link:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Facebook_Logo_%282019%29.png/600px-Facebook_Logo_%282019%29.png',
                      ),
                      SizedBox(width: responsive.space(16)),
                      SmediaContainer(
                        height: responsive.height,
                        width: responsive.width,
                        onTap: () => {},
                        link:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/X_logo_2023.svg/600px-X_logo_2023.svg.png',
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.space(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account then?',
                        style: poppinsRegular.copyWith(
                          fontSize: responsive.font(14),
                          color: Colors.grey,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const SingnInScreen());
                        },
                        child: Text(
                          ' SIGN IN',
                          style: poppinsRegular.copyWith(
                            fontSize: responsive.font(14),
                            color: const Color.fromARGB(255, 8, 169, 153),
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
