import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/app_colors.dart';

class MyBookingsScreen extends StatefulWidget {

  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() =>
      _MyBookingsScreenState();
}

class _MyBookingsScreenState
    extends State<MyBookingsScreen> {

  Future<void> cancelBooking(
      String bookingId) async {

    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingId)
        .update({

      'status': 'cancelled',
    });
  }

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

          "My Bookings",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body:
      StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore
            .instance
            .collection('bookings')
            .where(
          'userId',
          isEqualTo:
          user!.uid,
        )

            .snapshots(),

        builder:
            (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          final bookings =
              snapshot.data!.docs;

          bookings.sort((a, b) {

            final aData =
            a.data()
            as Map<String,
                dynamic>;

            final bData =
            b.data()
            as Map<String,
                dynamic>;

            final aTime =
                (aData['timestamp']
                as Timestamp?)
                    ?.millisecondsSinceEpoch ??
                    0;

            final bTime =
                (bData['timestamp']
                as Timestamp?)
                    ?.millisecondsSinceEpoch ??
                    0;

            return bTime.compareTo(aTime);
          });

          if (bookings.isEmpty) {

            return const Center(

              child: Text(

                "No Booking History",

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
            const EdgeInsets.all(
                16),

            itemCount:
            bookings.length,

            itemBuilder:
                (context, index) {

              final booking =
              bookings[index];

              final data =
                  booking.data()
                  as Map<String,
                      dynamic>? ??
                      {};

              final cancelled =
                  (data['status'] ??
                      '') ==
                      'cancelled';

              Timestamp? timestamp =
              data['timestamp'];

              String bookingTime =
                  '';

              if (timestamp !=
                  null) {

                final date =
                timestamp
                    .toDate();

                bookingTime =
                "${date.day}/${date.month}/${date.year}  ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
              }

              return Container(

                margin:
                const EdgeInsets.only(
                  bottom: 15,
                ),

                padding:
                const EdgeInsets.all(
                    16),

                decoration:
                BoxDecoration(

                  color:
                  AppColors.cardColor,

                  borderRadius:
                  BorderRadius.circular(
                      20),
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

                              fontSize: 20,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),

                        Container(

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal:
                            12,
                            vertical: 6,
                          ),

                          decoration:
                          BoxDecoration(

                            color:
                            cancelled
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
                        height: 15),

                    Row(

                      children: [

                        const Icon(

                          Icons.calendar_month,

                          color:
                          Colors.white70,
                        ),

                        const SizedBox(
                            width: 8),

                        Expanded(

                          child: Text(

                            data['date'] ??
                                'No Date',

                            style:
                            const TextStyle(

                              color:
                              Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 10),

                    Row(

                      children: [

                        const Icon(

                          Icons.access_time,

                          color:
                          Colors.white70,
                        ),

                        const SizedBox(
                            width: 8),

                        Text(

                          data['timeSlot'] ??
                              'No Time',

                          style:
                          const TextStyle(

                            color:
                            Colors.white70,
                          ),
                        ),
                      ],
                    ),

                    if (bookingTime
                        .isNotEmpty)

                      Padding(

                        padding:
                        const EdgeInsets.only(
                          top: 12,
                        ),

                        child: Row(

                          children: [

                            const Icon(

                              Icons.history,

                              color:
                              Colors.white54,

                              size: 18,
                            ),

                            const SizedBox(
                                width: 8),

                            Text(

                              bookingTime,

                              style:
                              const TextStyle(

                                color:
                                Colors.white54,

                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(
                        height: 18),

                    if (!cancelled)

                      SizedBox(

                        width:
                        double.infinity,

                        child:
                        ElevatedButton(

                          style:
                          ElevatedButton.styleFrom(

                            backgroundColor:
                            Colors.red,

                            padding:
                            const EdgeInsets.all(
                                14),

                            shape:
                            RoundedRectangleBorder(

                              borderRadius:
                              BorderRadius.circular(
                                  15),
                            ),
                          ),

                          onPressed: () {

                            cancelBooking(
                                booking.id);
                          },

                          child:
                          const Text(

                            "Cancel Booking",

                            style:
                            TextStyle(

                              color:
                              Colors.white,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
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
}