import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../../../app/controllers/controller.dart';

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
      appBar: AppBar(),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
