import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_app/view_models/member_view_model.dart';
import 'package:spending_app/widgets/app_toaster.dart';
import 'package:spending_app/widgets/custom_button.dart';
import 'package:spending_app/widgets/custom_loading.dart';
import 'package:spending_app/widgets/custom_text_field.dart';

import '../../constants.dart';
import '../../exception.dart';
import '../../routes/navigation_services.dart';
import '../../routes/routes.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      image: DecorationImage(
                        image:
                            AssetImage(AssetPaths.imagePath.getLogoImagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        textCapitalization: TextCapitalization.none,
                        title: ConstantStrings.appString.email,
                        hint: ConstantStrings.appString.inputYourEmail,
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ConstantStrings
                                .appString.warningFillFullText;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        title: ConstantStrings.appString.password,
                        hint: ConstantStrings.appString.inputYourPassword,
                        controller: passwordController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ConstantStrings
                                .appString.warningFillFullText;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomButton(
                    width: double.infinity,
                    height: 48,
                    title: ConstantStrings.appString.signIn,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();

                        try {
                          showAppLoading(context);
                          await Provider.of<MemberViewModel>(context,
                              listen: false)
                              .signInWithEmail(email, password);
                          NavigationService().pop();
                          if (!mounted) return;
                          var currentUser = Provider.of<MemberViewModel>(
                              context,
                              listen: false).currentUser;
                          if (currentUser != null) {
                            User cred = Provider.of<MemberViewModel>(context,
                                listen: false).getUserCredential();
                            await cred.reload();
                            if (cred.emailVerified) {
                              NavigationService().pushNameAndRemoveUntil(ROUTER_MAIN);
                            } else {
                              NavigationService().pushNameAndRemoveUntil(ROUTER_VERIFY_EMAIL);
                            }
                            AppToaster.showToast(
                              context: context,
                              msg: ConstantStrings
                                  .appString.signInSuccessfully,
                              type: AppToasterType.success,
                            );
                          } else {
                            AppToaster.showToast(
                              context: context,
                              msg: ConstantStrings.appString.errorOccur,
                              type: AppToasterType.failed,
                            );
                          }
                        } catch (e) {
                          NavigationService().pop();
                          if (e is UserNotFoundAuthException) {
                            AppToaster.showToast(
                              context: context,
                              msg: ConstantStrings
                                  .appString.userOrPasswordNotCorrect,
                              type: AppToasterType.failed,
                            );
                          } else if (e is WrongPasswordAuthException) {
                            AppToaster.showToast(
                              context: context,
                              msg: ConstantStrings
                                  .appString.userOrPasswordNotCorrect,
                              type: AppToasterType.failed,
                            );
                          } else {
                            AppToaster.showToast(
                              context: context,
                              msg: ConstantStrings.appString.errorOccur,
                              type: AppToasterType.failed,
                            );
                          }
                        }
                      }
                    },
                  ),
                  // Container(
                  //   height: 48,
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     gradient: const LinearGradient(
                  //       begin: Alignment.topLeft,
                  //       end: Alignment.bottomRight,
                  //       // stops: [0.0, 1.0],
                  //       colors: [
                  //         AppColors.greenStartLinearColor,
                  //         AppColors.greenEndLinearColor,
                  //       ],
                  //     ),
                  //     borderRadius: BorderRadius.circular(4),
                  //   ),
                  //   child: ElevatedButton(
                  //     onPressed: () async {
                  //       if (_formKey.currentState!.validate()) {
                  //         String email = emailController.text.trim();
                  //         String password = passwordController.text.trim();
                  //
                  //         try {
                  //           await Provider.of<MemberViewModel>(context,
                  //                   listen: false)
                  //               .signInWithEmail(email, password);
                  //           if (!mounted) return;
                  //           var currentUser = Provider.of<MemberViewModel>(
                  //                   context,
                  //                   listen: false).currentUser;
                  //           if (currentUser != null) {
                  //             NavigationService().pushNameAndRemoveUntil(ROUTER_MAIN);
                  //             AppToaster.showToast(
                  //               context: context,
                  //               msg: ConstantStrings
                  //                   .appString.signInSuccessfully,
                  //               type: AppToasterType.success,
                  //             );
                  //           } else {
                  //             AppToaster.showToast(
                  //               context: context,
                  //               msg: ConstantStrings.appString.errorOccur,
                  //               type: AppToasterType.failed,
                  //             );
                  //           }
                  //         } catch (e) {
                  //           if (e is UserNotFoundAuthException) {
                  //             AppToaster.showToast(
                  //               context: context,
                  //               msg: ConstantStrings
                  //                   .appString.userOrPasswordNotCorrect,
                  //               type: AppToasterType.failed,
                  //             );
                  //           } else if (e is WrongPasswordAuthException) {
                  //             AppToaster.showToast(
                  //               context: context,
                  //               msg: ConstantStrings
                  //                   .appString.userOrPasswordNotCorrect,
                  //               type: AppToasterType.failed,
                  //             );
                  //           } else {
                  //             AppToaster.showToast(
                  //               context: context,
                  //               msg: ConstantStrings.appString.errorOccur,
                  //               type: AppToasterType.failed,
                  //             );
                  //           }
                  //         }
                  //       }
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.transparent,
                  //       shadowColor: Colors.transparent,
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(4),),
                  //     ),
                  //     child: Text(
                  //       ConstantStrings.appString.signIn,
                  //       style: const TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           color: AppColors.whiteColor),
                  //     ),
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ConstantStrings.appString.notHaveAccount,
                        style: const TextStyle(color: AppColors.whiteColor),
                      ),
                      TextButton(
                        onPressed: () {
                          NavigationService().pushNamed(ROUTER_SIGN_UP);
                        },
                        child: Text(
                          ConstantStrings.appString.signUpNow,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
