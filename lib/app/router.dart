import 'package:go_router/go_router.dart';
import 'package:style_line/pages/auth/login_screen.dart';
import 'package:style_line/pages/auth/sign_up_verify.dart';
import 'package:style_line/pages/client/home_page.dart';
import 'package:style_line/pages/language/language_select_page.dart';
import 'package:style_line/pages/role_select/role_select.dart';
import 'package:style_line/services/db/cache.dart';

abstract class Routes {
  static const selsctLanguagePage = '/selsctLanguagePage';

  static const homePage = '/homePage';

  static const loginPage = '/homeScreen';
  static const verfySMS = '/verfySMS';

  static const roleSelectPage = '/roleSelectPage';

  static const clientHomePage = '/clientHomePage';


}

String _initialLocation() {
  return Routes.roleSelectPage;

  final userToken = cache.getString("user_token");

  if (userToken != null) {
    return Routes.homePage;
  }
  return Routes.selsctLanguagePage;
}

Object? _initialExtra() {
  return {};
}

final router = GoRouter(
  initialLocation: _initialLocation(),
  initialExtra: _initialExtra(),
  routes: [
    GoRoute(
      path: Routes.selsctLanguagePage,
      builder: (context, state) => const LanguageSelectionPage(),
    ),
    GoRoute(
      path: Routes.loginPage,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.verfySMS,
      builder: (context, state) {
        final phoneNumber = state.extra as String;
        return VerificationScreen(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      path: Routes.roleSelectPage,
      builder: (context, state) => RoleSelectionPage(),
    ),
    GoRoute(
      path: Routes.clientHomePage,
      builder: (context, state) => ClientHomePage(),
    ),
  ],
);
