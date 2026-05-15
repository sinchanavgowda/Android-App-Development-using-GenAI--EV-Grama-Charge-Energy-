import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'calculator_screen.dart';
import 'map_screen.dart';
import 'my_bookings_screen.dart';

import '../utils/app_colors.dart';

class MainNavigationScreen
    extends StatefulWidget {

  const MainNavigationScreen({
    super.key,
  });

  @override
  State<MainNavigationScreen>
  createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {

  int currentIndex = 0;

  final List<Widget> screens = [

    const HomeScreen(),

    const CalculatorScreen(),

    const MapScreen(),

    const MyBookingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: screens[currentIndex],

      bottomNavigationBar:
      Container(

        decoration: BoxDecoration(

          color: AppColors.cardColor,

          boxShadow: [

            BoxShadow(
              color: Colors.black
                  .withOpacity(0.3),

              blurRadius: 10,
            ),
          ],
        ),

        child: BottomNavigationBar(

          currentIndex:
          currentIndex,

          onTap: (index) {

            setState(() {

              currentIndex =
                  index;
            });
          },

          backgroundColor:
          AppColors.cardColor,

          selectedItemColor:
          AppColors.primaryBlue,

          unselectedItemColor:
          Colors.white60,

          type:
          BottomNavigationBarType.fixed,

          elevation: 0,

          items: const [

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(
                  Icons.bolt),
              label: 'Calculator',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),

            BottomNavigationBarItem(
              icon: Icon(
                  Icons.history),
              label: 'History',
            ),
          ],
        ),
      ),
    );
  }
}