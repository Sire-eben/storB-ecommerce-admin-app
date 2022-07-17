import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockedMerchantsScreen extends StatefulWidget {
  const BlockedMerchantsScreen({Key? key}) : super(key: key);

  @override
  State<BlockedMerchantsScreen> createState() => _BlockedMerchantsScreenState();
}

class _BlockedMerchantsScreenState extends State<BlockedMerchantsScreen> {
  QuerySnapshot? allMerchants;

  displayDialogBoxActivatingAccount(userDocID) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Activate Account?",
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
                        .collection("merchants")
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
                          "Merchant account activated... ",
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
        .collection("merchants")
        .where("status", isEqualTo: "Not approved")
        .get()
        .then((allVerifiedMerchants) {
      setState(() {
        allMerchants = allVerifiedMerchants;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget displayVerifiedUsersDesign() {
      if (allMerchants != null) {
        return ListView.builder(
          itemCount: allMerchants!.docs.length,
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
                            NetworkImage(allMerchants!.docs[i].get("sellerAvatarUrl")),
                          ),

                          Text(allMerchants!.docs[i].get("sellerName")),
                          Text(allMerchants!.docs[i].get("sellerEmail")),
                          Text("₦" + allMerchants!.docs[i].get("earnings").toString()),
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
                                  displayDialogBoxActivatingAccount(allMerchants!.docs[i].id);
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
          "Blocked Merchants",
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
