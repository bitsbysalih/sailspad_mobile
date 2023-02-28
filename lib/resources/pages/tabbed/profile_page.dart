import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:sailspad/app/networking/ar_card_api_service.dart';
import 'package:sailspad/resources/widgets/profile_photo_input.dart';

import '../../../app/controllers/controller.dart';
import '../../../bootstrap/helpers.dart';

class ProfilePage extends NyStatefulWidget {
  final Controller controller = Controller();
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends NyState<ProfilePage> {
  Map _userDetails = {
    "name": "",
    "title": "",
    'cardImage': '',
    "about": '',
    "links": [],
  };
  @override
  init() async {
    await loadUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadUserDetails() async {
    final response = await api<ArCardApiService>(
      (request) => request.fetchAll(),
      context: context,
    );
    if (response != null) {
      setState(() {
        _userDetails = {
          "name": response[0].name,
          "title": response[0].title,
          'about': response[0].about,
          "cardImage": response[0].cardImage,
          "links": response[0].links,
        };
      });
    }
  }

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.2,
              color: Color(0xFF455154),
            ),
          ),
        ),
        height: mediaQuery.size.height * 0.735,
        width: mediaQuery.size.width,
        padding: EdgeInsets.only(left: 30, right: 30, top: 30),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  ProfilePhotoInput(
                    profilePhoto: _userDetails['cardImage'],
                    showSelector: false,
                  ),
                  SizedBox(
                    height: mediaQuery.size.height * 0.1,
                    child: Center(
                      child: Text(
                        _userDetails['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    _userDetails['title'],
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.4),
              ),
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.symmetric(horizontal: 24),
              height: mediaQuery.size.height * 0.4,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                      'About',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      _userDetails['about'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        children: [
                          Text(
                            'Connect on',
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Wrap(
                            spacing: 30,
                            children: (_userDetails['links'] as List).map((e) {
                              return FaIcon(
                                iconSelector(e['name']),
                                color: Color(0xFF455154),
                              );
                            }).toList(),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
