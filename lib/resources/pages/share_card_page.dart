import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../app/controllers/controller.dart';

class ShareCardPage extends NyStatefulWidget {
  final Controller controller = Controller();
  ShareCardPage({Key? key}) : super(key: key);

  @override
  _ShareCardPageState createState() => _ShareCardPageState();
}

class _ShareCardPageState extends NyState<ShareCardPage> {
  @override
  init() async {
    print(widget.data());
  }

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
