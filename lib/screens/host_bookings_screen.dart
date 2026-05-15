import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_colors.dart';

class HostBookingsScreen
    extends StatefulWidget {

  const HostBookingsScreen({
    super.key,
  });

  @override
  State<HostBookingsScreen>
  createState() =>
      _HostBookingsScreenState();
}

class _HostBookingsScreenState
    extends State<HostBookingsScreen> {

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(

      backgroundColor:
      AppColors.background,

      appBar: AppBar(

        backgroundColor:
        AppColors.primaryBlue,

        title: const Text(

          "Host Bookings",

          style: TextStyle(
            color: Colors.white,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body:
      StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore
            .instance
            .collection('bookings')
            .where(
          'hostId',
          isEqualTo: user!.uid,
        )
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          final bookings =
              snapshot.data!.docs;

          if (bookings.isEmpty) {

            return const Center(

              child: Text(

                "No Bookings Yet",

                style: TextStyle(
                  color:
                  Colors.white70,
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.builder(

            padding:
            const EdgeInsets.all(16),

            itemCount:
            bookings.length,

            itemBuilder:
                (context, index) {

              final data =
                  bookings[index]
                      .data()
                  as Map<String,
                      dynamic>? ??
                      {};

              final cancelled =
                  (data['status'] ??
                      '') ==
                      'cancelled';

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

                        Expanded(

                          child: Text(

                            data['stationName'] ??
                                'Unknown Station',

                            style:
                            const TextStyle(

                              color:
                              Colors.white,

                              fontSize: 22,

                              fontWeight:
                              FontWeight.bold,
                            ),
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

                            color: cancelled
                                ? Colors.red
                                : Colors.green,

                            borderRadius:
                            BorderRadius.circular(
                                20),
                          ),

                          child: Text(

                            cancelled
                                ? "Cancelled"
                                : "Active",

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
                        height: 18),

                    bookingRow(
                      Icons.person,
                      data['userName'] ??
                          'Unknown User',
                    ),

                    const SizedBox(
                        height: 12),

                    bookingRow(
                      Icons.email,
                      data['userEmail'] ??
                          'No Email',
                    ),

                    const SizedBox(
                        height: 12),

                    bookingRow(
                      Icons.calendar_month,
                      data['date'] ??
                          'No Date',
                    ),

                    const SizedBox(
                        height: 12),

                    bookingRow(
                      Icons.access_time,
                      data['timeSlot'] ??
                          'No Slot',
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget bookingRow(
      IconData icon,
      String text,
      ) {

    return Row(

      children: [

        Icon(
          icon,
          color: Colors.white70,
          size: 20,
        ),

        const SizedBox(width: 10),

        Expanded(

          child: Text(

            text,

            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}