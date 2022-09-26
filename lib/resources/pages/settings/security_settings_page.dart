import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../../../app/controllers/controller.dart';
import '../../widgets/settings_button.dart';

class SecuritySettingsPage extends NyStatefulWidget {
  final Controller controller = Controller();
  SecuritySettingsPage({Key? key}) : super(key: key);

  @override
  _SecuritySettingsPageState createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends NyState<SecuritySettingsPage> {
  @override
  init() async {}

  @override
  void dispose() {
    super.dispose();
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
          'Security',
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
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FaIcon(FontAwesomeIcons.envelope),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('example@email.com'),
                      Wrap(
                        children: [
                          Text('Personal Subscription (Monthly)'),
                          SizedBox(
                            width: 10,
                          ),
                          Text('9 cards'),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SettingsButton(
                  label: 'Change Email',
                  icon: FontAwesomeIcons.envelope,
                  onPressed: () {},
                ),
                SettingsButton(
                  label: 'Change Password',
                  icon: FontAwesomeIcons.unlockKeyhole,
                  onPressed: () {
                    routeTo('/settings-page/security');
                  },
                ),
                SettingsButton(
                  label: 'Delete Account',
                  icon: FontAwesomeIcons.trash,
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
