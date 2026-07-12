import 'package:admin_dashboard/models/dashboard_data.dart';
import 'package:admin_dashboard/services/admin_service.dart';
import 'package:flutter/foundation.dart';

class DashboardController extends ChangeNotifier {
  DashboardData? data;
  bool isLoading = false;
  String errorMessage = '';
  int selectedIndex = 0;

  Future<void> load() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      data = await AdminService.dashboardData();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectPage(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future<void> deleteProfile(String id) async {
    await AdminService.deleteProfile(id);
    await load();
  }

  Future<void> deleteProperty(String id) async {
    await AdminService.deleteProperty(id);
    await load();
  }

  Future<void> addLocation({
    required String province,
    required String city,
  }) async {
    await AdminService.addLocation(province: province, city: city);
    await load();
  }

  Future<void> setLocationActive(String id, bool isActive) async {
    await AdminService.setLocationActive(id, isActive);
    await load();
  }

  Future<void> deleteLocation(String id) async {
    await AdminService.deleteLocation(id);
    await load();
  }
}
