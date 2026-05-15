import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() =>
      _MapScreenState();
}

class _MapScreenState
    extends State<MapScreen> {

  GoogleMapController?
  mapController;

  double userLat = 0;
  double userLng = 0;

  Set<Marker> markers = {};

  @override
  void initState() {

    super.initState();

    initializeMap();
  }

  Future<void> initializeMap()
  async {

    await getUserLocation();

    await loadChargingStations();
  }

  Future<void> getUserLocation()
  async {

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

    userLat =
        position.latitude;

    userLng =
        position.longitude;

    markers.add(

      Marker(

        markerId:
        const MarkerId(
            'user'),

        position: LatLng(
          userLat,
          userLng,
        ),

        infoWindow:
        const InfoWindow(
          title:
          'Your Location',
        ),

        icon: BitmapDescriptor
            .defaultMarkerWithHue(
          BitmapDescriptor
              .hueAzure,
        ),
      ),
    );
  }

  Future<void>
  loadChargingStations()
  async {

    final snapshot =
    await FirebaseFirestore
        .instance
        .collection(
        'charging_points')
        .get();

    for (var doc
    in snapshot.docs) {

      final data = doc.data();

      double lat =
      (data['latitude'] ??
          0)
          .toDouble();

      double lng =
      (data['longitude'] ??
          0)
          .toDouble();

      if (lat == 0 ||
          lng == 0) continue;

      double distance =
          Geolocator.distanceBetween(
            userLat,
            userLng,
            lat,
            lng,
          ) /
              1000;

      if (distance > 25) continue;
      markers.add(

        Marker(

          markerId:
          MarkerId(doc.id),

          position:
          LatLng(lat, lng),

          infoWindow:
          InfoWindow(

            title:
            data['hostName']
                ??
                'Charging Point',

            snippet:
            data['available'] ==
                true
                ? 'Available'
                : 'Busy',
          ),

          icon: BitmapDescriptor
              .defaultMarkerWithHue(

            data['available'] ==
                true
                ? BitmapDescriptor
                .hueGreen
                : BitmapDescriptor
                .hueRed,
          ),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: userLat == 0

          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : Stack(

        children: [

          GoogleMap(

            initialCameraPosition:
            CameraPosition(

              target: LatLng(
                userLat,
                userLng,
              ),

              zoom: 19,
            ),

            myLocationEnabled:
            true,

            myLocationButtonEnabled:
            true,

            zoomControlsEnabled:
            false,

            markers: markers,

            onMapCreated:
                (controller) {

              mapController =
                  controller;
            },
          ),

          Positioned(

            top: 50,
            left: 15,
            right: 15,

            child: Container(

              padding:
              const EdgeInsets.all(
                  15),

              decoration:
              BoxDecoration(

                color:
                Colors.black87,

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

                    "Nearby Charging Stations",

                    style: TextStyle(
                      color:
                      Colors.white,

                      fontSize: 18,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height: 10),

                  FutureBuilder<QuerySnapshot>(

                    future:
                    FirebaseFirestore
                        .instance
                        .collection(
                        'charging_points')
                        .get(),

                    builder:
                        (context,
                        snapshot) {

                      if (!snapshot
                          .hasData) {

                        return const SizedBox();
                      }

                      final docs =
                          snapshot
                              .data!
                              .docs;

                      return Column(

                        children:
                        docs.map((doc) {

                          final data =
                          doc.data()
                          as Map<String,
                              dynamic>;

                          return Padding(

                            padding:
                            const EdgeInsets.only(
                              bottom:
                              8,
                            ),

                            child: Row(

                              children: [

                                Icon(

                                  Icons
                                      .location_on,

                                  color:
                                  data['available'] ==
                                      true
                                      ? Colors.green
                                      : Colors.red,
                                ),

                                const SizedBox(
                                    width:
                                    8),

                                Expanded(

                                  child:
                                  Text(

                                    data['hostName'] ??
                                        'Station',

                                    style:
                                    const TextStyle(
                                      color:
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}