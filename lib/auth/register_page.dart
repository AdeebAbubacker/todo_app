
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_clud/auth/login.dart';
import 'package:todo_clud/presentation/homepage/mytodo.dart';



class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordconfirmController = TextEditingController();

  _handleLogin() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter email id")));
    }
    if (_passwordController.text.isEmpty ||
        _passwordconfirmController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter password")));
    }
    if (_passwordController.text != _passwordconfirmController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("password missmatch")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const CircleAvatar(
                backgroundImage: AssetImage("assets/avatar1.jpg"),
                radius: 70,
              ),
              const SizedBox(
                height: 50,
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Enter e-mail"),
              ),
              const SizedBox(
                height: 7,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Enter password"),
              ),
              const SizedBox(
                height: 7,
              ),
              TextField(
                controller: _passwordconfirmController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "confirm password"),
              ),
              const SizedBox(
                height: 7,
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      UserCredential _userregcredntial =
                          await _auth.createUserWithEmailAndPassword(
                              email: _emailController.text.toString(),
                              password: _passwordController.text.toString());
                      if (_userregcredntial.user != null) {
                        // Registration successful, navigate to the home page or show success message
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  TodoPagePage(),
                          ),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'wrong-pasword') {
                        print("wrong password");
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User already excist')));
                    }
                    _handleLogin();
                  },
                  child: const Text("Register")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Do you already have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return LoginPage();
                          },
                        ));
                      },
                      child: Text("login"))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
