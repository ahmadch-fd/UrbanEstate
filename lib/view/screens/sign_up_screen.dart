import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:urban_estate/controllers/sign_up_controller.dart';
import 'package:urban_estate/utils/app_colors.dart';
import 'package:urban_estate/utils/app_const.dart';
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

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

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
                  SizedBox(height: height * 0.01),
                  Text(
                    'Create your account',
                    style: poppinsSemiBold.copyWith(
                      fontSize: height * 0.03,
                      color: AppColors.mainTextColor,
                    ),
                  ),
                  SizedBox(height: height * 0.018),
                  TextfieldForAuth(
                    label: 'Name',
                    hint: 'Enter your Username',
                    controller: signUpController.nameController,
                  ),
                  SizedBox(height: height * 0.018),
                  TextfieldForAuth(
                    label: 'Email',
                    hint: 'Enter your Email',
                    controller: signUpController.emailController,
                  ),
                  SizedBox(height: height * 0.018),
                  TextfieldForAuth(
                    label: 'Password',
                    hint: 'Enter your Password',
                    obscureText: true,
                    controller: signUpController.passwordController,
                  ),
                  SizedBox(height: height * 0.018),
                  TextfieldForAuth(
                    label: 'Confirm Password',
                    hint: 'Enter your Confirm Password',
                    obscureText: true,
                    controller: signUpController.confirmpassController,
                  ),
                  SizedBox(height: height * 0.005),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: AppColors.secondryColor,
                        value: true,
                        onChanged: (value) {},
                      ),

                      Text(
                        'I agree to the',
                        style: poppinsRegular.copyWith(fontSize: 13),
                      ),
                      InkWell(
                        onTap: () => {},
                        child: Text(
                          ' Terms & Conditions',
                          style: poppinsRegular.copyWith(
                            fontSize: 13,
                            color: AppColors.secondryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                    textColor: AppColors.mainTextColor,
                    color: AppColors.primaryButtonColor,
                    label: 'SIGN UP',
                    onTap: () {
                      if (signUpController.passwordController.text !=
                          signUpController.confirmpassController.text) {
                        toastification.show(
                          autoCloseDuration: const Duration(seconds: 3),
                          context: context,
                          title: Text('Sign Up Failed'),
                          description: Text(
                            'Password and Confirm Password do not match',
                          ),
                          type: ToastificationType.error,
                        );
                        return;
                      }
                      if (signUpController.formKey.currentState!.validate()) {
                        print("Form Valid");
                      }
                    },
                  ),
                  SizedBox(height: height * 0.013),
                  Text(
                    'or sign up with',
                    style: poppinsRegular.copyWith(
                      fontSize: 13,
                      color: const Color.fromARGB(255, 171, 169, 169),
                    ),
                  ),
                  SizedBox(height: height * 0.016),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmediaContainer(
                        height: height,
                        width: width,
                        onTap: () => {},
                        link:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                      ),
                      SizedBox(width: width * 0.04),
                      SmediaContainer(
                        height: height,
                        width: width,
                        onTap: () => {},
                        link:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Facebook_Logo_%282019%29.png/600px-Facebook_Logo_%282019%29.png',
                      ),
                      SizedBox(width: width * 0.04),
                      SmediaContainer(
                        height: height,
                        width: width,
                        onTap: () => {},
                        link:
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/X_logo_2023.svg/600px-X_logo_2023.svg.png',
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account then?',
                        style: poppinsRegular.copyWith(
                          fontSize: 14,
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
                            fontSize: 14,
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
