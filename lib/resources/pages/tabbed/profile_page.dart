import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../../app/controllers/controller.dart';

class ProfilePage extends NyStatefulWidget {
  final Controller controller = Controller();
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends NyState<ProfilePage> {
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
