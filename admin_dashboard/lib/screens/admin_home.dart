import 'package:admin_dashboard/controllers/admin_auth_controller.dart';
import 'package:admin_dashboard/controllers/dashboard_controller.dart';
import 'package:admin_dashboard/screens/dashboard_overview.dart';
import 'package:admin_dashboard/screens/locations_page.dart';
import 'package:admin_dashboard/screens/properties_page.dart';
import 'package:admin_dashboard/screens/users_page.dart';
import 'package:admin_dashboard/widgets/top_bar.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key, required this.authController});

  final AdminAuthController authController;

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  late final DashboardController controller;

  @override
  void initState() {
    super.initState();
    controller = DashboardController()..addListener(_onControllerChanged);
    controller.load();
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
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final data = controller.data;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: isWide,
            backgroundColor: const Color(0xFF004D40),
            selectedIconTheme: const IconThemeData(color: Color(0xFFC6FF00)),
            unselectedIconTheme: const IconThemeData(color: Colors.white70),
            selectedLabelTextStyle: const TextStyle(color: Color(0xFFC6FF00)),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.groups_outlined),
                selectedIcon: Icon(Icons.groups),
                label: Text('Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.home_work_outlined),
                selectedIcon: Icon(Icons.home_work),
                label: Text('Properties'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.location_city_outlined),
                selectedIcon: Icon(Icons.location_city),
                label: Text('Locations'),
              ),
            ],
            selectedIndex: controller.selectedIndex,
            onDestinationSelected: controller.selectPage,
          ),
          Expanded(
            child: Column(
              children: [
                TopBar(
                  onRefresh: controller.load,
                  onLogout: widget.authController.logout,
                ),
                Expanded(child: _contentForState(data)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentForState(data) {
    if (controller.isLoading && data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage.isNotEmpty && data == null) {
      return Center(child: Text(controller.errorMessage));
    }

    if (data == null) {
      return const Center(child: Text('No dashboard data'));
    }

    return [
      DashboardOverview(data: data),
      UsersPage(data: data, controller: controller),
      PropertiesPage(data: data, controller: controller),
      LocationsPage(data: data, controller: controller),
    ][controller.selectedIndex];
  }
}
