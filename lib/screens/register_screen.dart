import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';
import '../utils/app_colors.dart';
import '../services/auth_service.dart';

import 'home_screen.dart';
import 'host_dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  String selectedRole = "user";

  void register() async {

    String result = await AuthService().registerUser(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      role: selectedRole,
    );

    if (result == "success") {

      if (selectedRole == "host") {

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,

        title: const Text(
          "Create Account",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            children: [

              TextField(
                controller: nameController,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: const InputDecoration(
                  hintText: "Name",

                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: emailController,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: const InputDecoration(
                  hintText: "Email",

                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: const InputDecoration(
                  hintText: "Password",

                  hintStyle: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),

                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius:
                  BorderRadius.circular(15),
                ),

                child: DropdownButton<String>(
                  value: selectedRole,

                  dropdownColor:
                  AppColors.cardColor,

                  isExpanded: true,

                  underline: const SizedBox(),

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),

                  items: const [

                    DropdownMenuItem(
                      value: "user",

                      child: Text(
                        "Register as EV User",
                      ),
                    ),

                    DropdownMenuItem(
                      value: "host",

                      child: Text(
                        "Register as Charging Host",
                      ),
                    ),
                  ],

                  onChanged: (value) {

                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.primaryBlue,

                    padding:
                    const EdgeInsets.all(15),
                  ),

                  onPressed: register,

                  child: const Text(
                    "Create Account",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}