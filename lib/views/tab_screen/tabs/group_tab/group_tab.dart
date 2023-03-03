import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spending_app/routes/navigation_services.dart';
import 'package:spending_app/routes/routes.dart';
import 'package:spending_app/views/tab_screen/tabs/group_tab/widgets/group_tab_header.dart';
import 'package:spending_app/widgets/custom_button.dart';
import 'package:spending_app/widgets/custom_loading.dart';
import 'package:spending_app/widgets/custom_text_field.dart';
import 'package:spending_app/widgets/main_title_text.dart';
import 'package:spending_app/widgets/shimmer_loading.dart';

import '../../../../constants.dart';
import '../../../../models/group.dart';
import '../../../../view_models/group_view_model.dart';
import '../../../../widgets/app_toaster.dart';
import '../../../../widgets/fab_with_icon.dart';
import '../../../../widgets/card_item.dart';

class GroupTab extends StatefulWidget {
  const GroupTab({Key? key}) : super(key: key);

  @override
  State<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends State<GroupTab> {
  final joinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupViewModel>(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GroupTabHeader(),
                  const SizedBox(height: 40),
                  MainTitleText(title: ConstantStrings.appString.joinedGroup),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<List<Group>>(
                    stream: model.groupsListStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Group> groupsList = snapshot.data!;
                        return Column(
                          children: List.generate(groupsList.length, (index) {
                            var group = groupsList[index];
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    NavigationService().pushNamed(ROUTER_GROUP,
                                        arguments: {'group': group});
                                  },
                                  child: CardItem(
                                    imageURL: group.imageURL,
                                    title: group.name,
                                    subTitle:
                                        "${group.membersIdList.length} thành viên",
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            );
                          }),
                        );
                      }
                      return Column(
                        children: List.generate(
                          3,
                              (index) {
                            return Column(
                              children: const [
                                ShimmerLoading(width: double.infinity, height: 70, border: 8),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  MainTitleText(title: ConstantStrings.appString.waitingGroup),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<List<Group>>(
                    stream: model.requestGroupsListStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Group> groupsList = snapshot.data!;
                        return Column(
                          children: List.generate(groupsList.length, (index) {
                            var group = groupsList[index];
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // NavigationService().pushNamed(ROUTER_GROUP, arguments: {'group': group});
                                  },
                                  child: CardItem(
                                    imageURL: group.imageURL,
                                    title: group.name,
                                    subTitle:
                                        "${group.membersIdList.length} thành viên",
                                    trailing: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (subContext) {
                                            return Wrap(
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    NavigationService().pop();
                                                    showAppLoading(subContext);
                                                    await model
                                                        .deleteRequestToJoinGroup(
                                                            group.id);
                                                    NavigationService().pop();
                                                    AppToaster.showToast(
                                                      context: context,
                                                      msg: ConstantStrings
                                                          .appString
                                                          .cancelRequestSuccess,
                                                      type: AppToasterType
                                                          .success,
                                                    );
                                                  },
                                                  child: ListTile(
                                                    leading: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 2.0),
                                                      child: Image.asset(
                                                        AssetPaths.iconPath
                                                            .getDeleteIconPath,
                                                        height: 20,
                                                      ),
                                                    ),
                                                    title: Text(ConstantStrings
                                                        .appString
                                                        .cancelRequest),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Image.asset(AssetPaths
                                          .iconPath.getKebabMenuIconPath),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            );
                          }),
                        );
                      }
                      return Column(
                        children: List.generate(
                          3,
                          (index) {
                            return Column(
                              children: const [
                                ShimmerLoading(width: double.infinity, height: 70, border: 8),
                                SizedBox(
                                  height: 8,
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: _buildFab(context, model),
        );
      },
    );
  }

  Widget _buildFab(BuildContext mainContext, GroupViewModel model) {
    final items = [
      {
        'icon': Icons.add_home,
        'title': ConstantStrings.appString.createNewGroup,
        'onTap': () {
          NavigationService().pushNamed(ROUTER_CREATE_GROUP);
        },
      },
      {
        'icon': Icons.group_add,
        'title': ConstantStrings.appString.joinWithCode,
        'onTap': () {
          showDialog(
            context: mainContext,
            builder: (BuildContext context) {
              return Form(
                key: _formKey,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Container(
                    height: 240,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(
                            AssetPaths.imagePath.getBackgroundImagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MainTitleText(
                            title: ConstantStrings.appString.joinWithCode),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          title: ConstantStrings.appString.inputCode,
                          hint: ConstantStrings.appString.inputGroupCode,
                          controller: joinController,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              width: 100,
                              height: 48,
                              title: ConstantStrings.appString.confirm,
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  String groupId = joinController.text.trim();
                                  NavigationService().pop();
                                  showAppLoading(context);
                                  await model.requestToJoinGroup(groupId);
                                  NavigationService().pop();
                                  AppToaster.showToast(
                                    context: mainContext,
                                    msg: ConstantStrings
                                        .appString.requestSuccess,
                                    type: AppToasterType.success,
                                  );
                                  joinController.text = "";
                                }
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            CustomButton(
                              isConfirm: false,
                              width: 100,
                              height: 48,
                              title: ConstantStrings.appString.cancel,
                              onTap: () {
                                NavigationService().pop();
                                joinController.text = "";
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      },
    ];
    return FabWithIcons(
      items: items,
      onIconTapped: (index) {},
    );
  }
}
