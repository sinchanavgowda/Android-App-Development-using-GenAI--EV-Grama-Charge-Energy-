import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_colors.dart';
import '../services/auth_service.dart';

import 'host_dashboard_screen.dart';
import 'main_navigation_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController
  emailController =
  TextEditingController();

  final TextEditingController
  passwordController =
  TextEditingController();

  Future<void> login() async {

    String result =
    await AuthService().loginUser(

      email:
      emailController.text.trim(),

      password:
      passwordController.text.trim(),
    );

    if (result == "success") {

      final user =
          FirebaseAuth
              .instance
              .currentUser;

      final userData =
      await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user!.uid)
          .get();

      final role =
      userData['role'];

      if (!mounted) return;

      if (role == "host") {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(
            builder: (_) =>
            const HostDashboardScreen(),
          ),
        );

      } else {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(
            builder: (_) =>
            const MainNavigationScreen(),
          ),
        );
      }

    } else {

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(result),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      AppColors.background,

      appBar: AppBar(

        backgroundColor:
        AppColors.primaryBlue,

        title: const Text(
          "Login",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            TextField(

              controller:
              emailController,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration:
              InputDecoration(

                hintText: "Email",

                hintStyle:
                const TextStyle(
                  color:
                  Colors.white54,
                ),

                filled: true,

                fillColor:
                AppColors.cardColor,

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                      15),
                ),
              ),
            ),

            const SizedBox(
                height: 20),

            TextField(

              controller:
              passwordController,

              obscureText: true,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration:
              InputDecoration(

                hintText: "Password",

                hintStyle:
                const TextStyle(
                  color:
                  Colors.white54,
                ),

                filled: true,

                fillColor:
                AppColors.cardColor,

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                      15),
                ),
              ),
            ),

            const SizedBox(
                height: 30),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  AppColors.primaryBlue,

                  padding:
                  const EdgeInsets.all(
                      15),
                ),

                onPressed: login,

                child: const Text(

                  "Login",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(
                height: 20),

            TextButton(

              onPressed: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                    const RegisterScreen(),
                  ),
                );
              },

              child: const Text(

                "Create New Account",

                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}