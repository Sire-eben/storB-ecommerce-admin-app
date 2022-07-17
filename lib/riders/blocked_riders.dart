import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockedRidersScreen extends StatefulWidget {
  const BlockedRidersScreen({Key? key}) : super(key: key);

  @override
  State<BlockedRidersScreen> createState() => _BlockedRidersScreenState();
}

class _BlockedRidersScreenState extends State<BlockedRidersScreen> {
  QuerySnapshot? allRiders;

  displayDialogBoxActivatingAccount(userDocID) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Blocked Riders Account?",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black),
            ),
            content: const Text(
                "This account will be reinstated!",
                style: TextStyle(fontSize: 16, color: Colors.black)),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black))),
              TextButton(
                  onPressed: () {
                    Map<String, dynamic> userDataMap = {
                      "status": "approved"
                    };
                    FirebaseFirestore.instance
                        .collection("riders")
                        .doc(userDocID)
                        .update(userDataMap)
                        .then((value) {
                      Navigator.pop(context);
                    }).then((value) {
                      SnackBar snackBar = const SnackBar(
                        elevation: 2,
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          "Rider account activated... ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.cyan,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  },
                  child: const Text("Yes",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red))),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("riders")
        .where("status", isEqualTo: "Not approved")
        .get()
        .then((allVerifiedRiders) {
      setState(() {
        allRiders = allVerifiedRiders;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget displayVerifiedUsersDesign() {
      if (allRiders != null) {
        return ListView.builder(
          itemCount: allRiders!.docs.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.cyan,
                            backgroundImage:
                            NetworkImage(allRiders!.docs[i].get("riderAvatarUrl")),
                          ),

                          Text(allRiders!.docs[i].get("riderName")),
                          Text(allRiders!.docs[i].get("riderEmail")),
                          Text("₦" + allRiders!.docs[i].get("earnings").toString()),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("Blocked", style: TextStyle(color: Colors.red),),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20))),
                                icon: const Icon(
                                  Icons.done_all,
                                ),
                                label: const Text("Activate"),
                                onPressed: () {
                                  displayDialogBoxActivatingAccount(allRiders!.docs[i].id);
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      } else {
        return const Center(
            child: CircularProgressIndicator(color: Colors.cyan,)
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.amber,
                ],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(1, 0),
                stops: [0, 1],
                tileMode: TileMode.clamp),
          ),
        ),
        title: const Text(
          "Blocked Riders",
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child:
            Column(
              children: [
                const SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text("Display Pictures"),

                    SizedBox(
                      width: 10,
                    ),
                    Text("Name"),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Email"),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Earnings"),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Status"),

                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height,
                    child: displayVerifiedUsersDesign()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
