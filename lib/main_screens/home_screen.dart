import 'dart:async';

import 'package:breejstores_web_admin/Authentication/login_screen.dart';
import 'package:breejstores_web_admin/merchants/blocked_merchants.dart';
import 'package:breejstores_web_admin/riders/blocked_riders.dart';
import 'package:breejstores_web_admin/riders/verified_riders.dart';
import 'package:breejstores_web_admin/users/blocked_users.dart';
import 'package:breejstores_web_admin/users/verified_users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../merchants/verified_merchants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String timeText = "";
  String dateText = "";

  String formatCurrentLiveTime(DateTime time) {
    return DateFormat("hh:mm:ss a").format(time);
  }

  String formatCurrentLiveDate(DateTime date) {
    return DateFormat("dd MMMM, yyyy").format(date);
  }

  getCurrentLiveTime() {
    final DateTime timeNow = DateTime.now();
    final String liveTime = formatCurrentLiveTime(timeNow);
    final String liveDate = formatCurrentLiveDate(timeNow);

    if (mounted) {
      setState(() {
        timeText = liveTime;
        dateText = liveDate;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //TIME
    timeText = formatCurrentLiveTime(DateTime.now());

    //DATE
    dateText = formatCurrentLiveDate(DateTime.now());

    Timer.periodic(const Duration(seconds: 1), (timer) {
      getCurrentLiveTime();
    });
  }

  // getAdminDetails(String adminID) async {
  //   String adminPhoto = "";
  //   User? admin;
  //   FirebaseFirestore.instance
  //       .collection("admins")
  //       .doc(admin!.uid)
  //       .get().then((value) {
  //         setState(() {
  //           adminPhoto = value as String;
  //         });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    User? user;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.cyan),
        ),
        title: const Text(
          "Breej Stores Admin portal",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().whenComplete(() {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const LoginScreen()),
                            (route) => false);
                      });
                    },
                    icon: const Icon(Icons.logout)),
                const SizedBox(
                  width: 10,
                ),
                const Text("Logout")
              ],
            ),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    timeText + "\n" + dateText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // ACTIVATE AND BLOCK USER ACCOUNT BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 50),
                          primary: Colors.cyan,
                          shape: (RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)))),
                      icon: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Verified Users".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const VerifiedUsersScreen()));
                      },
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 50),
                          primary: Colors.cyan,
                          shape: (RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)))),
                      icon: const Icon(
                        Icons.block_flipped,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Blocked Users".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const BlockedUsersScreen()));
                      },
                    ),
                  ],
                ),

                // ACTIVATE AND BLOCK MERCHANTS ACCOUNT BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 50),
                          primary: Colors.cyan,
                          shape: (RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)))),
                      icon: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Verified Merchants".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) =>
                                    const VerifiedMerchantsScreen()));
                      },
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 50),
                          primary: Colors.cyan,
                          shape: (RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)))),
                      icon: const Icon(
                        Icons.block_flipped,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Blocked Merchants".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) =>
                                    const BlockedMerchantsScreen()));
                      },
                    ),
                  ],
                ),

                // ACTIVATE AND BLOCK RIDERS ACCOUNT BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 50),
                          primary: Colors.cyan,
                          shape: (RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)))),
                      icon: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Verified Riders".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const VerifiedRidersScreen()));
                      },
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 50),
                          primary: Colors.cyan,
                          shape: (RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)))),
                      icon: const Icon(
                        Icons.block_flipped,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Blocked Riders".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const BlockedRidersScreen()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
