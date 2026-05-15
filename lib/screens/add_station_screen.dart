import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/app_colors.dart';

class AddStationScreen extends StatefulWidget {

  const AddStationScreen({super.key});

  @override
  State<AddStationScreen> createState() =>
      _AddStationScreenState();
}

class _AddStationScreenState
    extends State<AddStationScreen> {

  final TextEditingController
  hostNameController =
  TextEditingController();

  final TextEditingController
  socketController =
  TextEditingController();

  final TextEditingController
  priceController =
  TextEditingController();

  double latitude = 0;
  double longitude = 0;

  bool loading = false;

  Future<void> getLocation() async {

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

      latitude =
          position.latitude;

      longitude =
          position.longitude;
    });
  }

  Future<void> saveStation() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (latitude == 0) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text(
            "Please add location",
          ),
        ),
      );

      return;
    }

    setState(() {
      loading = true;
    });

    await FirebaseFirestore.instance
        .collection('charging_points')
        .add({

      'hostId': user!.uid,

      'hostName':
      hostNameController.text.trim(),

      'socket':
      socketController.text.trim(),

      'price':
      priceController.text.trim(),

      'available': true,

      'latitude': latitude,

      'longitude': longitude,
    });

    setState(() {
      loading = false;
    });

    Navigator.pop(context);
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

          "Add Charging Point",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(

              controller:
              hostNameController,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration:
              inputDecoration(
                "Station Name",
              ),
            ),

            const SizedBox(height: 20),

            TextField(

              controller:
              socketController,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration:
              inputDecoration(
                "Socket Type",
              ),
            ),

            const SizedBox(height: 20),

            TextField(

              controller:
              priceController,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration:
              inputDecoration(
                "Price",
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(

              width: double.infinity,

              child:
              ElevatedButton.icon(

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.cyan,
                  padding:
                  const EdgeInsets.all(
                      15),
                ),

                onPressed:
                getLocation,

                icon: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),

                label: Text(

                  latitude == 0
                      ? "Use Current Location"
                      : "Location Added",

                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

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

                onPressed:
                loading
                    ? null
                    : saveStation,

                child: loading
                    ? const CircularProgressIndicator(
                  color:
                  Colors.white,
                )
                    : const Text(

                  "Save Charging Point",

                  style: TextStyle(
                    color:
                    Colors.white,
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

  InputDecoration inputDecoration(
      String hint) {

    return InputDecoration(

      hintText: hint,

      hintStyle: const TextStyle(
        color: Colors.white54,
      ),

      filled: true,

      fillColor: AppColors.cardColor,

      border: OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(15),
      ),
    );
  }
}