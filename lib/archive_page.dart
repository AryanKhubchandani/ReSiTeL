import 'package:flutter/material.dart';

class Archive extends StatefulWidget {
  const Archive({Key? key}) : super(key: key);

  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemBuilder: (_, index) => Text(
            "Item $index",
            style: const TextStyle(fontSize: 30),
          ),
          itemCount: 20,
        ),
      ),
    );
  }
}
