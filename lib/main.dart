import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:spending_app/routes/navigation_services.dart';
import 'package:spending_app/routes/root_router.dart';
import 'package:spending_app/routes/routes.dart';
import 'package:spending_app/view_models/expense_view_model.dart';
import 'package:spending_app/view_models/group_info_view_model.dart';
import 'package:spending_app/view_models/group_view_model.dart';
import 'package:spending_app/view_models/member_info_view_model.dart';
import 'package:spending_app/view_models/member_view_model.dart';
import 'package:spending_app/view_models/personal_statistic_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    final NavigationService navigationService = NavigationService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MemberViewModel()),
        ChangeNotifierProvider(create: (_) => GroupInfoViewModel()),
        ChangeNotifierProvider(create: (_) => GroupViewModel()),
        ChangeNotifierProvider(create: (_) => MemberInfoViewModel()),
        ChangeNotifierProvider(create: (_) => ExpenseViewModel()),
        ChangeNotifierProvider(create: (_) => PersonalStatisticViewModel()),
      ],
      child: OKToast(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Monee',
          theme: ThemeData.light().copyWith(
              useMaterial3: true, textTheme: GoogleFonts.montserratTextTheme()),
          navigatorKey: navigationService.navigationKey,
          onGenerateRoute: generateRoute,
          initialRoute: ROUTER_SPLASH,
        ),
      ),
    );
  }
}
