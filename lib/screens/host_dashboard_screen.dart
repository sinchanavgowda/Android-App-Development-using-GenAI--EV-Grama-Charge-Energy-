import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_colors.dart';

import 'login_screen.dart';
import 'add_station_screen.dart';
import 'edit_station_screen.dart';
import 'host_bookings_screen.dart';

class HostDashboardScreen extends StatefulWidget {
  const HostDashboardScreen({super.key});

  @override
  State<HostDashboardScreen> createState() =>
      _HostDashboardScreenState();
}

class _HostDashboardScreenState
    extends State<HostDashboardScreen> {

  final User? user =
      FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor:
        AppColors.primaryBlue,

        automaticallyImplyLeading: false,

        title: const Text(
          "Host Dashboard",
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        actions: [

          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),

            onPressed: () async {

              await FirebaseAuth.instance
                  .signOut();

              Navigator.pushAndRemoveUntil(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                  const LoginScreen(),
                ),

                    (route) => false,
              );
            },
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('charging_points')
            .where(
          'hostId',
          isEqualTo: user!.uid,
        )
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {

            return Center(
              child: Padding(
                padding:
                const EdgeInsets.all(20),

                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    const Icon(
                      Icons.ev_station,
                      size: 100,
                      color: Colors.cyan,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "No Charging Point Found",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Create your first charging point to start earning.",

                      textAlign:
                      TextAlign.center,

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton.icon(
                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          AppColors.primaryBlue,

                          padding:
                          const EdgeInsets.all(15),
                        ),

                        onPressed: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const AddStationScreen(),
                            ),
                          );
                        },

                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),

                        label: const Text(
                          "Create Charging Point",

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
            );
          }

          final station =
              snapshot.data!.docs.first;

          final data =
          station.data()
          as Map<String, dynamic>;

          bool available =
              data['available'] ?? false;

          return SingleChildScrollView(
            padding:
            const EdgeInsets.all(20),

            child: Container(
              padding:
              const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: AppColors.cardColor,

                borderRadius:
                BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    data['hostName'] ?? '',

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Socket: ${data['socket']}",

                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Price: ${data['price']}",

                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Location: ${data['distance']}",

                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      Text(
                        available
                            ? "Available"
                            : "Busy",

                        style: TextStyle(
                          color: available
                              ? Colors.greenAccent
                              : Colors.redAccent,

                          fontSize: 20,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      Switch(
                        value: available,

                        activeColor:
                        AppColors.neonGreen,

                        onChanged:
                            (value) async {

                          await FirebaseFirestore
                              .instance
                              .collection(
                              'charging_points')
                              .doc(station.id)
                              .update({
                            'available':
                            value,
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        AppColors.primaryBlue,

                        padding:
                        const EdgeInsets.all(15),
                      ),

                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditStationScreen(
                                  docId:
                                  station.id,

                                  stationData:
                                  data,
                                ),
                          ),
                        );
                      },

                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),

                      label: const Text(
                        "Edit Charging Point",

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        AppColors.neonGreen,

                        padding:
                        const EdgeInsets.all(15),
                      ),

                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const HostBookingsScreen(),
                          ),
                        );
                      },

                      icon: const Icon(
                        Icons.list_alt,
                        color: Colors.black,
                      ),

                      label: const Text(
                        "View All Bookings",

                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}