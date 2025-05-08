import 'package:flutter/material.dart';

Widget button({required String name, required VoidCallback onPressed, Color? boxColor, Color? textColor}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: boxColor ?? Colors.black87,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: const BorderSide(color: Colors.black)
      ),
      minimumSize: const Size(double.infinity, 40)
    ),
    child: Text(
      name,
      style: TextStyle(
        fontSize: 15,
        color: textColor ?? Colors.yellow,
        fontWeight: FontWeight.bold
      )
    ),
  );
}

Widget commonHeading(String name) {
  return Text(
    name,
    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
  );
}

Widget commonSubHeading(String name) {
  return Text(
    name,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  );
}

Widget resultBox({
  required double height,
  required double width,
  required IconData icon,
  required Color iconColor,
  required String data,
  required String type
}) {
  return Container(
    height: 140,
    width: 100,
    decoration: BoxDecoration(border: Border.all(color: Colors.black), color: Colors.white38),
    padding: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor,
          ),
          child: Icon(
            icon,
            size: 16,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        Text(
          data,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 10,
        ),
        commonSubHeading(type)
      ],
    ),
  );
}
