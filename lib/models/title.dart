import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: const TextSpan(
            text: "Re",
            style: TextStyle(
                fontSize: 40, color: Colors.red, fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                text: "Si",
                style: TextStyle(fontSize: 40, color: Colors.green),
              ),
              TextSpan(
                text: "Te",
                style: TextStyle(fontSize: 40, color: Colors.purple),
              ),
              TextSpan(
                text: "L",
                style: TextStyle(fontSize: 40, color: Colors.blue),
              ),
            ]),
      ),
    );
  }
}
