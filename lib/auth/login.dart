import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_clud/auth/register_page.dart';
import 'package:todo_clud/presentation/homepage/mytodo.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  handleLogin() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter Username")));
      return;
    }
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter Password")));
      return;
    }
    if (_passwordController.text.length < 7) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("password length must be 7 character")));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(19.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                    backgroundImage: AssetImage("assets/1.jpeg"), radius: 70),
                const SizedBox(
                  height: 160,
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Enter Username"),
                ),
                const SizedBox(
                  height: 6,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Enter password"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              UserCredential userdential =
                                  await _auth.signInWithEmailAndPassword(
                                      email: _emailController.text.toString(),
                                      password:
                                          _passwordController.text.toString());
                              if (userdential.user != null) {
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TodoPagePage(),
                                    ));
                              }
                              handleLogin;
                            },
                            child: const Text("Login"))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("If you don't have an account"),
                    TextButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            )),
                        child: const Text("Signup"))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
