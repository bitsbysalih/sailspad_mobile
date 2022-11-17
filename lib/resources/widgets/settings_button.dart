import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: FaIcon(icon),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 18),
          ),
          Spacer(),
          FaIcon(
            FontAwesomeIcons.chevronRight,
            size: 15,
          )
        ],
      ),
    );
  }
}
