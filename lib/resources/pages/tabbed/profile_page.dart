import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../../../app/controllers/controller.dart';
import '../../../app/networking/user_api_service.dart';
import '../../../bootstrap/helpers.dart';

class ProfilePage extends NyStatefulWidget {
  final Controller controller = Controller();
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends NyState<ProfilePage> {
  Map _userDetails = {
    "firstName": "",
    "lastName": "",
    'profilePhoto': '',
    "jobTitle": '',
    "cardSlots": int,
    'availableCardSlots': int,
    "link": [],
  };
  @override
  init() async {
    loadUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadUserDetails() async {
    final response = await api<UserApiService>(
      (request) => request.getuserDetails(),
      context: context,
    );
    if (response != null) {
      setState(() {
        _userDetails = response;
      });
    }
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      border: Border.all(
                        color: Color(0xFFE3E3E3),
                        width: 3,
                      ),
                      image: DecorationImage(
                        image: _userDetails['profilePhoto'].isNotEmpty
                            ? NetworkImage(_userDetails['profilePhoto']!)
                                as ImageProvider
                            : AssetImage('public/assets/images/nylo_logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: mediaQuery.size.width * 0.28,
                    height: mediaQuery.size.height * 0.12,
                  ),
                  SizedBox(
                    height: mediaQuery.size.height * 0.1,
                    child: Center(
                      child: Text(
                        _userDetails['firstName'] +
                            " " +
                            _userDetails['lastName'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    _userDetails['jobTitle'],
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'About',
                    style: TextStyle(fontSize: 25),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "Lorem Ipsum is simply dummy text of the printing and "
                      "typesetting industry. Lorem Ipsum has been the industry's "
                      "standard dummy text ever since the 1500s, when an unknown printer "
                      "took a galley of type and scrambled it to make a type specimen book. "
                      "It has survived not only five centuries.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Text(
                    'Connect on',
                    style: TextStyle(fontSize: 25),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Wrap(
                      spacing: 30,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.instagram,
                          color: Color(0xFF455154),
                        ),
                        FaIcon(
                          FontAwesomeIcons.linkedinIn,
                          color: Color(0xFF455154),
                        ),
                        FaIcon(
                          FontAwesomeIcons.pinterestP,
                          color: Color(0xFF455154),
                        ),
                        FaIcon(
                          FontAwesomeIcons.facebookF,
                          color: Color(0xFF455154),
                        ),
                        FaIcon(
                          FontAwesomeIcons.patreon,
                          color: Color(0xFF455154),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
