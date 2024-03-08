import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicine_reminder_app/login_page.dart';
import 'package:medicine_reminder_app/main.dart';
import 'package:medicine_reminder_app/signup_page.dart';

// import 'package:firebase_core/firebase_core.dart';
class AuthPage extends StatelessWidget {
  AuthPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Home();
        } else {
          return LoginOrRegister();
        }
      },
    ));
  }
}

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});
  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;
  void changePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTop: changePage);
    } else {
      return SignUpPage(
        onTop: changePage,
      );
    }
  }
}
