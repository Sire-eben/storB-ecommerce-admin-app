import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({Key? key}) : super(key: key);

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  QuerySnapshot? allUsers;

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
                "This account will be unblocked.",
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
                      "status": "Approved"
                    };
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(userDocID)
                        .update(userDataMap)
                        .then((value) {
                      Navigator.pop(context);
                      SnackBar snackBar = const SnackBar(
                        elevation: 2,
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          "User account has been reactivated... ",
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
        .collection("users")
        .where("status", isEqualTo: "Not approved")
        .get()
        .then((allVerifiedUsers) {
      setState(() {
        allUsers = allVerifiedUsers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget displayBlockedUsersDesign() {
      if (allUsers != null) {
        return ListView.builder(
          itemCount: allUsers!.docs.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.cyan,
                          backgroundImage:
                          NetworkImage(allUsers!.docs[i].get("photoUrl")),
                        ),
                        title: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(allUsers!.docs[i].get("name")),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            const Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(allUsers!.docs[i].get("email")),
                          ],
                        ),
                        trailing: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          icon: const Icon(
                            Icons.done_all,
                          ),
                          label: const Text("Activate User"),
                          onPressed: () {
                            displayDialogBoxActivatingAccount(allUsers!.docs[i].id);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
      else{

      return Center(child: Text("No users"),);
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
          "Blocked Users",
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: displayBlockedUsersDesign(),
        ),
      ),
    );
  }
}
