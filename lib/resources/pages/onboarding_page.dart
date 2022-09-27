import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../app/controllers/controller.dart';

class OnboardingPage extends NyStatefulWidget {
  final Controller controller = Controller();
  OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends NyState<OnboardingPage> {
  @override
  init() async {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('public/assets/images/dude-standing.png'),
            fit: BoxFit.cover,
          ),
        ),
        width: mediaQuery.size.width,
        child: Stack(
          children: [
            Container(
              color: Colors.black54,
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 60),
                    child: Image.asset('public/assets/images/logo.png'),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No app access',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          'A business card that works on the web on all devices',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: mediaQuery.size.height * 0.15,
                  ),
                  Text(
                    'Create your extended business card experience',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 35,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 150,
                            height: 45,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0xffE4E9EA),
                                foregroundColor: Color(0xff455154),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                              onPressed: () {
                                routeTo(
                                  '/sign-up-page',
                                  navigationType:
                                      NavigationType.popAndPushNamed,
                                );
                              },
                              child: Text(
                                'GET STARTED',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              routeTo(
                                '/sign-in-page',
                                navigationType: NavigationType.popAndPushNamed,
                              );
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
