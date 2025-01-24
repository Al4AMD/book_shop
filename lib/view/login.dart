import 'dart:developer';

import 'package:flutter/material.dart';

import '../apis/user_Api/userApis.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginPage({required this.onLogin});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? usernameError;
  String? passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.grey.shade300),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  'http://192.168.1.36:3000/api/v1/ui/bookShop.png',
                ),
                Text(
                  "Welcome!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Please login to continue",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                if (usernameError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      usernameError!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                ),
                if (passwordError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      passwordError!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      if (usernameController.text.isEmpty) {
                        usernameError = "Username is required";
                      }
                      if (passwordController.text.isEmpty) {
                        passwordError = "Password is required";
                      }
                    });

                    log("username: ${usernameController.value.text.trim()}");
                    log("username: ${passwordController.value.text.trim()}");
                    UserApi api = UserApi();
                    final res = await api.login(
                        username: usernameController.value.text.trim(),
                        password: passwordController.value.text.trim());
                    _showDialog(
                        context: context,
                        message: res,
                        res: res == "Login successful" ? true : false);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Register",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(
      {required BuildContext context,
      required String message,
      required bool res}) {
    showDialog(
      context: context,
      barrierDismissible: true, // Prevents closing on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: res ? Colors.green : Colors.red),
                  child: Center(
                    child: Icon(
                      res ? Icons.verified : Icons.error,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(message,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
          ),
        );
      },
    );
    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    });
  }
}
