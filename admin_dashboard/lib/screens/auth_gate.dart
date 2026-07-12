import 'package:admin_dashboard/controllers/admin_auth_controller.dart';
import 'package:admin_dashboard/screens/admin_home.dart';
import 'package:admin_dashboard/screens/login_screen.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final AdminAuthController controller;

  @override
  void initState() {
    super.initState();
    controller = AdminAuthController()..addListener(_onControllerChanged);
    controller.checkSession();
  }

  void _onControllerChanged() => setState(() {});

  @override
  void dispose() {
    controller.removeListener(_onControllerChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.isChecking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return controller.isAllowed
        ? AdminHome(authController: controller)
        : LoginScreen(controller: controller);
  }
}
