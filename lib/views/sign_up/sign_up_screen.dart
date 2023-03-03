import 'package:flutter/material.dart';
import 'package:spending_app/routes/navigation_services.dart';
import 'package:spending_app/routes/routes.dart';
import 'package:spending_app/view_models/member_view_model.dart';
import 'package:spending_app/widgets/custom_button.dart';
import 'package:spending_app/widgets/custom_loading.dart';
import 'package:spending_app/widgets/custom_text_field.dart';
import 'package:spending_app/widgets/general_header.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../exception.dart';
import '../../widgets/app_toaster.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                  GeneralHeader(title: ConstantStrings.appString.signUp, onTap: () {
                    NavigationService().pop();
                  },),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        title: ConstantStrings.appString.lastName,
                        hint: ConstantStrings.appString.inputLastName,
                        controller: lastNameController,
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
                        title: ConstantStrings.appString.firstName,
                        hint: ConstantStrings.appString.inputFirstName,
                        controller: firstNameController,
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
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        title: ConstantStrings.appString.confirmPassword,
                        hint: ConstantStrings.appString.inputConfirmPassword,
                        controller: confirmPasswordController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ConstantStrings
                                .appString.warningFillFullText;
                          }
                          if (value != passwordController.text.trim()) {
                            return ConstantStrings
                                .appString.warningTheSamePassword;
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
                    title: ConstantStrings.appString.signUp,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        String firstName = firstNameController.text.trim();
                        String lastName = lastNameController.text.trim();
                        String email = emailController.text.trim();
                        String password = passwordController.text.trim();

                        try {
                          showAppLoading(context);
                          var currentUser = await Provider.of<MemberViewModel>(
                                  context,
                                  listen: false)
                              .signUpWithEmail(
                                  firstName, lastName, email, password);
                          NavigationService().pop();
                          if (currentUser != null) {
                            if (!mounted) return;
                            NavigationService().pushNamed(ROUTER_VERIFY_EMAIL);
                            AppToaster.showToast(
                              context: context,
                              msg: ConstantStrings.appString.signUpSuccessfully,
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
                          if (e is WeakPasswordAuthException) {
                            AppToaster.showToast(
                              context: context,
                              msg: ConstantStrings.appString.weakPassword,
                              type: AppToasterType.failed,
                            );
                          } else if (e is EmailAlreadyInUseAuthException) {
                            AppToaster.showToast(
                              context: context,
                              msg: ConstantStrings.appString.emailAlreadyInUse,
                              type: AppToasterType.failed,
                            );
                          } else if (e is InvalidEmailAuthException) {
                            AppToaster.showToast(
                              context: context,
                              msg: ConstantStrings.appString.invalidEmail,
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
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
