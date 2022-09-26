import 'package:nylo_framework/nylo_framework.dart';
import 'package:sailspad/resources/pages/onboarding_page.dart';
import 'package:sailspad/resources/pages/share_card_page.dart';

import 'package:sailspad/resources/pages/sign_up_page.dart';
import 'package:sailspad/resources/pages/tabbed/tabs_page.dart';

import '../resources/pages/sign_in_page.dart';

/*
|--------------------------------------------------------------------------
| App Router
|
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "flutter pub run nylo_framework:main make:page my_page"
| Learn more https://nylo.dev/docs/3.x/router
|--------------------------------------------------------------------------
*/

appRouter() => nyRoutes((router) {
      router.route(
        "/",
        (context) => OnboardingPage(),
        transition: PageTransitionType.fade,
      );
      router.route(
        "/tabs-page",
        (context) => TabsPage(),
        transition: PageTransitionType.fade,
      );
      router.route(
        "/share-card-page",
        (context) => ShareCardPage(),
        transition: PageTransitionType.fade,
      );
      router.route(
        "/sign-in-page",
        (context) => SignInPage(),
        transition: PageTransitionType.fade,
      );
      router.route(
        "/sign-up-page",
        (context) => SignUpPage(),
        transition: PageTransitionType.fade,
      );
    });
