import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spending_app/constants.dart';
import 'package:spending_app/exception.dart';
import 'package:spending_app/routes/navigation_services.dart';
import 'package:spending_app/view_models/group_info_view_model.dart';
import 'package:spending_app/widgets/app_toaster.dart';
import 'package:spending_app/widgets/custom_button.dart';
import 'package:spending_app/widgets/custom_loading.dart';
import 'package:spending_app/widgets/custom_text_field.dart';
import 'package:spending_app/widgets/general_header.dart';
import 'package:spending_app/widgets/main_title_text.dart';

import '../../widgets/confirm_dialog.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();

  final groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupInfoViewModel>(
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async {
            if (model.imageFile != null ||
                model.name != null) {
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
                          title: ConstantStrings.appString.createNewGroup,
                          onTap: () {
                            if (model.imageFile != null ||
                                model.name != null) {
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
                          height: 80,
                        ),
                        MainTitleText(
                            title: ConstantStrings.appString.addGroupAvatar),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: model.imageFile == null
                                    ? Image.asset(
                                  AssetPaths
                                      .imagePath.getDefaultLoadingImagePath,
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                )
                                    : Image.file(
                                  model.imageFile!,
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 60,
                                left: 60,
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
                          title: ConstantStrings.appString.groupName,
                          hint: ConstantStrings.appString.inputGroupName,
                          controller: groupNameController,
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
                              try {
                                String groupName =
                                groupNameController.text.trim();
                                showAppLoading(context);
                                await model.createNewGroup(groupName);
                                NavigationService().pop();
                                model.reset();
                                AppToaster.showToast(
                                  context: context,
                                  msg: ConstantStrings
                                      .appString.createNewGroupSuccessfully,
                                  type: AppToasterType.success,
                                );
                                NavigationService().pop();
                              } catch (e) {
                                if (e is ImageNullException) {
                                  AppToaster.showToast(
                                    context: context,
                                    msg: ConstantStrings
                                        .appString.warningPickGroupImage,
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
