import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spending_app/routes/navigation_services.dart';
import 'package:spending_app/view_models/group_view_model.dart';
import 'package:spending_app/view_models/member_view_model.dart';
import 'package:spending_app/widgets/app_toaster.dart';
import 'package:spending_app/widgets/card_item.dart';
import 'package:spending_app/widgets/confirm_dialog.dart';
import 'package:spending_app/widgets/custom_button.dart';
import 'package:spending_app/widgets/custom_loading.dart';
import 'package:spending_app/widgets/empty_screen.dart';

import '../../constants.dart';
import '../../models/group.dart';
import '../../models/member.dart';
import '../../widgets/general_header.dart';

class RequestListScreen extends StatefulWidget {
  final Group group;

  const RequestListScreen({Key? key, required this.group}) : super(key: key);

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
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
            child: Consumer<GroupViewModel>(
              builder: (context, model, child) {
                return Column(
                  children: [
                    GeneralHeader(
                      title: ConstantStrings.appString.requestsList,
                      onTap: () {
                        NavigationService().pop();
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    StreamBuilder<Group>(
                      stream: model.getStreamGroupById(widget.group.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var group = snapshot.data!;
                          return group.requestsIdList.isNotEmpty
                              ? Column(
                                  children: [
                                    CustomButton(
                                      width: double.infinity,
                                      height: 48,
                                      title:
                                          ConstantStrings.appString.acceptAll,
                                      onTap: () {
                                        showConfirmDialog(
                                          context: context,
                                          title: ConstantStrings
                                              .appString.acceptAll,
                                          content: ConstantStrings
                                              .appString.confirmAcceptAll,
                                          onConfirm: () async {
                                            showAppLoading(context);
                                            await model.acceptAllRequest(
                                                group.requestsIdList,
                                                group.id);
                                            NavigationService().pop();
                                            AppToaster.showToast(
                                              context: context,
                                              msg: ConstantStrings
                                                  .appString.acceptSuccess,
                                              type: AppToasterType.success,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    CustomButton(
                                      isConfirm: false,
                                      width: double.infinity,
                                      height: 48,
                                      title:
                                          ConstantStrings.appString.deleteAll,
                                      onTap: () {
                                        showConfirmDialog(
                                          context: context,
                                          title: ConstantStrings
                                              .appString.deleteAll,
                                          content: ConstantStrings
                                              .appString.confirmDeleteAll,
                                          onConfirm: () async {
                                            showAppLoading(context);
                                            await model.removeAllRequest(
                                                group.requestsIdList,
                                                group.id);
                                            NavigationService().pop();
                                            AppToaster.showToast(
                                              context: context,
                                              msg: ConstantStrings
                                                  .appString.deleteSuccess,
                                              type: AppToasterType.success,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 32,
                                    ),
                                    FutureBuilder<List<Member>>(
                                      future: Provider.of<MemberViewModel>(
                                              context,
                                              listen: false)
                                          .getAllUsersByIdsList(
                                              group.requestsIdList),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var members = snapshot.data!;
                                          return Column(
                                            children: List.generate(
                                                members.length, (index) {
                                              var member = members[index];
                                              return Column(
                                                children: [
                                                  CardItem(
                                                    imageURL: member.imageURL,
                                                    title: member.firstName,
                                                    isUserAvatar: true,
                                                    trailing: Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            showConfirmDialog(
                                                              context: context,
                                                              title:
                                                                  ConstantStrings
                                                                      .appString
                                                                      .accept,
                                                              content:
                                                                  ConstantStrings
                                                                      .appString
                                                                      .confirmAccept,
                                                              onConfirm:
                                                                  () async {
                                                                showAppLoading(
                                                                    context);
                                                                await model
                                                                    .acceptRequestToJoinGroup(
                                                                  member.id,
                                                                  widget
                                                                      .group.id,
                                                                );
                                                                NavigationService()
                                                                    .pop();
                                                                AppToaster
                                                                    .showToast(
                                                                  context:
                                                                      context,
                                                                  msg: ConstantStrings
                                                                      .appString
                                                                      .acceptSuccess,
                                                                  type: AppToasterType
                                                                      .success,
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            width: 36,
                                                            height: 36,
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  const LinearGradient(
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                                // stops: [0.0, 1.0],
                                                                colors: [
                                                                  AppColors
                                                                      .greenStartLinearColor,
                                                                  AppColors
                                                                      .greenEndLinearColor,
                                                                ],
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                            child: const Icon(
                                                              Icons.check,
                                                              color: AppColors
                                                                  .whiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 16,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            showConfirmDialog(
                                                              context: context,
                                                              title:
                                                                  ConstantStrings
                                                                      .appString
                                                                      .delete,
                                                              content:
                                                                  ConstantStrings
                                                                      .appString
                                                                      .confirmDelete,
                                                              onConfirm:
                                                                  () async {
                                                                showAppLoading(
                                                                    context);
                                                                await model
                                                                    .deleteRequestToJoinGroup(
                                                                  widget
                                                                      .group.id,
                                                                  userId:
                                                                      member.id,
                                                                );
                                                                NavigationService()
                                                                    .pop();
                                                                AppToaster
                                                                    .showToast(
                                                                  context:
                                                                      context,
                                                                  msg: ConstantStrings
                                                                      .appString
                                                                      .deleteSuccess,
                                                                  type: AppToasterType
                                                                      .success,
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Container(
                                                            width: 36,
                                                            height: 36,
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  const LinearGradient(
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                                // stops: [0.0, 1.0],
                                                                colors: [
                                                                  AppColors
                                                                      .redStartLinearColor,
                                                                  AppColors
                                                                      .redEndLinearColor,
                                                                ],
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                            child: const Icon(
                                                              Icons.delete,
                                                              color: AppColors
                                                                  .whiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              );
                                            }),
                                          );
                                        } else {
                                          return Column(
                                            children: List.generate(
                                              3,
                                              (index) {
                                                return Column(
                                                  children: [
                                                    Shimmer.fromColors(
                                                      baseColor: Colors
                                                          .grey[300]!
                                                          .withOpacity(0.6),
                                                      highlightColor: Colors
                                                          .grey[100]!
                                                          .withOpacity(0.6),
                                                      enabled: true,
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 70,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                )
                              : EmptyScreen(
                                  title: ConstantStrings.appString.noRequest,
                                );
                        } else {
                          return Column(
                            children: List.generate(
                              3,
                              (index) {
                                return Column(
                                  children: [
                                    Shimmer.fromColors(
                                      baseColor:
                                          Colors.grey[300]!.withOpacity(0.6),
                                      highlightColor:
                                          Colors.grey[100]!.withOpacity(0.6),
                                      enabled: true,
                                      child: Container(
                                        width: double.infinity,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
