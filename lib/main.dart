import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:urban_estate/controllers/image_picker_controller.dart';
import 'package:urban_estate/view/screens/page_view/page_view.dart'
    as main_view;
import 'package:urban_estate/view/screens/welcome_screen.dart' as welcome;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gdvkvoeescshxeoarowz.supabase.co',
    anonKey: 'sb_publishable_SB8keuu_4EghtQGFg1Miyw_5_w7Ira4',
  );
  final isLoggedIn = Supabase.instance.client.auth.currentUser != null;

  Get.put(ImagePickerController(), permanent: true);

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: isLoggedIn
          ? const main_view.OnboardingScreen()
          : const welcome.OnboardingScreen(),
    );
  }
}
