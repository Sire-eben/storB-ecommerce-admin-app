import 'package:breejstores_web_admin/main_screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String adminEmail = "";
  String adminPassword = "";

  allowAdminToLogin() async {
    SnackBar snackBar = const SnackBar(
      elevation: 2,
      duration: Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      content: Text(
        "Loading... ",
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.cyan,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    User? currentAdmin;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: adminEmail, password: adminPassword)
        .then((fAuth) {
      currentAdmin = fAuth.user;
    }).catchError((onError) {
      //DISPLAY ERROR MESSAGE
      final snackBar = SnackBar(
        elevation: 2,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        content: Text(
          "Error occured: " + onError.toString(),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    if (currentAdmin != null) {
      //CHECK IF ADMIN RECORD EXISTS
      await FirebaseFirestore.instance
          .collection("admins")
          .doc(currentAdmin!.uid)
          .get()
          .then((snap) {
        if (snap.exists) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (c) => HomeScreen()));
        } else {
          SnackBar snackBar = const SnackBar(
            elevation: 2,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            content: Text(
              "Invalid Admin Credentials...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.cyan,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //IMAGE
                  Container(
                    height: 300,
                width: 300,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                          child: Lottie.asset("images/9573-analytics.json",
                              height: 300, width: 300))),

                  //EMAIL TEXT FIELD
                  TextField(
                    onChanged: (value) {
                      adminEmail = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade300,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.cyan.shade300,
                            width: 2,
                          ),
                        ),
                        hintText: "Enter Email",
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.grey.shade300,
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),

                  //PASSWORD TEXT FIELD
                  TextField(
                    onChanged: (value) {
                      adminPassword = value;
                    },
                    obscureText: true,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade300,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.cyan.shade300,
                            width: 2,
                          ),
                        ),
                        hintText: "Enter Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.grey.shade300,
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),

                  //LOGIN BUTTON
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.cyan,
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25))),
                      onPressed: () {
                        allowAdminToLogin();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.arrow_forward)
                        ],
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
