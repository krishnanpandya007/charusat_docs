import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'signin.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    _checkEmailVerified();
  }

  Future<void> _checkEmailVerified() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null && user.emailConfirmedAt != null) {
      setState(
        () {
          _isEmailVerified = true;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isEmailVerified) {
      Future.delayed(Duration.zero, () {
        Navigator.pushAndRemoveUntil<void>(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => const SignIn()),
          ModalRoute.withName('/'),
        );
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Email Verification',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'A verification link has been sent to your email address. Please check your inbox and verify your email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const SignIn(),
                      ),
                      ModalRoute.withName('/'),
                    );
                  },
                  child: const Text('Back to Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}