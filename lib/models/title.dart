import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
        text: const TextSpan(
            text: "Re",
            style: TextStyle(
                fontSize: 40, color: Colors.pink, fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                text: "Si",
                style: TextStyle(fontSize: 40, color: Colors.blue),
              ),
              TextSpan(
                text: "Te",
                style: TextStyle(fontSize: 40, color: Colors.purple),
              ),
              TextSpan(
                text: "L",
                style: TextStyle(fontSize: 40, color: Colors.orange),
              ),
            ]),
      ),
    );
  }
}
