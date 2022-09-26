import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../../app/controllers/controller.dart';
import '../../../app/networking/user_api_service.dart';
import '../../../bootstrap/helpers.dart';
import '../../widgets/settings_button.dart';

class SettingsPage extends NyStatefulWidget {
  final Controller controller = Controller();
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends NyState<SettingsPage> {
  Map _userDetails = {
    "firstName": "",
    "lastName": "",
    'profilePhoto': '',
    "jobTitle": '',
    "cardSlots": int,
    "availableCardSlots": int
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
      appBar: AppBar(
        backgroundColor: Color(0xFFD8E3E9),
        automaticallyImplyLeading: false,
        leading: TextButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFD8E3E9),
            foregroundColor: Color(0xFF414546),
          ),
          child: FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF414546),
          ),
        ),
        elevation: 0,
        shadowColor: Color.fromARGB(255, 182, 182, 182),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('public/assets/images/gradient_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        height: mediaQuery.size.height,
        width: mediaQuery.size.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Color(0xFFE3E3E3),
                      ),
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: _userDetails['profilePhoto']!.isNotEmpty
                            ? NetworkImage(_userDetails['profilePhoto']!)
                                as ImageProvider
                            : AssetImage(
                                'public/assets/images/john-smith.jpeg',
                              ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    _userDetails['firstName'] +
                        "\n " +
                        _userDetails['lastName'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    _userDetails['jobTitle'],
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SettingsButton(
                  label: 'Subscriptions',
                  icon: FontAwesomeIcons.creditCard,
                  onPressed: () {},
                ),
                SettingsButton(
                  label: 'Security',
                  icon: FontAwesomeIcons.unlockKeyhole,
                  onPressed: () {
                    routeTo('/settings-page/security');
                  },
                ),
                SettingsButton(
                  label: 'Logout',
                  icon: FontAwesomeIcons.arrowRightFromBracket,
                  onPressed: () {
                    NyStorage.delete('user_token');
                    routeTo('/sign-in-page');
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
