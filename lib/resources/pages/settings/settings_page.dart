import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:sailspad/resources/pages/sign_in_page.dart';
import 'package:sailspad/resources/widgets/auth_form_field.dart';
import 'package:sailspad/resources/widgets/rounded_button.dart';

import '../../../app/controllers/controller.dart';
import '../../../app/networking/user_api_service.dart';
import '../../../bootstrap/helpers.dart';
import '../../widgets/profile_photo_input.dart';
import '../../widgets/settings_button.dart';

enum PageState {
  normal,
  userDetails,
}

class SettingsPage extends NyStatefulWidget {
  final Controller controller = Controller();
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends NyState<SettingsPage> {
  File? _newProfilePhoto;
  Map _userDetails = {
    "firstName": "",
    "lastName": "",
    'email': '',
    'profilePhoto': '',
    "jobTitle": '',
    "cardSlots": int,
    "availableCardSlots": int
  };

  bool _isLoading = false;

  PageState pageState = PageState.normal;

  @override
  init() async {
    await loadUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _selectProfilePhoto(File pickedImage) async {
    _newProfilePhoto = pickedImage;
    setState(() {
      _userDetails['profilePhoto'] = _newProfilePhoto;
    });
  }

  Future<void> loadUserDetails() async {
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

  Future<void> changeUserDetails() async {
    String? profilePhotofileName = _newProfilePhoto?.path.split('/').last;
    FormData formData = new FormData.fromMap({
      "firstName": _userDetails['firstName'],
      "lastName": _userDetails['lastName'],
      'jobTitle': _userDetails['jobTitle'],
      "profilePhoto": profilePhotofileName != null
          ? await MultipartFile.fromFile(
              _newProfilePhoto!.path,
              filename: profilePhotofileName,
            )
          : '',
    });
    setState(() {
      _isLoading = true;
    });
    final response = await api<UserApiService>(
      (request) => request.update(
        data: formData,
      ),
    );
    if (response != null) {
      pageState = PageState.normal;
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget userDetailsInput() {
    return Container(
      child: Column(
        children: [
          AuthFormField(
            label: 'First Name',
            initialValue: _userDetails['firstName'],
            onChanged: (value) {
              _userDetails['firstName'] = value;
            },
          ),
          AuthFormField(
            label: 'Last Name',
            initialValue: _userDetails['lastName'],
            onChanged: (value) {
              _userDetails['lastName'] = value;
            },
          ),
          AuthFormField(
            label: 'Job Title',
            initialValue: _userDetails['jobTitle'],
            onChanged: (value) {
              _userDetails['jobTitle'] = value;
            },
          ),
          RoundedButton(
            width: 140,
            child: _isLoading
                ? SizedBox(
                    child: SpinKitChasingDots(
                      color: Colors.grey,
                      size: 20.0,
                    ),
                    height: 20.0,
                    width: 20.0,
                  )
                : Text('Update User'),
            onPressed: () async {
              await changeUserDetails();
            },
          ),
          TextButton(
            onPressed: () {
              setState(() {
                pageState = PageState.normal;
              });
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF414546),
              ),
            ),
          ),
        ],
      ),
    );
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
            SchedulerBinding.instance.addPostFrameCallback(
              (_) async {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/tabs-page', (Route<dynamic> route) => false);
              },
            );
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
                  InkWell(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          pageState = PageState.userDetails;
                        });
                      },
                      child: ProfilePhotoInput(
                        profilePhoto: _userDetails['profilePhoto'] != null
                            ? _userDetails['profilePhoto'].toString()
                            : '',
                        showSelector: pageState == PageState.userDetails,
                        onSelectImage: _selectProfilePhoto,
                      ),
                    ),
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
            if (pageState == PageState.normal)
              Column(
                children: [
                  SettingsButton(
                    label: 'Subscriptions',
                    icon: FontAwesomeIcons.creditCard,
                    onPressed: () {
                      routeTo(
                        '/settings-page/subscription',
                        data: {
                          'email': _userDetails['email'],
                          "cardSlots": _userDetails['cardSlots'],
                        },
                      );
                    },
                  ),
                  SettingsButton(
                    label: 'Security',
                    icon: FontAwesomeIcons.unlockKeyhole,
                    onPressed: () {
                      routeTo(
                        '/settings-page/security',
                        data: {
                          'email': _userDetails['email'],
                          "cardSlots": _userDetails['cardSlots'],
                        },
                      );
                    },
                  ),
                  SettingsButton(
                    label: 'Logout',
                    icon: FontAwesomeIcons.arrowRightFromBracket,
                    onPressed: () async {
                      await NyStorage.delete('user_token');
                      SchedulerBinding.instance.addPostFrameCallback(
                        (_) async {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/sign-in-page', (Route<dynamic> route) => false);
                        },
                      );
                    },
                  ),
                ],
              )
            else if (pageState == PageState.userDetails)
              userDetailsInput(),
          ],
        ),
      ),
    );
  }
}
