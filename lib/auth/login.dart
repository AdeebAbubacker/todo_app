// import 'dart:html';

// import 'package:firebase_demo/pages/register_page.dart';
// import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_clud/presentation/homepage/mytodo.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _emailController = TextEditingController();

  var _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  handleLogin() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter Username")));
      return;
    }
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter Password")));
      return;
    }
    if (_passwordController.text.length < 7) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("password length must be 7 character")));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(19.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  backgroundImage: AssetImage("assets/1.jpeg"), radius: 70),
              SizedBox(
                height: 160,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Enter Username"),
              ),
              SizedBox(
                height: 6,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Enter password"),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            UserCredential _userdential =
                                await _auth.signInWithEmailAndPassword(
                                    email: _emailController.text.toString(),
                                    password:
                                        _passwordController.text.toString());
                            if (_userdential.user != null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TodoPagePage(),
                                  ));
                            }
                            handleLogin;
                          },
                          child: Text("Login"))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("If you don't have an account"),
                  TextButton(
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          )),
                      child: Text("Signup"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
