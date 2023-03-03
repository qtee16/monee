import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spending_app/view_models/member_info_view_model.dart';
import 'package:spending_app/widgets/confirm_dialog.dart';
import 'package:spending_app/widgets/member_avatar.dart';

import '../../constants.dart';
import '../../models/member.dart';
import '../../routes/navigation_services.dart';
import '../../widgets/app_toaster.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loading.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/general_header.dart';
import '../../widgets/main_title_text.dart';

class EditUserInfoScreen extends StatefulWidget {
  final Member user;

  const EditUserInfoScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<EditUserInfoScreen> createState() => _EditUserInfoScreenState();
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberInfoViewModel>(
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            if (model.imageFile != null ||
                model.firstName != null ||
                model.lastName != null) {
              showConfirmDialog(
                context: context,
                title: ConstantStrings.appString.wantToExit,
                content: ConstantStrings.appString.wantToExitContent,
                onConfirm: () {
                  model.reset();
                  NavigationService().pop();
                  return true;
                },
                onCancel: () {
                  return false;
                }
              );
            }
            return true;
          },
          child: Container(
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
                          title: ConstantStrings.appString.editInfo,
                          onTap: () {
                            if (model.imageFile != null ||
                                model.firstName != null ||
                                model.lastName != null) {
                              showConfirmDialog(
                                  context: context,
                                  title: ConstantStrings.appString.wantToExit,
                                  content: ConstantStrings.appString.wantToExitContent,
                                  onConfirm: () {
                                    model.reset();
                                    NavigationService().pop();
                                  },
                              );
                            } else {
                              NavigationService().pop();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        MainTitleText(
                            title: ConstantStrings.appString.selectAvatar),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              model.imageFile == null
                                  ? MemberAvatar(
                                      imageURL: widget.user.imageURL,
                                      width: 160,
                                      height: 160,
                                      border: 80,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(80),
                                      child: Image.file(
                                        model.imageFile!,
                                        width: 160,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () async {
                                    try {
                                      await model.selectImage();
                                    } on PlatformException catch (e) {
                                      if (e.code ==
                                          'read_external_storage_denied') {
                                        AppToaster.showToast(
                                          context: context,
                                          msg: ConstantStrings
                                              .appString.needAcceptReadRule,
                                          type: AppToasterType.warning,
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white.withOpacity(0.4),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          title: ConstantStrings.appString.lastName,
                          hint: ConstantStrings.appString.inputLastName,
                          controller: lastNameController,
                          onChanged: (value) {
                            model.changeLastName(value);
                          },
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
                          onChanged: (value) {
                            model.changeFirstName(value);
                          },
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
                        CustomButton(
                          width: double.infinity,
                          height: 48,
                          title: ConstantStrings.appString.confirm,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              if (model.imageFile == null &&
                                  model.firstName == null &&
                                  model.lastName == null) {
                                AppToaster.showToast(
                                  context: context,
                                  msg: ConstantStrings
                                      .appString.notChangedInfoYet,
                                  type: AppToasterType.warning,
                                );
                              } else {
                                showAppLoading(context);
                                await model.updateMemberInfo(widget.user.id);
                                NavigationService().pop();
                                AppToaster.showToast(
                                  context: context,
                                  msg: ConstantStrings
                                      .appString.editGroupInfoSuccess,
                                  type: AppToasterType.success,
                                );
                                NavigationService().pop();
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
          ),
        );
      },
    );
  }
}
