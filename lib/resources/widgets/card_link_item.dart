import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';

import 'auth_form_field.dart';

class CardLinkItem extends StatefulWidget {
  CardLinkItem({
    super.key,
    required this.name,
    required this.link,
    required this.removeAt,
  });

  String? name;
  String? link;
  final VoidCallback removeAt;
  @override
  State<CardLinkItem> createState() => _CardLinkItemState();
}

class _CardLinkItemState extends NyState<CardLinkItem> {
  final List<String> items = [
    'instagram',
    'facebook',
    'linkedin',
    'twitter',
    'website',
    'github',
  ];

  IconData iconSelector(String iconName) {
    if (iconName == 'instagram') {
      return FontAwesomeIcons.instagram;
    } else if (iconName == 'twitter') {
      return FontAwesomeIcons.twitter;
    } else if (iconName == 'facebook') {
      return FontAwesomeIcons.facebook;
    } else if (iconName == 'linkedin') {
      return FontAwesomeIcons.linkedin;
    } else if (iconName == 'website') {
      return FontAwesomeIcons.globe;
    } else if (iconName == 'github') {
      return FontAwesomeIcons.github;
    }
    return FontAwesomeIcons.a;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            buttonPadding: EdgeInsets.symmetric(horizontal: 5),
            icon: FaIcon(
              FontAwesomeIcons.chevronDown,
              size: 10,
            ),
            hint: Text(
              'Select Item',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FaIcon(
                          iconSelector(item),
                        ),
                        SizedBox(width: 5),
                        Text(
                          item,
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            value: widget.name,
            onChanged: (value) {
              setState(() {
                widget.name = value as String;
                print(widget.name);
              });
            },
            buttonHeight: 35,
            buttonWidth: 100,
            itemHeight: 40,
            itemPadding: EdgeInsets.symmetric(horizontal: 5),
            buttonDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        SizedBox(
          width: mediaQuery.size.width * 0.4,
          height: 55,
          child: AuthFormField(
            onChanged: (value) {
              widget.link = value;
            },
            initialValue: widget.link,
            padding: 10,
            label: 'Add your link here',
            fontSize: 12,
          ),
        ),
        GestureDetector(
          onTap: widget.removeAt,
          child: FaIcon(
            FontAwesomeIcons.solidCircleXmark,
            size: 20,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
