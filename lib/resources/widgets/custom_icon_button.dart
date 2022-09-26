import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          FaIcon(
            icon,
            size: 25,
          ),
          SizedBox(
            height: 9,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10),
          )
        ],
      ),
    );
  }
}
