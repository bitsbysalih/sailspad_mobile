import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sailspad/app/networking/ar_card_api_service.dart';
import 'package:sailspad/resources/widgets/profile_photo_input.dart';

import '../../app/controllers/sign_up_controller.dart';
import '../../app/networking/user_api_service.dart';
import '../../bootstrap/helpers.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/card_link_item.dart';
import '../widgets/rounded_button.dart';

class SignUpPage extends NyStatefulWidget {
  final SignUpController controller = SignUpController();

  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends NyState<SignUpPage> {
  final _signUpFormKey = GlobalKey<FormState>();

  int signUpStep = 1;
  bool _isLoading = false;
  File? _profilePhoto;
  final userContactLinks = [
    {"name": "twitter", "link": "https://twitter.com/"},
  ];
  Timer? _debounce;

  Map _signUpData = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'jobTitle': '',
    'password': '',
    'confirmPassword': '',
    'profilePhoto': File,
    'otpToken': '',
    "links": [],
  };

  @override
  init() async {
    _signUpData['links'] = userContactLinks;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void moveToNext() {
    setState(
      () => signUpStep++,
    );
  }

  void _selectProfileImage(File pickedImage) async {
    _profilePhoto = pickedImage;
    setState(() {
      _signUpData['profilePhoto'] = _profilePhoto;
    });
  }

  void sendNewOtp() async {
    final response = await api<UserApiService>(
      (request) => request.resendOtp(),
      context: context,
    );
    if (response != null) {
      showToastNotification(
        context,
        title: 'Success',
        description: 'New otp sent',
      );
    }
  }

  void initialSignUp() async {
    setState(() {
      _isLoading = true;
    });
    String fileName = _profilePhoto!.path.split('/').last;
    FormData formData = new FormData.fromMap({
      "firstName": _signUpData['firstName'],
      "lastName": _signUpData['lastName'],
      'jobTitle': _signUpData['jobTitle'],
      'email': _signUpData['email'],
      'password': _signUpData['password'],
      "profilePhoto": await MultipartFile.fromFile(
        _profilePhoto!.path,
        filename: fileName,
      ),
    });
    final response = await api<UserApiService>(
      (request) => request.signUp(data: formData),
      context: context,
    );
    if (response != null) {
      await NyStorage.store('user_token', response.accessToken);
      moveToNext();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void verifyOtp() async {
    setState(() {
      _isLoading = true;
    });
    final response = await api<UserApiService>(
      (request) => request.verifyOtp(
        query: {
          'token': _signUpData['otpToken'],
        },
      ),
      context: context,
    );
    if (response == null) {
      showToastNotification(
        context,
        title: 'Error',
        description: 'Request new otp',
        style: ToastNotificationStyleType.DANGER,
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _isLoading = false;
    });

    moveToNext();
  }

  void addContacts() async {
    setState(() {
      _isLoading = true;
    });
    final response = await api<UserApiService>(
      (request) => request.addContactLinks(
        data: {
          'links': _signUpData['links'],
        },
      ),
    );
    if (response == null) {
      showToastNotification(
        context,
        title: 'Error',
        description: 'Error adding links',
      );
    }
    createCardFromSignUp();

    setState(() {
      _isLoading = false;
    });
    routeTo('/tabs-page');
  }

  void createCardFromSignUp() async {
    String cardImagefileName = _profilePhoto!.path.split('/').last;
    print(_signUpData);
    FormData formData = new FormData.fromMap({
      "name": _signUpData['firstName'] + " " + _signUpData['lastName'],
      "title": _signUpData['jobTitle'],
      'about': 'About yourself',
      'email': _signUpData['email'],
      'links': _signUpData['links'],
      "activeStatus": 'true',
      "cardImage": await MultipartFile.fromFile(
        _profilePhoto!.path,
        filename: cardImagefileName,
      ),
    });
    await api<ArCardApiService>(
      (request) => request.create(
        data: formData,
      ),
    );
  }

  Widget initialSignUpView() {
    return Container(
      child: Form(
        key: _signUpFormKey,
        child: Column(
          children: [
            Text(
              'Tell us about you!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ProfilePhotoInput(
              onSelectImage: _selectProfileImage,
            ),
            Form(
              child: Column(
                children: [
                  AuthFormField(
                    label: 'First Name',
                    textInputType: TextInputType.name,
                    onChanged: (value) {
                      _signUpData['firstName'] = value;
                    },
                  ),
                  AuthFormField(
                    label: 'Last Name',
                    textInputType: TextInputType.name,
                    onChanged: (value) {
                      _signUpData['lastName'] = value;
                    },
                  ),
                  AuthFormField(
                    label: 'Job Title',
                    textInputType: TextInputType.text,
                    onChanged: (value) {
                      _signUpData['jobTitle'] = value;
                    },
                  ),
                  AuthFormField(
                    label: 'Email',
                    textInputType: TextInputType.emailAddress,
                    onChanged: (value) {
                      _signUpData['email'] = value;
                    },
                  ),
                  AuthFormField(
                    label: 'Password',
                    textInputType: TextInputType.visiblePassword,
                    onChanged: (value) {
                      _signUpData['password'] = value;
                    },
                    obscureText: true,
                  ),
                  AuthFormField(
                    label: 'Confirm Password',
                    textInputType: TextInputType.visiblePassword,
                    onChanged: (value) {
                      _signUpData['confirmPassword'] = value;
                    },
                    obscureText: true,
                  ),
                ],
              ),
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
              onPressed: initialSignUp,
            ),
            TextButton(
              onPressed: () {
                routeTo('/sign-in-page');
              },
              child: Text('Already have an account?'),
            )
          ],
        ),
      ),
    );
  }

  Widget emailVerification() {
    return Container(
      child: Column(
        children: [
          Text(
            'Enter the OTP we sent to your email ${_signUpData['email']}',
            textAlign: TextAlign.center,
          ),
          PinCodeTextField(
            length: 6,
            obscureText: false,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.circle,
                inactiveColor: Colors.grey,
                activeColor: Colors.blue,
                inactiveFillColor: Colors.white,
                errorBorderColor: Colors.red,
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
                selectedFillColor: Colors.white),
            animationDuration: Duration(milliseconds: 300),
            backgroundColor: Colors.white,
            enableActiveFill: true,
            onCompleted: (v) {
              print("Completed");
              verifyOtp();
            },
            onChanged: (value) {
              setState(() {
                _signUpData['otpToken'] = value;
              });
            },
            beforeTextPaste: (text) {
              return true;
            },
            appContext: context,
          ),
          TextButton(
            onPressed: sendNewOtp,
            child: Text('Resend Code'),
          ),
          if (_isLoading)
            SizedBox(
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 2,
              ),
              height: 20.0,
              width: 20.0,
            )
        ],
      ),
    );
  }

  Widget contactDetails() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'How do you want people to contact you?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20, top: 30),
                  height: 200,
                  child: ListView.builder(
                    itemBuilder: (ctx, i) {
                      return CardLinkItem(
                        name: _signUpData['links'][i]['name'],
                        link: _signUpData['links'][i]['link'],
                        // removeAt: () {
                        //   setState(
                        //     () {
                        //       _signUpData['links'].removeAt(i);
                        //     },
                        //   );
                        // },
                      );
                    },
                    itemCount: _signUpData['links'].length,
                  ),
                ),
                RoundedButton(
                  width: 80,
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FaIcon(FontAwesomeIcons.plus, size: 14),
                      Text(
                        'Add',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      _signUpData['links'].add({
                        "name": "twitter",
                        "link": "",
                      });
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
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
            onPressed: addContacts,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.size.height,
          width: mediaQuery.size.width,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 200,
                child: Image.asset(
                  'public/assets/images/logo.png',
                ),
              ),
              if (signUpStep == 1)
                initialSignUpView()
              else if (signUpStep == 2)
                emailVerification()
              else if (signUpStep == 3)
                contactDetails()
            ],
          ),
        ),
      ),
    );
  }
}
