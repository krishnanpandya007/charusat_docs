import 'package:charusat_docs/screens/signin.dart';
import 'package:charusat_docs/screens/verify.dart';
// import 'package:docs/signin.dart';
// import 'package:docs/verify.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.endsWith('@charusat.edu.in') || email.endsWith('@charusat.ac.in')) {
        final response = await supabase.auth.signUp(
          // data: {"name": nameController.text.trim()},
          email: email,
          password: password,
        ).then((value) {
          print("SIGNUPERROR:");
          print((value as AuthResponse).session);
          print((value as AuthResponse).user);
          print((value as AuthResponse).user?.email);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-up successful! Please verify your email.')),
          );
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(builder: (BuildContext context) => EmailVerification()),
            ModalRoute.withName('/'),
          );
        },).catchError((err){
          print("SIGNUPERRORd:");
          print(err.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${err}')),
          );
        });
        // if (await response.user == null) {

        //   // Handle error
        //   // ScaffoldMessenger.of(context).showSnackBar(
        //   //   SnackBar(content: Text('Error: ${response.error!.message}')),
        //   // );
        // } else {
        //   // Handle successful sign-up
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Sign-up successful! Please verify your email.')),
        //   );
        //   Navigator.pushAndRemoveUntil<void>(
        //     context,
        //     MaterialPageRoute<void>(builder: (BuildContext context) => EmailVerification()),
        //     ModalRoute.withName('/'),
        //   );
        // }
      } else {
        // Show error if email is not from organization
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Please use your Charusat email')),
        );
      }
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
              constraints: BoxConstraints(maxWidth: 600), // Adjust maxWidth as needed
              child: Form(
                key: _formKey,
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
                      'Depstar Docs',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'ex: Smith Johnson',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'University Email',
                        hintText: 'ex: 21dce001@charusat.edu.in',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!value.endsWith('@charusat.edu.in') && !value.endsWith('@charusat.ac.in')) {
                          return 'Please use your Charusat email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Your Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 8) {
                          return 'Password must be at least 8 characters long';
                        } else if (!RegExp(r'[A-Z]').hasMatch(value) ||
                            !RegExp(r'[a-z]').hasMatch(value) ||
                            !RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Password must contain upper, lower case letters and numbers';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signUp,
                      child: const Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50), // Make button full width
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil<void>(
                          context,
                          MaterialPageRoute<void>(builder: (BuildContext context) => SignIn()),
                          ModalRoute.withName('/'),
                        );
                      },
                      child: const Text('Already have an account? Sign In'),
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