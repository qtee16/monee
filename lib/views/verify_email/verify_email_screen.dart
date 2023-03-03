import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_app/view_models/member_view_model.dart';
import 'package:spending_app/views/verify_email/widgets/verify_email_header.dart';
import 'package:spending_app/widgets/app_toaster.dart';
import 'package:spending_app/widgets/custom_button.dart';
import 'package:spending_app/widgets/custom_loading.dart';
import 'package:spending_app/widgets/custom_text_field.dart';

import '../../constants.dart';
import '../../exception.dart';
import '../../routes/navigation_services.dart';
import '../../routes/routes.dart';
import '../../widgets/confirm_dialog.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  void initState() {
    Provider.of<MemberViewModel>(context, listen: false)
        .getUserCredential()
        .sendEmailVerification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetPaths.imagePath.getBackgroundImagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const VerifyEmailHeader(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  ConstantStrings.appString.contentVerify,
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 40,
                ),
                CustomButton(
                  isConfirm: false,
                  width: double.infinity,
                  height: 48,
                  title: ConstantStrings.appString.signOut,
                  onTap: () {
                    showConfirmDialog(
                      context: context,
                      title: ConstantStrings.appString.signOut,
                      content: ConstantStrings.appString.confirmSignOut,
                      onConfirm: () async {
                        NavigationService()
                            .pushReplacementNamed(ROUTER_SIGN_IN);
                        await Provider.of<MemberViewModel>(context,
                                listen: false)
                            .signOut();
                        AppToaster.showToast(
                          context: context,
                          msg: ConstantStrings.appString.signOutSuccessfully,
                          type: AppToasterType.success,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
