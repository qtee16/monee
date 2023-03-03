import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spending_app/constants.dart';
import 'package:spending_app/models/member.dart';
import 'package:spending_app/routes/navigation_services.dart';
import 'package:spending_app/routes/routes.dart';
import 'package:spending_app/views/tab_screen/tabs/profile_tab/widgets/profile_tab_header.dart';
import 'package:spending_app/widgets/app_toaster.dart';
import 'package:spending_app/widgets/confirm_dialog.dart';
import 'package:spending_app/widgets/custom_button.dart';

import '../../../../view_models/member_view_model.dart';
import '../../../../widgets/member_avatar.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MemberViewModel>(
      builder: (context, model, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ProfileTabHeader(),
                    SizedBox(
                      height: 32.0,
                    ),
                  ],
                ),
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: model.getStreamCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!.data();
                    if (data != null) {
                      var user = Member.fromJson(data);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MemberAvatar(
                                  imageURL: user.imageURL,
                                  width: 160,
                                  height: 160,
                                  border: 80,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${user.lastName} ${user.firstName}",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          InkWell(
                            onTap: () {
                              NavigationService().pushNamed(
                                ROUTER_EDIT_USER_INFO,
                                arguments: {
                                  'user': user,
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: AppColors.whiteColor,
                                      width: 0.5,
                                    ),
                                    bottom: BorderSide(
                                      color: AppColors.whiteColor,
                                      width: 0.25,
                                    ),
                                  )),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ConstantStrings.appString.editInfo,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.whiteColor),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppColors.whiteColor,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              NavigationService().pushNamed(
                                ROUTER_CHANGE_PASSWORD,
                                arguments: {
                                  'user': user,
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: AppColors.whiteColor,
                                      width: 0.25,
                                    ),
                                    bottom: BorderSide(
                                      color: AppColors.whiteColor,
                                      width: 0.5,
                                    ),
                                  )),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ConstantStrings.appString.changePassword,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.whiteColor),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppColors.whiteColor,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: CustomButton(
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
                                    NavigationService().pushReplacementNamed(ROUTER_SIGN_IN);
                                    await model.signOut();
                                    AppToaster.showToast(
                                      context: context,
                                      msg: ConstantStrings
                                          .appString.signOutSuccessfully,
                                      type: AppToasterType.success,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  }
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!.withOpacity(0.6),
                            highlightColor: Colors.grey[100]!.withOpacity(0.6),
                            enabled: true,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(80),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!.withOpacity(0.6),
                            highlightColor: Colors.grey[100]!.withOpacity(0.6),
                            enabled: true,
                            child: Container(
                              width: 160,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
