import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../utils/app_colors.dart';

class BookingScreen extends StatefulWidget {

  final String stationId;
  final String hostId;
  final String stationName;

  const BookingScreen({

    super.key,

    required this.stationId,
    required this.hostId,
    required this.stationName,
  });

  @override
  State<BookingScreen> createState() =>
      _BookingScreenState();
}

class _BookingScreenState
    extends State<BookingScreen> {

  DateTime selectedDate =
  DateTime.now();

  String selectedTime =
      "09:00 AM - 10:00 AM";

  bool loading = false;

  final List<String> timeSlots = [

    "09:00 AM - 10:00 AM",
    "10:00 AM - 11:00 AM",
    "11:00 AM - 12:00 PM",
    "12:00 PM - 01:00 PM",
    "01:00 PM - 02:00 PM",
    "02:00 PM - 03:00 PM",
    "03:00 PM - 04:00 PM",
    "04:00 PM - 05:00 PM",
    "05:00 PM - 06:00 PM",
  ];

  Future<void> selectDate()
  async {

    final pickedDate =
    await showDatePicker(

      context: context,

      initialDate:
      selectedDate,

      firstDate:
      DateTime.now(),

      lastDate:
      DateTime.now().add(
        const Duration(
            days: 30),
      ),
    );

    if (pickedDate != null) {

      setState(() {

        selectedDate =
            pickedDate;
      });
    }
  }

  Future<void> bookSlot()
  async {

    final user =
        FirebaseAuth
            .instance
            .currentUser;

    setState(() {
      loading = true;
    });

    String formattedDate =
    DateFormat(
        'dd-MM-yyyy')
        .format(
        selectedDate);

    final existingBooking =
    await FirebaseFirestore
        .instance
        .collection(
        'bookings')
        .where(
      'stationId',
      isEqualTo:
      widget.stationId,
    )
        .where(
      'date',
      isEqualTo:
      formattedDate,
    )
        .where(
      'timeSlot',
      isEqualTo:
      selectedTime,
    )
        .where(
      'status',
      isEqualTo:
      'active',
    )
        .get();

    if (existingBooking
        .docs
        .isNotEmpty) {

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(
          context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "This slot is already booked",
          ),
        ),
      );

      return;
    }

    await FirebaseFirestore
        .instance
        .collection(
        'bookings')
        .add({

      'userId':
      user!.uid,

      'stationId':
      widget.stationId,

      'hostId':
      widget.hostId,

      'stationName':
      widget.stationName,

      'date':
      formattedDate,

      'timeSlot':
      selectedTime,

      'status':
      'active',

      'timestamp':
      Timestamp.now(),
    });

    setState(() {
      loading = false;
    });

    ScaffoldMessenger.of(
        context)
        .showSnackBar(

      const SnackBar(
        content: Text(
          "Booking Successful",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      backgroundColor:
      AppColors.background,

      appBar: AppBar(

        backgroundColor:
        AppColors.primaryBlue,

        title: Text(

          widget.stationName,

          style:
          const TextStyle(
            color:
            Colors.white,
          ),
        ),
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(
            20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment
              .start,

          children: [

            const Text(

              "Select Booking Date",

              style: TextStyle(

                color:
                Colors.white,

                fontSize: 18,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 15),

            SizedBox(

              width:
              double.infinity,

              child:
              ElevatedButton.icon(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  AppColors.cardColor,

                  padding:
                  const EdgeInsets.all(
                      15),
                ),

                onPressed:
                selectDate,

                icon: const Icon(

                  Icons.calendar_month,

                  color:
                  Colors.white,
                ),

                label: Text(

                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",

                  style:
                  const TextStyle(
                    color:
                    Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(
                height: 25),

            const Text(

              "Select Time Slot",

              style: TextStyle(

                color:
                Colors.white,

                fontSize: 18,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 15),

            Container(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 15,
              ),

              decoration:
              BoxDecoration(

                color:
                AppColors.cardColor,

                borderRadius:
                BorderRadius.circular(
                    15),
              ),

              child:
              DropdownButton<String>(

                value:
                selectedTime,

                dropdownColor:
                AppColors.cardColor,

                isExpanded:
                true,

                underline:
                const SizedBox(),

                style:
                const TextStyle(
                  color:
                  Colors.white,
                ),

                items:
                timeSlots.map(
                        (slot) {

                      return DropdownMenuItem(

                        value:
                        slot,

                        child:
                        Text(slot),
                      );
                    }).toList(),

                onChanged:
                    (value) {

                  setState(() {

                    selectedTime =
                    value!;
                  });
                },
              ),
            ),

            const Spacer(),

            SizedBox(

              width:
              double.infinity,

              child:
              ElevatedButton(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  AppColors.primaryBlue,

                  padding:
                  const EdgeInsets.all(
                      15),
                ),

                onPressed:
                loading
                    ? null
                    : bookSlot,

                child:
                loading

                    ? const CircularProgressIndicator(
                  color:
                  Colors.white,
                )

                    : const Text(

                  "Confirm Booking",

                  style:
                  TextStyle(

                    color:
                    Colors.white,

                    fontSize:
                    18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}