import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget {
   String? title;
   MyAppBar({Key? key, this.title}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      title: Text(
        "title",
      ),
      centerTitle: true,
    );
  }
}
