import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/app_colors.dart';

class EditStationScreen
    extends StatefulWidget {

  final String docId;

  final Map<String, dynamic>
  stationData;

  const EditStationScreen({

    super.key,

    required this.docId,

    required this.stationData,
  });

  @override
  State<EditStationScreen>
  createState() =>
      _EditStationScreenState();
}

class _EditStationScreenState
    extends State<EditStationScreen> {

  late TextEditingController
  hostNameController;

  late TextEditingController
  socketController;

  late TextEditingController
  priceController;

  bool available = true;

  double latitude = 0;
  double longitude = 0;

  bool loading = false;

  @override
  void initState() {

    super.initState();

    hostNameController =
        TextEditingController(
          text:
          widget.stationData[
          'hostName'] ??
              '',
        );

    socketController =
        TextEditingController(
          text:
          widget.stationData[
          'socket'] ??
              '',
        );

    priceController =
        TextEditingController(
          text:
          widget.stationData[
          'price'] ??
              '',
        );

    available =
        widget.stationData[
        'available'] ??
            true;

    latitude =
        (widget.stationData[
        'latitude'] ??
            0)
            .toDouble();

    longitude =
        (widget.stationData[
        'longitude'] ??
            0)
            .toDouble();
  }

  Future<void> updateLocation() async {

    LocationPermission permission =
    await Geolocator
        .checkPermission();

    if (permission ==
        LocationPermission.denied) {

      permission =
      await Geolocator
          .requestPermission();
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

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content:
        Text("Location Updated"),
      ),
    );
  }

  Future<void> updateStation()
  async {

    setState(() {
      loading = true;
    });

    await FirebaseFirestore
        .instance
        .collection(
        'charging_points')
        .doc(widget.docId)
        .update({

      'hostName':
      hostNameController.text
          .trim(),

      'socket':
      socketController.text
          .trim(),

      'price':
      priceController.text
          .trim(),

      'available':
      available,

      'latitude':
      latitude,

      'longitude':
      longitude,
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

          "Edit Charging Point",

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

            SwitchListTile(

              value: available,

              activeColor:
              Colors.green,

              title: const Text(

                "Available",

                style: TextStyle(
                  color: Colors.white,
                ),
              ),

              onChanged: (value) {

                setState(() {

                  available =
                      value;
                });
              },
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
                updateLocation,

                icon: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),

                label: Text(

                  latitude == 0
                      ? "Add Current Location"
                      : "Update Current Location",

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
                    : updateStation,

                child: loading
                    ? const CircularProgressIndicator(
                  color:
                  Colors.white,
                )
                    : const Text(

                  "Save Changes",

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