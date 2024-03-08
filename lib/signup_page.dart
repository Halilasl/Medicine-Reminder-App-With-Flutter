// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  final Function()? onTop;
  const SignUpPage({super.key, required this.onTop});
  @override
  State<SignUpPage> createState() => SignUpState();
}

class SignUpState extends State<SignUpPage> {
  bool isHidden = true;
  bool isHiddenAgain = true;
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordAgainController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (passwordController.text == passwordAgainController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        User? user = FirebaseAuth.instance.currentUser;
        await user!.updateDisplayName(nameController.text);

        CollectionReference users =
            FirebaseFirestore.instance.collection('users');
        await users.doc(user.uid).set({
          'Name': nameController.text,
        });
      } else {
        showErrorMessage("Passwords Don't Match!");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
    //Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    isHidden = true;
  }

  void initAgainState() {
    super.initState();
    isHiddenAgain = true;
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
            Column(
              children: [
                Image.asset(
                  'lib/assets/logo.png',
                  height: 330,
                  //width: 700,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.00, right: 25, top: 0),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
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
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 50, 30, 80))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.00, right: 25, top: 8),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
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
                        labelText: 'Full Name',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 50, 30, 80))),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 25.00, right: 25.00, top: 8.00),
                  child: TextField(
                    controller: passwordController,
                    obscureText: isHidden,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
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
                        icon: Icon(
                            isHidden ? Icons.visibility : Icons.visibility_off),
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
                Padding(
                  padding: EdgeInsets.only(
                      left: 25.00, right: 25.00, top: 8.00, bottom: 50),
                  child: TextField(
                    controller: passwordAgainController,
                    obscureText: isHiddenAgain,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 95, 76, 221),
                            width: 2.0),
                      ),
                      labelText: 'Password Again',
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 50, 30, 80)),

                      // helperText: "Password must contain special character",
                      // helperStyle: TextStyle(color: Colors.green),
                      suffixIcon: IconButton(
                        icon: Icon(isHiddenAgain
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(
                            () {
                              isHiddenAgain = !isHiddenAgain;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: signUserUp,
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 50, 30, 80),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 70)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? '),
                    GestureDetector(
                      onTap: widget.onTop,
                      child: const Text(
                        ' Login',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 35)),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
