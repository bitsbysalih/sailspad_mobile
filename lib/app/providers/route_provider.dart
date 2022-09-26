import '../../routes/router.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../../routes/settings_router.dart';

class RouteProvider implements NyProvider {
  @override
  boot(Nylo nylo) async {
    nylo.addRouter(appRouter());
    nylo.addRouter(settingsRouter());
    return nylo;
  }
}
