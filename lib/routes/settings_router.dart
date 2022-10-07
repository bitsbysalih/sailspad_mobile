import 'package:nylo_framework/nylo_framework.dart';
import 'package:sailspad/resources/pages/settings/security_settings_page.dart';
import 'package:sailspad/resources/pages/settings/settings_page.dart';

import '../resources/pages/settings/subscription_settings_page.dart';

NyRouter settingsRouter() => nyRoutes(
      (router) {
        router.route("/settings-page", (context) => SettingsPage());
        router.route(
            "/settings-page/security", (context) => SecuritySettingsPage());
        router.route("/settings-page/subscription",
            (context) => SubscriptionSettingsPage());
      },
    );
