import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_app/utils/utils.dart';
import 'package:spending_app/view_models/member_info_view_model.dart';
import 'package:spending_app/widgets/app_toaster.dart';
import 'package:spending_app/widgets/confirm_dialog.dart';
import 'package:spending_app/widgets/custom_loading.dart';

import '../../constants.dart';
import '../../models/member.dart';
import '../../routes/navigation_services.dart';
import '../../view_models/member_view_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/general_header.dart';

class ChangePasswordScreen extends StatefulWidget {
  final Member user;

  const ChangePasswordScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController oldPassController;
  late TextEditingController newPassController;
  late TextEditingController confirmNewPassController;

  @override
  void initState() {
    oldPassController = TextEditingController();
    newPassController = TextEditingController();
    confirmNewPassController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    oldPassController.dispose();
    newPassController.dispose();
    confirmNewPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberViewModel>(
      builder: (context, model, child) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GeneralHeader(
                        title: ConstantStrings.appString.changePassword,
                        onTap: () {
                          NavigationService().pop();
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomTextField(
                        title: ConstantStrings.appString.oldPassword,
                        hint: ConstantStrings.appString.inputOldPassword,
                        controller: oldPassController,
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
                        title: ConstantStrings.appString.newPassword,
                        hint: ConstantStrings.appString.inputNewPassword,
                        controller: newPassController,
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
                        height: 40,
                      ),
                      CustomTextField(
                        title: ConstantStrings.appString.confirmNewPassword,
                        hint: ConstantStrings.appString.inputConfirmNewPassword,
                        controller: confirmNewPassController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ConstantStrings
                                .appString.warningFillFullText;
                          }
                          if (value != newPassController.text.trim()) {
                            return ConstantStrings
                                .appString.warningTheSamePassword;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomButton(
                        width: double.infinity,
                        height: 48,
                        title: ConstantStrings.appString.confirm,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            var currentHashPass = widget.user.hashPassword;
                            String oldPass = oldPassController.text.trim();
                            if (currentHashPass == encrypt(oldPass)) {
                              try {
                                String password = newPassController.text.trim();
                                showAppLoading(context);
                                await model.changePassword(password);
                                NavigationService().pop();
                                NavigationService().pop();
                                AppToaster.showToast(
                                  context: context,
                                  msg: ConstantStrings.appString.changePasswordSuccess,
                                  type: AppToasterType.success,
                                );
                              } catch (e) {
                                NavigationService().pop();
                                AppToaster.showToast(
                                  context: context,
                                  msg: ConstantStrings.appString.errorOccur,
                                  type: AppToasterType.failed,
                                );
                              }
                            } else {
                              AppToaster.showToast(
                                context: context,
                                msg: ConstantStrings.appString.wrongPassword,
                                type: AppToasterType.failed,
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
