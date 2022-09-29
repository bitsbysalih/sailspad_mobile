import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sailspad/resources/widgets/auth_form_field.dart';
import 'package:sailspad/resources/widgets/rounded_button.dart';

import '../../../app/controllers/controller.dart';
import '../../../app/networking/user_api_service.dart';
import '../../../bootstrap/helpers.dart';
import '../../widgets/settings_button.dart';

enum PageState {
  normal,
  passwordInput,
  emailInput,
}

class SecuritySettingsPage extends NyStatefulWidget {
  final Controller controller = Controller();
  SecuritySettingsPage({Key? key}) : super(key: key);

  @override
  _SecuritySettingsPageState createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends NyState<SecuritySettingsPage> {
  bool _isLoading = false;
  String otp = '';
  String newEmail = '';
  String newPassword = '';
  String password = '';
  Map userDetails = {
    "email": '',
    'cardSlots': int,
  };

  TextEditingController passwordInputController = TextEditingController();

  PageState pageState = PageState.normal;

  PageState requestedPageState = PageState.normal;
  @override
  init() async {
    userDetails = widget.data();
    print(widget.data());
    if (await NyStorage.read('user_token') == null) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) async {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/sign-in-page', (Route<dynamic> route) => false);
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
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

  void verifyOtp() async {
    setState(() {
      _isLoading = true;
    });
    final response = await api<UserApiService>(
      (request) => request.verifyOtp(
        query: {
          'token': otp,
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

    Navigator.of(context).pop();
    setState(() {
      pageState = requestedPageState;
      _isLoading = false;
    });
  }

  void changePassword() async {
    setState(() {
      _isLoading = true;
    });

    final response = await api<UserApiService>(
      (request) => request.editPassword(
        data: {'password': newPassword},
      ),
      context: context,
    );
    if (response != null) {
      setState(() {
        pageState = PageState.normal;
        _isLoading = false;
      });
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void changeEmail() async {
    setState(() {
      _isLoading = true;
    });

    final response = await api<UserApiService>(
      (request) => request.update(
        data: {'email': newEmail},
      ),
      context: context,
    );
    if (response != null) {
      setState(() {
        pageState = PageState.normal;
        _isLoading = false;
      });
      await NyStorage.store('user_token', response.accessToken);
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> deleteAccount() async {
    final response = await api<UserApiService>(
      (request) => request.delete(
        data: {"password": passwordInputController.text},
      ),
    );
    if (response != null) {
      await NyStorage.delete("user_token");
      await NyStorage.delete("user_id");
      Navigator.of(context).pop();
      SchedulerBinding.instance.addPostFrameCallback(
        (_) async {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/sign-in-page', (Route<dynamic> route) => false);
        },
      );
    }
  }

  Widget showNewPasswordField() {
    return Container(
      child: Column(
        children: [
          AuthFormField(
            label: 'New Password',
            initialValue: newPassword,
            onChanged: (value) {
              newPassword = value as String;
            },
          ),
          // AuthFormField(label: 'Confirm Password'),
          RoundedButton(
            width: 150,
            child: Text('Change Password'),
            onPressed: () {
              changePassword();
            },
          )
        ],
      ),
    );
  }

  Widget showNewEmailField() {
    return Container(
      child: Column(
        children: [
          AuthFormField(
            label: 'New Email',
            initialValue: newEmail,
            onChanged: (value) {
              newEmail = value as String;
            },
          ),
          RoundedButton(
            width: 140,
            child: Text('Change Email'),
            onPressed: () {
              changeEmail();
            },
          )
        ],
      ),
    );
  }

  Future<dynamic> _showBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        height: 600,
        width: mediaQuery.size.width * 0.5,
        child: SizedBox(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter the OTP we sent to your email',
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
                    verifyOtp();
                  },
                  onChanged: (value) {
                    setState(() {
                      otp = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                  appContext: context,
                ),
                TextButton(
                  onPressed: () {
                    sendNewOtp();
                  },
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
          ),
        ),
      ),
    );
  }

  Future<void> _showAndroidDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Account Deletion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Are you sure you want to delete this account?'),
                TextField(
                  decoration: InputDecoration(hintText: 'Password'),
                  obscureText: true,
                  controller: passwordInputController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await deleteAccount();
              },
            ),
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showIosDialog(BuildContext context) async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Account Deletion'),
        content: Column(
          children: [
            Text('Are you sure you want to delete your account?'),
            CupertinoTextField(
              obscureText: true,
              placeholder: 'Password',
              controller: passwordInputController,
            ),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              await deleteAccount();
            },
            child: const Text('Delete'),
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
                      Text(userDetails['email']),
                      Wrap(
                        children: [
                          Text('Personal (Monthly)'),
                          SizedBox(
                            width: 2,
                          ),
                          Wrap(
                            children: [
                              Text(userDetails["cardSlots"].toString()),
                              Text(' cards'),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            if (pageState == PageState.normal)
              Column(
                children: [
                  SettingsButton(
                    label: 'Change Email',
                    icon: FontAwesomeIcons.envelope,
                    onPressed: () {
                      sendNewOtp();
                      _showBottomSheet(context);
                      requestedPageState = PageState.emailInput;
                    },
                  ),
                  SettingsButton(
                    label: 'Change Password',
                    icon: FontAwesomeIcons.lock,
                    onPressed: () {
                      sendNewOtp();
                      _showBottomSheet(context);
                      requestedPageState = PageState.passwordInput;
                    },
                  ),
                  SettingsButton(
                    label: 'Delete Account',
                    icon: FontAwesomeIcons.trash,
                    onPressed: () {
                      if (Platform.isIOS) {
                        _showIosDialog(context);
                      } else
                        _showAndroidDialog();
                    },
                  ),
                ],
              )
            else if (pageState == PageState.emailInput)
              showNewEmailField()
            else if (pageState == PageState.passwordInput)
              showNewPasswordField()
          ],
        ),
      ),
    );
  }
}
