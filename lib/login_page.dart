import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder_app/service/forgot_password.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTop;
  const LoginPage({super.key, required this.onTop});

  @override
  State<LoginPage> createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  bool isHidden = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    isHidden = true;
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red,
            title: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/assets/loginBG.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'lib/assets/logo.png',
                    height: 300,
                    //width: 700,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.00, right: 25),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.account_box_rounded,
                            size: 40.0,
                            color: Color.fromARGB(255, 50, 30, 80),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 95, 76, 221),
                                width: 2.0),
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 50, 30, 80))),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 25.00, right: 25.00, top: 8.00),
                    child: TextField(
                      controller: passwordController,
                      obscureText: isHidden,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock,
                          size: 40.0,
                          color: Color.fromARGB(255, 50, 30, 80),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 95, 76, 221),
                              width: 2.0),
                        ),
                        labelText: 'Password',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 50, 30, 80)),

                        // helperText: "Password must contain special character",
                        // helperStyle: TextStyle(color: Colors.green),
                        suffixIcon: IconButton(
                          icon: Icon(isHidden
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(
                              () {
                                isHidden = !isHidden;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage()),
                            );
                          },
                          child: Text('Forgot Password?    ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 50, 46, 46),
                              )))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: signUserIn,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 50, 30, 80),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 30)),
                  const SizedBox(
                    width: 25,
                  ),
                  Padding(padding: EdgeInsets.only(top: 205)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Need an account? '),
                      GestureDetector(
                        onTap: widget.onTop,
                        child: const Text(
                          ' Sign Up',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 40)),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
