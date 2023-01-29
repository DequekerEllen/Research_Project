import 'package:flutter_app/presentation/splash_screen/splash_screen.dart';
import 'package:flutter_app/presentation/home_screen/home_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static String splashScreen = '/splash_screen';

  static String homeScreen = '/home_screen';

  static String initialRoute = '/initialRoute';

  static List<GetPage> pages = [
    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: initialRoute,
      page: () => SplashScreen(),
    )
  ];
}
