import 'package:flutter/material.dart';
import 'package:spending_app/models/expense.dart';
import 'package:spending_app/models/member.dart';
import 'package:spending_app/routes/routes.dart';
import 'package:spending_app/views/create_group/create_group_screen.dart';
import 'package:spending_app/views/group/create_or_update_expense_screen.dart';
import 'package:spending_app/views/group/edit_group_info_screen.dart';
import 'package:spending_app/views/group/expense_detail_screen.dart';
import 'package:spending_app/views/group/group_screen.dart';
import 'package:spending_app/views/group/manage_member_screen.dart';
import 'package:spending_app/views/group/request_list_screen.dart';
import 'package:spending_app/views/profile/change_password_screen.dart';
import 'package:spending_app/views/profile/edit_user_info_screen.dart';
import 'package:spending_app/views/tab_screen/tab_screen.dart';
import 'package:spending_app/views/verify_email/verify_email_screen.dart';

import '../models/group.dart';
import '../views/sign_in/sign_in_screen.dart';
import '../views/sign_up/sign_up_screen.dart';
import '../views/splash/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  Map<String, dynamic>? arguments =
      settings.arguments as Map<String, dynamic>? ?? {};
  switch (settings.name) {
    case ROUTER_SPLASH:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const SplashScreen(),
      );
    case ROUTER_SIGN_IN:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const SignInScreen(),
      );
    case ROUTER_SIGN_UP:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const SignUpScreen(),
      );
    case ROUTER_MAIN:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const TabScreen(),
      );
    case ROUTER_CREATE_GROUP:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const CreateGroupScreen(),
      );
    case ROUTER_GROUP:
      Group group = arguments['group'];
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: GroupScreen(group: group),
      );
    case ROUTER_REQUESTS_LIST:
      Group group = arguments['group'];
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: RequestListScreen(group: group),
      );
    case ROUTER_MANAGE_MEMBER:
      Group group = arguments['group'];
      String currentUserId = arguments['currentUserId'];
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: ManageMemberScreen(group: group, currentUserId: currentUserId,),
      );
    case ROUTER_EDIT_GROUP_INFO:
      Group group = arguments['group'];
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: EditGroupInfoScreen(group: group,),
      );
    case ROUTER_EDIT_USER_INFO:
      Member user = arguments['user'];
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: EditUserInfoScreen(user: user,),
      );
    case ROUTER_CREATE_EXPENSE:
      Group group = arguments['group'];
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: CreateOrUpdateExpenseScreen(group: group,),
      );
    case ROUTER_EXPENSE_DETAIL:
      Expense expense = arguments['expense'];
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: ExpenseDetailScreen(expense: expense,),
      );
    case ROUTER_UPDATE_EXPENSE:
      Group group = arguments['group'];
      Expense expense = arguments['expense'];
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: CreateOrUpdateExpenseScreen(group: group, expense: expense,),
      );
    case ROUTER_CHANGE_PASSWORD:
      Member user = arguments['user'];
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: ChangePasswordScreen(user: user,),
      );
    case ROUTER_VERIFY_EMAIL:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: const VerifyEmailScreen(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute(
    {required String routeName,
    required Widget viewToShow,
    bool animation = true,
    bool scale = false}) {
  RouteSettings _settings = RouteSettings(
    name: routeName,
  );
  animation = true;
  if (animation) {
    return PageRouteBuilder(
      settings: _settings,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => viewToShow,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (scale) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        }
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;

        var tween = Tween(begin: begin, end: end);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.ease,
        );
        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
  return MaterialPageRoute(settings: _settings, builder: (_) => viewToShow);
}
