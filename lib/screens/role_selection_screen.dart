import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';
import 'host_dashboard_screen.dart';
import 'main_navigation_screen.dart';
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            const Text(
              "Choose Your Role",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 50),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
    const MainNavigationScreen(),
                  ),
                );
              },

              child: roleCard(
                icon: Icons.electric_bike,
                title: "EV User",
                subtitle: "Find nearby charging points",
              ),
            ),

            const SizedBox(height: 30),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const HostDashboardScreen(),
                  ),
                );
              },

              child: roleCard(
                icon: Icons.store,
                title: "Charging Host",
                subtitle: "Offer charging to EV travelers",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget roleCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryBlue,
        ),
      ),

      child: Row(
        children: [

          Icon(
            icon,
            color: AppColors.neonGreen,
            size: 40,
          ),

          const SizedBox(width: 20),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}