import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spending_app/widgets/cached_image_widget.dart';

import '../../constants.dart';
import '../../models/group.dart';
import '../../routes/navigation_services.dart';
import '../../view_models/group_info_view_model.dart';
import '../../widgets/app_toaster.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loading.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/general_header.dart';
import '../../widgets/main_title_text.dart';

class EditGroupInfoScreen extends StatefulWidget {
  final Group group;

  const EditGroupInfoScreen({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  State<EditGroupInfoScreen> createState() => _EditGroupInfoScreenState();
}

class _EditGroupInfoScreenState extends State<EditGroupInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final groupNameController = TextEditingController();

  @override
  void initState() {
    groupNameController.text = widget.group.name;
    super.initState();
  }

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
                              model.imageFile == null
                                  ? CachedImageWidget(
                                      imageURL: widget.group.imageURL,
                                      width: 160,
                                      height: 160,
                                      border: 12,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
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
                                          msg: ConstantStrings.appString.needAcceptReadRule,
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
                          onChanged: (value) {
                            model.changeName(value);
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
                                  model.name == null) {
                                AppToaster.showToast(
                                  context: context,
                                  msg: ConstantStrings
                                      .appString.notChangedInfoYet,
                                  type: AppToasterType.warning,
                                );
                              } else {
                                showAppLoading(context);
                                await model.updateGroupInfo(widget.group.id);
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
