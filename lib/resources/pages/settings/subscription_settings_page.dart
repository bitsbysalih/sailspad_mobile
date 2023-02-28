import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:sailspad/resources/widgets/settings_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/controllers/controller.dart';
import '../../../app/networking/user_api_service.dart';
import '../../../bootstrap/helpers.dart';

class SubscriptionSettingsPage extends NyStatefulWidget {
  final Controller controller = Controller();
  SubscriptionSettingsPage({Key? key}) : super(key: key);

  @override
  _SubscriptionSettingsPageState createState() =>
      _SubscriptionSettingsPageState();
}

class _SubscriptionSettingsPageState extends NyState<SubscriptionSettingsPage> {
  Map userDetails = {
    "email": '',
    'cardSlots': int,
  };
  @override
  init() async {
    userDetails = widget.data();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void goToBilling() async {
    final response = await api<UserApiService>(
      (request) => request.createBilling(),
    );
    if (response != null) {
      launchUrl(
        Uri.parse(
          response['url'],
        ),
        mode: LaunchMode.platformDefault,
      );
      print(response);
    }
  }

  String get planSelector {
    if (userDetails["cardSlots"] >= 1 && userDetails["cardSlots"] < 10) {
      return "Personal";
    } else if (userDetails["cardSlots"] >= 10 &&
        userDetails["cardSlots"] < 50) {
      return "Startup";
    } else if (userDetails["cardSlots"] >= 50 &&
        userDetails["cardSlots"] < 100) {
      return "SME";
    } else if (userDetails["cardSlots"] >= 100 &&
        userDetails["cardSlots"] < 10) {
      return "SME+";
    } else if (userDetails["cardSlots"] >= 200) {
      return "Agency";
    }
    return '';
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
          'Subscription',
          style: TextStyle(
            color: Color(0xFF414546),
          ),
        ),
        elevation: 0,
        shadowColor: Color.fromARGB(255, 182, 182, 182),
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FaIcon(FontAwesomeIcons.envelope),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$planSelector ${userDetails["cardSlots"]} cards"),
                      ],
                    ),
                    Spacer(),
                    FaIcon(FontAwesomeIcons.ccVisa)
                  ],
                ),
              ),
              SettingsButton(
                label: 'Go to billing',
                icon: FontAwesomeIcons.creditCard,
                onPressed: () {
                  goToBilling();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
