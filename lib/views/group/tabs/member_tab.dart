import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spending_app/constants.dart';
import 'package:spending_app/exception.dart';
import 'package:spending_app/models/member.dart';
import 'package:spending_app/routes/navigation_services.dart';
import 'package:spending_app/routes/routes.dart';
import 'package:spending_app/view_models/group_view_model.dart';
import 'package:spending_app/view_models/member_view_model.dart';
import 'package:spending_app/widgets/app_toaster.dart';
import 'package:spending_app/widgets/confirm_dialog.dart';
import 'package:spending_app/widgets/custom_loading.dart';
import 'package:spending_app/widgets/member_avatar.dart';
import 'package:spending_app/widgets/shimmer_loading.dart';

import '../../../models/group.dart';

class MemberTab extends StatefulWidget {
  final Group group;

  const MemberTab({Key? key, required this.group}) : super(key: key);

  @override
  State<MemberTab> createState() => _MemberTabState();
}

class _MemberTabState extends State<MemberTab> {
  @override
  Widget build(BuildContext context) {
    var userId =
        Provider.of<MemberViewModel>(context, listen: false).currentUser!.id;


    return Consumer<GroupViewModel>(
      builder: (context, model, child) {
        return StreamBuilder<Group>(
          stream: model.getStreamGroupById(widget.group.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var group = snapshot.data!;
              bool isOwnerGroup = group.ownersIdList.contains(userId);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: Text(
                              ConstantStrings.appString.member,
                              style: const TextStyle(
                                fontSize: 20,
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 0,
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Wrap(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await Clipboard.setData(
                                                  ClipboardData(
                                                      text: group.id));
                                              NavigationService().pop();
                                              AppToaster.showToast(
                                                context: context,
                                                msg: ConstantStrings.appString
                                                    .copyGroupCodeSuccess,
                                                type: AppToasterType.success,
                                              );
                                            },
                                            child: ListTile(
                                              leading: const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 2.0),
                                                child: Icon(
                                                  Icons.copy,
                                                  size: 24,
                                                ),
                                              ),
                                              title: Text(ConstantStrings
                                                  .appString.copyGroupCode),
                                            ),
                                          ),
                                          isOwnerGroup
                                              ? Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        NavigationService()
                                                            .pop();
                                                        NavigationService()
                                                            .pushNamed(
                                                          ROUTER_EDIT_GROUP_INFO,
                                                          arguments: {
                                                            'group': group,
                                                          },
                                                        );
                                                      },
                                                      child: ListTile(
                                                        leading: const Icon(
                                                            Icons.edit),
                                                        title: Text(
                                                            ConstantStrings
                                                                .appString
                                                                .editGroupInfo),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        NavigationService()
                                                            .pop();
                                                        NavigationService()
                                                            .pushNamed(
                                                          ROUTER_MANAGE_MEMBER,
                                                          arguments: {
                                                            'group':
                                                                widget.group,
                                                            'currentUserId':
                                                                userId,
                                                          },
                                                        );
                                                      },
                                                      child: ListTile(
                                                        leading: const Icon(
                                                            Icons.groups),
                                                        title: Text(
                                                            ConstantStrings
                                                                .appString
                                                                .manageMember),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        NavigationService()
                                                            .pop();
                                                        NavigationService()
                                                            .pushNamed(
                                                                ROUTER_REQUESTS_LIST,
                                                                arguments: {
                                                              'group':
                                                                  widget.group,
                                                            });
                                                      },
                                                      child: ListTile(
                                                        leading: const Icon(
                                                            Icons.watch_later),
                                                        title: Row(
                                                          children: [
                                                            Text(ConstantStrings
                                                                .appString
                                                                .requestsList),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            group.requestsIdList
                                                                    .isNotEmpty
                                                                ? Container(
                                                                    width: 8,
                                                                    height: 8,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                4),
                                                                        color: Colors
                                                                            .red),
                                                                  )
                                                                : const SizedBox()
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        showConfirmDialog(
                                                          context: context,
                                                          title: ConstantStrings.appString.deleteGroup,
                                                          content: ConstantStrings.appString.confirmDeleteGroup,
                                                          onConfirm: () async {
                                                            showAppLoading(context);
                                                            try {
                                                              await model.deleteGroup(group.id);
                                                              NavigationService().pop();
                                                              NavigationService().pop();
                                                              NavigationService().pop();
                                                              AppToaster.showToast(
                                                                context: context,
                                                                msg: ConstantStrings
                                                                    .appString.outGroupSuccess,
                                                                type: AppToasterType.success,
                                                              );
                                                            } catch(e) {
                                                              NavigationService().pop();
                                                              NavigationService().pop();
                                                              AppToaster.showToast(
                                                                context: context,
                                                                msg: ConstantStrings
                                                                    .appString.errorOccur,
                                                                type: AppToasterType.failed,
                                                              );
                                                            }
                                                          },
                                                        );
                                                      },
                                                      child: ListTile(
                                                        leading: const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 2.0),
                                                          child: Icon(
                                                              Icons.delete),
                                                        ),
                                                        title: Text(
                                                            ConstantStrings
                                                                .appString
                                                                .deleteGroup),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                          InkWell(
                                            onTap: () {
                                              showConfirmDialog(
                                                context: context,
                                                title: ConstantStrings.appString.outGroup,
                                                content: ConstantStrings.appString.confirmOutGroup,
                                                onConfirm: () async {
                                                  showAppLoading(context);
                                                  try {
                                                    await model.removeMemberFromGroup(group.id);
                                                    NavigationService().pop();
                                                    NavigationService().pop();
                                                    NavigationService().pop();
                                                    AppToaster.showToast(
                                                      context: context,
                                                      msg: ConstantStrings
                                                          .appString.outGroupSuccess,
                                                      type: AppToasterType.success,
                                                    );
                                                  } catch(e) {
                                                    NavigationService().pop();
                                                    NavigationService().pop();
                                                    if (e is YouAreOnlyOwnerOfGroupException) {
                                                      AppToaster.showToast(
                                                        context: context,
                                                        msg: ConstantStrings
                                                            .appString.youAreOnlyOwnerGroup,
                                                        type: AppToasterType.failed,
                                                      );
                                                    } else {
                                                      AppToaster.showToast(
                                                        context: context,
                                                        msg: ConstantStrings
                                                            .appString.errorOccur,
                                                        type: AppToasterType.failed,
                                                      );
                                                    }
                                                  }
                                                },
                                              );
                                            },
                                            child: ListTile(
                                              leading: const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 2.0),
                                                child: Icon(
                                                  Icons.output,
                                                  size: 24,
                                                ),
                                              ),
                                              title: Text(ConstantStrings
                                                  .appString.outGroup),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.settings,
                                  color: AppColors.whiteColor,
                                  size: 28,
                                ),
                              ),
                              Positioned(
                                right: 2,
                                bottom: 2,
                                child: (isOwnerGroup &&
                                        group.requestsIdList.isNotEmpty)
                                    ? Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Colors.red),
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: FutureBuilder<List<Member>>(
                        future:
                            Provider.of<MemberViewModel>(context, listen: false)
                                .getAllUsersByIdsList(group.membersIdList),
                        builder: (context, snapshot) {
                          double width = MediaQuery.of(context).size.width;
                          double sizeOfItem = width / 2 - 36;
                          if (snapshot.hasData) {
                            List<Member> members = snapshot.data!;
                            return GridView(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 40,
                                crossAxisSpacing: 40,
                                childAspectRatio: 0.75,
                              ),
                              children: List.generate(members.length, (index) {
                                var member = members[index];
                                var isOwnerGroup = widget.group.ownersIdList
                                    .contains(member.id);
                                return Column(
                                  children: [
                                    MemberAvatar(
                                      imageURL: members[index].imageURL,
                                      width: sizeOfItem,
                                      height: sizeOfItem,
                                      border: sizeOfItem / 2,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          member.firstName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        isOwnerGroup
                                            ? Image.asset(
                                                AssetPaths
                                                    .iconPath.getCrownIconPath,
                                                width: 20,
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                            );
                          } else {
                            return GridView(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 40,
                                crossAxisSpacing: 40,
                                childAspectRatio: 0.75,
                              ),
                              children: List.generate(6, (index) => Column(
                                children: [
                                  ShimmerLoading(width: sizeOfItem, height: sizeOfItem, border: sizeOfItem/2),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ShimmerLoading(width: sizeOfItem, height: 30, border: 8),
                                ],
                              )),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        );
      },
    );
  }
}
