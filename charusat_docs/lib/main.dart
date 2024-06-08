import 'package:charusat_docs/routes_name.dart';
import 'package:charusat_docs/screens/cometee.dart';
import 'package:charusat_docs/screens/signin.dart';
import 'package:charusat_docs/screens/splash_screen.dart';
import 'package:charusat_docs/screens/upload_document.dart';
import 'package:charusat_docs/supabase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Supabase.initialize(
//     url: 'https://gznsrxsyvanpvmhdsqdz.supabase.co',
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd6bnNyeHN5dmFucHZtaGRzcWR6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTYzNzUzMjYsImV4cCI6MjAzMTk1MTMyNn0.uaPLMTnDPXv-i4lXXR-I2JkiuS5jPmJmvezOBF43EPM',
//   );
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Get.putAsync<SupabaseService>(() async => SupabaseService());
  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: Pages.pages,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: SplashScreen(),  
    );
  }
}