// import 'package:charusat_docs/routes_name.dart';
// import 'package:get/state_manager.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:get/get.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:charusat_docs/routes_name.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxService {
  @override
  void onInit() async {
    await Supabase.initialize(
      url: Constants.ApkUrl,
      anonKey: Constants.ApKkey,
    );
    listenAuthChanges();
    super.onInit();
  }

  // Supabase instance
  static final SupabaseClient supabase = Supabase.instance.client;

  // Listen auth event
  void listenAuthChanges() async {
    SupabaseService.supabase.auth.onAuthStateChange.listen((data) {

      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedOut) {
        StorageService.clearUserSession();
        Get.offAll(RoutesName.signin);
      } else if (event == AuthChangeEvent.signedIn) {
        if (session != null) {
          StorageService.saveUserSession(session);
          Get.offNamed(RoutesName.splash);
        }
      } else if (event == AuthChangeEvent.tokenRefreshed) {
        StorageService.clearUserSession();
        Get.offAll(RoutesName.signin);
      }
    });
  }
}

class Constants {
  static const String ApkUrl = "https://gznsrxsyvanpvmhdsqdz.supabase.co";
  static const String ApKkey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd6bnNyeHN5dmFucHZtaGRzcWR6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTYzNzUzMjYsImV4cCI6MjAzMTk1MTMyNn0.uaPLMTnDPXv-i4lXXR-I2JkiuS5jPmJmvezOBF43EPM";
  static const String authkey = "authkey";
}

class StorageService {
  static final GetStorage box = GetStorage();

  static Session? get getUserSession {
    final sessionData = box.read(Constants.authkey);
    if (sessionData != null) {
      return Session.fromJson(Map<String, dynamic>.from(sessionData));
    }
    return null;
  }

  static void saveUserSession(Session session) {
    box.write(Constants.authkey, session.toJson());
  }

  static void clearUserSession() {
    box.remove(Constants.authkey);
  }
}