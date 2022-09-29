import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bootstrap/app.dart';

import 'bootstrap/boot.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Nylo nylo = await Nylo.init(setup: Boot.nylo, setupFinished: Boot.finished);
  String? userToken = await NyStorage.read('user_token');
  await Permission.camera.request();
  runApp(
    AppBuild(
      navigatorKey: NyNavigator.instance.router.navigatorKey,
      onGenerateRoute: nylo.router!.generator(),
      debugShowCheckedModeBanner: false,
      initialRoute: userToken != null ? '/tabs-page' : '/',
    ),
  );
  FlutterNativeSplash.remove();
}
