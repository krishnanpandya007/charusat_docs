import 'package:charusat_docs/screens/auth_controller.dart';
import 'package:charusat_docs/routes_name.dart';
import 'package:charusat_docs/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final TextEditingController emailcontroller = TextEditingController(text: "");
  final TextEditingController passwordcontroller =
      TextEditingController(text: "");
  bool loading = false;
  final AuthController authController = Get.put(
    AuthController(
      authApi: AuthApi(supabaseClient: Supabase.instance.client),
    ),
  );

  void handleSignin(String email, String password) async {
    setState(() {
      loading = true;
    });
    try{

        final response = await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);

        if(response.user == null){
          Get.snackbar("Error", "2 Invalid credentials");
        } else {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text("welcome, ${response.user?.email}")),
          // );
          // // Get.snackbar("Error", "3 Invalid credentials");
          // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => SplashScreen())));  




        }
        authController.login(email, password);

    }catch (e){
      print("GOTCHA");
      print(e);
          Get.snackbar("Error", "Invalid credentials");

    }
     finally  {
      
    setState(() {
      loading = false;
    });
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/depstar.png', // Path to your asset
                      height: 100, // Adjust the height as needed
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome To Depstar docs',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailcontroller,
                      decoration: const InputDecoration(
                        labelText: 'University Email',
                        hintText: 'ex: 21dce001@charusat.edu.in',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!value.endsWith('@charusat.edu.in') &&
                            !value.endsWith('@charusat.ac.in')) {
                          return 'Please use your Charusat email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordcontroller,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Your Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          if (_form.currentState!.validate() &&
                              authController.signinloading.value == false) {
                            handleSignin(
                                emailcontroller.text, passwordcontroller.text);
                          }
                        },
                        child: Text(
                          (authController.signinloading.value || true) && loading
                              ? "Loading........"
                              : 'Sign In',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(RoutesName.signup);
                      },
                      child: const Text("Don't have an account? Sign Up"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}