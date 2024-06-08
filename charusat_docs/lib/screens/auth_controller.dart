import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:charusat_docs/routes_name.dart'; // Ensure you import your routes

class AuthController extends GetxController {
  RxBool signinloading = false.obs;
  RxBool signuploading = false.obs;

  final AuthApi authApi;

  AuthController({required this.authApi});

  void login(String email, String password) async {
    signinloading.value = true;
    final response = await authApi.login_method(email, password);
    if (response.isBlank == null) {
      Get.snackbar("Success", "Logged in successfully");
    } else {
      Get.snackbar("Error", "Something went wrong");
    }
    signinloading.value = false;
  }

  Future<void> signup(String email, String password) async {
    signuploading.value = true;
    final response = await authApi.signup_method(email, password);
    signuploading.value = false;
    if (response.isBlank == null) {
      Get.snackbar(
          "Success", "Signed up successfully. Please verify your email.");
      Get.toNamed(RoutesName.verify);
    } else {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}

class AuthApi {
  final SupabaseClient supabaseClient;

  AuthApi({required this.supabaseClient});

  Future<AuthResponse> login_method(
      String email, String password) async {
    final response =
        await supabaseClient.auth.signInWithPassword(email: email, password: password);
    return response;
  }

  Future<AuthResponse> signup_method(
      String email, String password) async {
    final response = await supabaseClient.auth.signUp(email: email, password: password);
    return response;
  }
}