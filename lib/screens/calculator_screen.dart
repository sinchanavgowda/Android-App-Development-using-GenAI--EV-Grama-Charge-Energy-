import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../utils/app_colors.dart';

class CalculatorScreen extends StatefulWidget {

  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() =>
      _CalculatorScreenState();
}

class _CalculatorScreenState
    extends State<CalculatorScreen> {

  final TextEditingController
  batteryController =
  TextEditingController();

  final TextEditingController
  timeController =
  TextEditingController();

  double estimatedKm = 0;

  void calculateRange() {

    double batterySize =
        double.tryParse(
          batteryController.text,
        ) ??
            0;

    double chargingTime =
        double.tryParse(
          timeController.text,
        ) ??
            0;

    estimatedKm =
        (batterySize *
            chargingTime) /
            10;

    setState(() {});
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      backgroundColor:
      AppColors.background,

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "EV Calculator",

          style: TextStyle(
            color: Colors.white,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: Container(

        decoration:
        const BoxDecoration(

          gradient:
          LinearGradient(

            begin:
            Alignment.topCenter,

            end:
            Alignment.bottomCenter,

            colors: [

              Color(0xff0f2027),
              Color(0xff203a43),
              Color(0xff2c5364),
            ],
          ),
        ),

        child: Padding(

          padding:
          const EdgeInsets.all(
              20),

          child:
          SingleChildScrollView(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [

                Container(

                  width:
                  double.infinity,

                  padding:
                  const EdgeInsets.all(
                      24),

                  decoration:
                  BoxDecoration(

                    borderRadius:
                    BorderRadius.circular(
                        30),

                    gradient:
                    const LinearGradient(

                      colors: [

                        Color(
                            0xff00c6ff),

                        Color(
                            0xff0072ff),
                      ],
                    ),
                  ),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      const Text(

                        "EV Range Calculator ⚡",

                        style:
                        TextStyle(

                          color:
                          Colors.white,

                          fontSize:
                          28,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 10),

                      const Text(

                        "Estimate how far your EV can travel based on charging details.",

                        style:
                        TextStyle(

                          color:
                          Colors.white70,

                          fontSize:
                          15,
                        ),
                      ),

                      const SizedBox(
                          height: 20),

                      SizedBox(

                        height: 170,

                        child:
                        Lottie.asset(
                          'assets/animations/charging.json',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                    height: 30),

                const Text(

                  "Battery Size (Ah)",

                  style: TextStyle(

                    color:
                    Colors.white,

                    fontSize: 18,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 12),

                Container(

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white10,

                    borderRadius:
                    BorderRadius.circular(
                        20),
                  ),

                  child: TextField(

                    controller:
                    batteryController,

                    keyboardType:
                    TextInputType
                        .number,

                    style:
                    const TextStyle(
                      color:
                      Colors.white,
                    ),

                    decoration:
                    const InputDecoration(

                      border:
                      InputBorder.none,

                      prefixIcon:
                      Icon(

                        Icons
                            .battery_charging_full,

                        color:
                        Colors.cyan,
                      ),

                      hintText:
                      "Enter Battery Size",

                      hintStyle:
                      TextStyle(

                        color:
                        Colors.white54,
                      ),

                      contentPadding:
                      EdgeInsets.all(
                          20),
                    ),
                  ),
                ),

                const SizedBox(
                    height: 25),

                const Text(

                  "Charging Time (Minutes)",

                  style: TextStyle(

                    color:
                    Colors.white,

                    fontSize: 18,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 12),

                Container(

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white10,

                    borderRadius:
                    BorderRadius.circular(
                        20),
                  ),

                  child: TextField(

                    controller:
                    timeController,

                    keyboardType:
                    TextInputType
                        .number,

                    style:
                    const TextStyle(
                      color:
                      Colors.white,
                    ),

                    decoration:
                    const InputDecoration(

                      border:
                      InputBorder.none,

                      prefixIcon:
                      Icon(

                        Icons.timer,

                        color:
                        Colors.orange,
                      ),

                      hintText:
                      "Enter Charging Time",

                      hintStyle:
                      TextStyle(

                        color:
                        Colors.white54,
                      ),

                      contentPadding:
                      EdgeInsets.all(
                          20),
                    ),
                  ),
                ),

                const SizedBox(
                    height: 35),

                SizedBox(

                  width:
                  double.infinity,

                  child:
                  ElevatedButton(

                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      Colors
                          .cyanAccent,

                      foregroundColor:
                      Colors.black,

                      padding:
                      const EdgeInsets.all(
                          18),

                      shape:
                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(
                            20),
                      ),
                    ),

                    onPressed:
                    calculateRange,

                    child:
                    const Text(

                      "Calculate EV Range",

                      style:
                      TextStyle(

                        fontSize: 18,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                    height: 40),

                Container(

                  width:
                  double.infinity,

                  padding:
                  const EdgeInsets.all(
                      30),

                  decoration:
                  BoxDecoration(

                    color:
                    Colors.white10,

                    borderRadius:
                    BorderRadius.circular(
                        30),

                    border:
                    Border.all(
                      color:
                      Colors.white24,
                    ),
                  ),

                  child: Column(

                    children: [

                      const Icon(

                        Icons.ev_station,

                        color:
                        Colors.greenAccent,

                        size: 70,
                      ),

                      const SizedBox(
                          height: 20),

                      Text(

                        "${estimatedKm.toStringAsFixed(1)} km",

                        style:
                        const TextStyle(

                          color:
                          Colors.white,

                          fontSize:
                          42,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 12),

                      const Text(

                        "Estimated Travel Range",

                        style:
                        TextStyle(

                          color:
                          Colors.white70,

                          fontSize:
                          18,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                    height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}