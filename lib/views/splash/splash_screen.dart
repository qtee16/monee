import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_app/routes/routes.dart';
import 'package:spending_app/view_models/member_view_model.dart';

import '../../constants.dart';
import '../../routes/navigation_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var _startAnim = false;

  @override
  void initState() {
    super.initState();
    opacityAnim();
    var model = Provider.of<MemberViewModel>(context, listen: false);
    model.init();
    if (model.isSignIn) {
      Future.delayed(const Duration(seconds: 3)).then((value) async {
        User cred = Provider.of<MemberViewModel>(context,
            listen: false).getUserCredential();
        await cred.reload();
        if (cred.emailVerified) {
          NavigationService().pushNameAndRemoveUntil(ROUTER_MAIN);
        } else {
          NavigationService().pushNameAndRemoveUntil(ROUTER_VERIFY_EMAIL);
        }
      });
    } else {
      Future.delayed(const Duration(seconds: 3)).then((value) =>
          NavigationService().pushNameAndRemoveUntil(ROUTER_SIGN_IN));
    }

  }

  void opacityAnim() async {
    Future.delayed(const Duration(milliseconds: 300),).then((_) {
      setState(() {
        _startAnim = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetPaths.imagePath.getBackgroundImagePath),
                fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 2500),
                opacity: _startAnim ? 1.0 : 0.0,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: AssetImage(AssetPaths.imagePath.getLogoImagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 2500),
              opacity: _startAnim ? 1.0 : 0.0,
              child: Text(
                ConstantStrings.appString.appName,
                style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                    height: 32.0 / 24.0),
              ),
            ),
            const SizedBox(
              height: 32.0,
            )
          ],
        ),
      ),
    );
  }
}
