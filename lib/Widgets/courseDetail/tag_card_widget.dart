import 'package:flutter/material.dart';

class TagCardWidget extends StatelessWidget {
  final Color color;
  final String tag;
  const TagCardWidget({super.key, required this.color, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0)
      ),
      padding: const EdgeInsets.all(5.0),
      child: Text(
        tag,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black
        ),
      ),
    );
  }
}