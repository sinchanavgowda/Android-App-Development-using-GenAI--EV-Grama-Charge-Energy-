import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';

import '../utils/app_colors.dart';
import 'booking_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  double userLat = 0;
  double userLng = 0;

  @override
  void initState() {

    super.initState();

    getUserLocation();
  }

  Future<void> getUserLocation() async {

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission ==
        LocationPermission.denied) {

      permission =
      await Geolocator.requestPermission();
    }

    Position position =
    await Geolocator
        .getCurrentPosition(
      desiredAccuracy:
      LocationAccuracy.high,
    );

    setState(() {

      userLat =
          position.latitude;

      userLng =
          position.longitude;
    });
  }

  double calculateDistance(
      double lat,
      double lng,
      ) {

    return Geolocator.distanceBetween(
      userLat,
      userLng,
      lat,
      lng,
    ) /
        1000;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      AppColors.background,

      appBar: AppBar(

        backgroundColor:
        AppColors.background,

        automaticallyImplyLeading:
        false,

        title: const Text(

          "GramaCharge",

          style: TextStyle(
            color: Colors.white,
            fontWeight:
            FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(

            onPressed: () async {

              await FirebaseAuth
                  .instance
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

            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body:
      StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore
            .instance
            .collection(
            'charging_points')
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          final docs =
              snapshot.data!.docs;

          int totalStations =
              docs.length;

          int availableStations =
              docs.where((doc) {

                final data =
                doc.data()
                as Map<String,
                    dynamic>;

                return data['available']
                    ==
                    true;
              }).length;

          int busyStations =
              totalStations -
                  availableStations;

          String closestStation =
              "No Stations";

          double nearestDistance =
          999999;

          for (var doc in docs) {

            final data =
            doc.data()
            as Map<String,
                dynamic>;

            double lat =
            (data['latitude']
                ?? 0)
                .toDouble();

            double lng =
            (data['longitude']
                ?? 0)
                .toDouble();

            if (lat == 0 ||
                lng == 0) continue;

            double distance =
            calculateDistance(
              lat,
              lng,
            );

            if (distance <
                nearestDistance) {

              nearestDistance =
                  distance;

              closestStation =
                  data['hostName'] ??
                      'Unknown';
            }
          }

          return ListView(

            padding:
            const EdgeInsets.all(
                16),

            children: [

              Container(

                height: 220,

                alignment: Alignment.center,

                child: Lottie.asset(

                  'assets/animations/battery.json',

                  repeat: true,

                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(
                  height: 20),

              Container(

                width:
                double.infinity,

                padding:
                const EdgeInsets.all(
                    24),

                decoration:
                BoxDecoration(

                  gradient:
                  const LinearGradient(

                    colors: [
                      Color(0xff00c6ff),
                      Color(0xff0072ff),
                    ],
                  ),

                  borderRadius:
                  BorderRadius.circular(
                      30),
                ),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    const Text(

                      "EV Insights ⚡",

                      style: TextStyle(
                        color:
                        Colors.white,

                        fontSize: 30,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    const Text(

                      "Live charging statistics around you",

                      style: TextStyle(
                        color:
                        Colors.white70,
                      ),
                    ),

                    const SizedBox(
                        height: 25),

                    GridView.count(

                      shrinkWrap: true,

                      physics:
                      const NeverScrollableScrollPhysics(),

                      crossAxisCount:
                      2,

                      crossAxisSpacing:
                      15,

                      mainAxisSpacing:
                      15,

                      childAspectRatio:
                      1.6,

                      children: [

                        analyticsCard(
                          "Nearby",
                          totalStations
                              .toString(),
                          Icons.ev_station,
                          Colors.white,
                        ),

                        analyticsCard(
                          "Available",
                          availableStations
                              .toString(),
                          Icons.check_circle,
                          Colors.greenAccent,
                        ),

                        analyticsCard(
                          "Busy",
                          busyStations
                              .toString(),
                          Icons.error,
                          Colors.redAccent,
                        ),

                        analyticsCard(
                          "Closest",
                          nearestDistance ==
                              999999
                              ? "--"
                              : "${nearestDistance.toStringAsFixed(1)} km",

                          Icons.location_on,

                          Colors.orangeAccent,
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 20),

                    Container(

                      width:
                      double.infinity,

                      padding:
                      const EdgeInsets.all(
                          16),

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.white24,

                        borderRadius:
                        BorderRadius.circular(
                            20),
                      ),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          const Text(

                            "Nearest Station",

                            style: TextStyle(
                              color:
                              Colors.white70,
                            ),
                          ),

                          const SizedBox(
                              height: 6),

                          Text(

                            closestStation,

                            style:
                            const TextStyle(

                              color:
                              Colors.white,

                              fontSize: 20,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                  height: 30),

              const Text(

                "Nearby Charging Points",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height: 20),

              ...docs.map((doc) {

                final data =
                doc.data()
                as Map<String,
                    dynamic>;

                double hostLat =
                (data['latitude']
                    ?? 0)
                    .toDouble();

                double hostLng =
                (data['longitude']
                    ?? 0)
                    .toDouble();

                bool hasLocation =
                    hostLat != 0 &&
                        hostLng != 0;

                double distance =
                hasLocation
                    ? calculateDistance(
                  hostLat,
                  hostLng,
                )
                    : 0;

                return Container(

                  margin:
                  const EdgeInsets.only(
                    bottom: 18,
                  ),

                  padding:
                  const EdgeInsets.all(
                      18),

                  decoration:
                  BoxDecoration(

                    color:
                    AppColors.cardColor,

                    borderRadius:
                    BorderRadius.circular(
                        25),
                  ),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      Row(

                        mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,

                        children: [

                          Text(

                            data['hostName']
                                ??
                                'Unknown',

                            style:
                            const TextStyle(

                              color:
                              Colors.white,

                              fontSize: 22,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          Container(

                            padding:
                            const EdgeInsets.symmetric(
                              horizontal:
                              14,
                              vertical: 6,
                            ),

                            decoration:
                            BoxDecoration(

                              color:
                              data['available'] ==
                                  true
                                  ? Colors.green
                                  : Colors.red,

                              borderRadius:
                              BorderRadius.circular(
                                  20),
                            ),

                            child: Text(

                              data['available'] ==
                                  true
                                  ? "Available"
                                  : "Busy",

                              style:
                              const TextStyle(
                                color:
                                Colors.white,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 15),

                      Text(

                        hasLocation
                            ? "${distance.toStringAsFixed(1)} km away"
                            : "Location unavailable",

                        style:
                        const TextStyle(
                          color:
                          Colors.white70,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(
                          height: 10),

                      Text(

                        data['socket']
                            ??
                            'No Socket',

                        style:
                        const TextStyle(
                          color:
                          Colors.white,
                        ),
                      ),

                      const SizedBox(
                          height: 10),

                      Text(

                        data['price']
                            ??
                            '₹0',

                        style:
                        const TextStyle(

                          color:
                          Colors.greenAccent,

                          fontSize: 18,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 20),

                      Row(

                        children: [

                          Expanded(

                            child:
                            ElevatedButton(

                              style:
                              ElevatedButton.styleFrom(
                                backgroundColor:
                                data['available'] ==
                                    true
                                    ? AppColors.primaryBlue
                                    : Colors.grey,
                              ),

                              onPressed:
                              data['available'] ==
                                  true
                                  ? () {

                                Navigator.push(

                                  context,

                                  MaterialPageRoute(

                                    builder: (_) =>
                                        BookingScreen(

                                          stationId:
                                          doc.id,

                                          hostId:
                                          data['hostId'] ??
                                              '',

                                          stationName:
                                          data['hostName'] ??
                                              '',
                                        ),
                                  ),
                                );
                              }
                                  : null,

                              child: Text(

                                data['available'] ==
                                    true
                                    ? "Book Slot"
                                    : "Unavailable",

                                style:
                                const TextStyle(
                                  color:
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                              width: 12),

                          Expanded(

                            child:
                            OutlinedButton.icon(

                              style:
                              OutlinedButton.styleFrom(
                                side:
                                const BorderSide(
                                  color:
                                  Colors.cyan,
                                ),
                              ),

                              onPressed:
                              hasLocation
                                  ? () async {

                                final Uri uri =
                                Uri.parse(
                                  "https://www.google.com/maps/dir/?api=1&destination=$hostLat,$hostLng",
                                );

                                await launchUrl(

                                  uri,

                                  mode:
                                  LaunchMode.externalApplication,
                                );
                              }
                                  : null,

                              icon: const Icon(
                                Icons.navigation,
                                color:
                                Colors.cyan,
                              ),

                              label:
                              const Text(

                                "Navigate",

                                style: TextStyle(
                                  color:
                                  Colors.cyan,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget analyticsCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {

    return Container(

      padding:
      const EdgeInsets.all(
          14),

      decoration:
      BoxDecoration(

        color: Colors.white24,

        borderRadius:
        BorderRadius.circular(
            20),
      ),

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            color: color,
            size: 28,
          ),

          const SizedBox(
              height: 10),

          Text(

            value,

            style:
            const TextStyle(

              color:
              Colors.white,

              fontSize: 20,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(
              height: 4),

          Text(

            title,

            style:
            const TextStyle(
              color:
              Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}