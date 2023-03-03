import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spending_app/exception.dart';
import 'package:spending_app/routes/navigation_services.dart';
import 'package:spending_app/view_models/group_view_model.dart';
import 'package:spending_app/view_models/member_view_model.dart';
import 'package:spending_app/widgets/app_toaster.dart';
import 'package:spending_app/widgets/card_item.dart';
import 'package:spending_app/widgets/confirm_dialog.dart';
import 'package:spending_app/widgets/custom_loading.dart';

import '../../constants.dart';
import '../../models/group.dart';
import '../../models/member.dart';
import '../../widgets/general_header.dart';

class ManageMemberScreen extends StatefulWidget {
  final Group group;
  final String currentUserId;

  const ManageMemberScreen({Key? key, required this.group, required this.currentUserId}) : super(key: key);

  @override
  State<ManageMemberScreen> createState() => _ManageMemberScreenState();
}

class _ManageMemberScreenState extends State<ManageMemberScreen> {
  @override
  Widget build(BuildContext context) {

    var currentUserId =
        Provider.of<MemberViewModel>(context, listen: false).currentUser!.id;


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
                        title: ConstantStrings.appString.manageMember, onTap: () {
                          NavigationService().pop();
                    },),
                    const SizedBox(
                      height: 40,
                    ),
                    StreamBuilder<Group>(
                      stream: model.getStreamGroupById(widget.group.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var group = snapshot.data!;
                          return FutureBuilder<List<Member>>(
                            future: Provider.of<MemberViewModel>(context,
                                listen: false)
                                .getAllUsersByIdsList(group.membersIdList),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var members = snapshot.data!;
                                return Column(
                                  children:
                                  List.generate(members.length, (index) {
                                    var member = members[index];
                                    bool isOwnerGroup = group.ownersIdList.contains(member.id);
                                    bool isYourItem = currentUserId == member.id;
                                    return Column(
                                      children: [
                                        CardItem(
                                          imageURL: member.imageURL,
                                          title: member.firstName,
                                          isUserAvatar: true,
                                          trailing: (isOwnerGroup && !isYourItem)
                                              ? const SizedBox()
                                              : InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (subContext) {
                                                  return Wrap(
                                                    children: [
                                                      isOwnerGroup ? InkWell(
                                                        onTap: () {
                                                          NavigationService().pop();
                                                          showConfirmDialog(
                                                            context: context,
                                                            title: ConstantStrings.appString.outOwnerGroup,
                                                            content: ConstantStrings.appString.confirmOutOwnerGroup,
                                                            onConfirm: () async {
                                                              showAppLoading(context);
                                                              try {
                                                                await model.removeAnOwnerFromGroup(group.id, member.id);
                                                                NavigationService().pop();
                                                                AppToaster.showToast(
                                                                  context: context,
                                                                  msg: ConstantStrings
                                                                      .appString.addNewOwnerSuccess,
                                                                  type: AppToasterType.success,
                                                                );
                                                              } catch(e) {
                                                                NavigationService().pop();
                                                                if (e is YouAreOnlyOwnerOfGroupException) {
                                                                  AppToaster.showToast(
                                                                    context: context,
                                                                    msg: ConstantStrings
                                                                        .appString.youAreOnlyOwnerGroup,
                                                                    type: AppToasterType.warning,
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
                                                          leading: Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                left: 2.0),
                                                            child: Stack(
                                                              children: [
                                                                Image.asset(AssetPaths.iconPath.getCrownIconPath, width: 20,),
                                                                Image.asset(AssetPaths.iconPath.getDenyIconPath, width: 20,),
                                                              ],
                                                            ),
                                                          ),
                                                          title: Text(ConstantStrings
                                                              .appString.outOwnerGroup),
                                                        ),
                                                      ) : const SizedBox(),
                                                      !isOwnerGroup ? Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              NavigationService().pop();
                                                              showConfirmDialog(
                                                                context: context,
                                                                title: ConstantStrings.appString.setOwnerGroup,
                                                                content: ConstantStrings.appString.confirmSetOwnerGroup,
                                                                onConfirm: () async {
                                                                  showAppLoading(context);
                                                                  await model.addNewOwnerForGroup(group.id, member.id);
                                                                  NavigationService().pop();
                                                                  AppToaster.showToast(
                                                                    context: context,
                                                                    msg: ConstantStrings
                                                                        .appString.addNewOwnerSuccess,
                                                                    type: AppToasterType.success,
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: ListTile(
                                                              leading: Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    left: 2.0),
                                                                child: Image.asset(AssetPaths.iconPath.getCrownIconPath, width: 20,),
                                                              ),
                                                              title: Text(ConstantStrings
                                                                  .appString.setOwnerGroup),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              NavigationService().pop();
                                                              showConfirmDialog(
                                                                context: context,
                                                                title: ConstantStrings.appString.removeFromGroup,
                                                                content: ConstantStrings.appString.confirmRemoveFromGroup,
                                                                onConfirm: () async {
                                                                  showAppLoading(context);
                                                                  await model.removeMemberFromGroup(group.id, userId: member.id);
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
                                                            child: ListTile(
                                                              leading: const Padding(
                                                                padding:
                                                                EdgeInsets.only(
                                                                    left: 2.0),
                                                                child: Icon(Icons.delete),
                                                              ),
                                                              title: Text(ConstantStrings
                                                                  .appString.removeFromGroup),
                                                            ),
                                                          ),
                                                        ],
                                                      ) : const SizedBox(),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Image.asset(AssetPaths
                                                .iconPath.getKebabMenuIconPath),
                                          ),
                                          isShowCrown: isOwnerGroup,
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
                                            baseColor: Colors.grey[300]!
                                                .withOpacity(0.6),
                                            highlightColor: Colors.grey[100]!
                                                .withOpacity(0.6),
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
