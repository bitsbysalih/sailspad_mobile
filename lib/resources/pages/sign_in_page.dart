import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:sailspad/resources/widgets/auth_form_field.dart';

import '../../app/controllers/controller.dart';
import '../../app/networking/user_api_service.dart';
import '../../bootstrap/helpers.dart';
import '../widgets/rounded_button.dart';

class SignInPage extends NyStatefulWidget {
  final Controller controller = Controller();
  SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends NyState<SignInPage> {
  Map _signInData = {
    "email": "spectering.code@gmail.com",
    "password": "FreshStart1*",
  };

  bool _isLoading = false;

  @override
  init() async {}

  @override
  void dispose() {
    super.dispose();
  }

  void signInUser() async {
    setState(() {
      _isLoading = true;
    });
    final response = await api<UserApiService>(
      (request) => request.signIn(data: {
        "email": _signInData['email'],
        "password": _signInData['password'],
      }),
      context: context,
    );
    if (response != null) {
      await NyStorage.store('user_token', response.accessToken);
      routeTo('/tabs-page', navigationType: NavigationType.pushReplace);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.size.height,
          width: mediaQuery.size.width,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 200,
                  child: Image.asset(
                    'public/assets/images/logo.png',
                  ),
                ),
                Container(
                  height: mediaQuery.size.height * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      AuthFormField(
                        label: 'Email',
                        textInputType: TextInputType.text,
                        onChanged: (value) {
                          _signInData['email'] = value;
                        },
                      ),
                      AuthFormField(
                        label: 'Password',
                        textInputType: TextInputType.visiblePassword,
                        obscureText: true,
                        onChanged: (value) {
                          _signInData['password'] = value;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text('Forgot Password?'),
                          ),
                        ],
                      ),
                      RoundedButton(
                        child: _isLoading
                            ? SizedBox(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                  strokeWidth: 2,
                                ),
                                height: 20.0,
                                width: 20.0,
                              )
                            : Text(
                                'Next',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                ),
                              ),
                        onPressed: signInUser,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    routeTo('/sign-up-page');
                  },
                  child: Text('New To Sailspad?'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
