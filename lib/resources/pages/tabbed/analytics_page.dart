import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../../app/controllers/controller.dart';

class AnalyticsPage extends NyStatefulWidget {
  final Controller controller = Controller();
  AnalyticsPage({Key? key}) : super(key: key);

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends NyState<AnalyticsPage> {
  @override
  init() async {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 0.2,
              color: Color(0xFF455154),
            ),
          ),
        ),
        height: mediaQuery.size.height * 0.735,
        width: mediaQuery.size.width,
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        child: Center(
          child: Text(
            "We're working hard to get this Feature ready",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
