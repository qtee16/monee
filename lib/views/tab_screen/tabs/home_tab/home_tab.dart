import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_app/constants.dart';
import 'package:spending_app/view_models/group_view_model.dart';
import 'package:spending_app/view_models/member_view_model.dart';
import 'package:spending_app/view_models/personal_statistic_view_model.dart';
import 'package:spending_app/views/tab_screen/tabs/home_tab/widgets/home_tab_header.dart';
import 'package:spending_app/widgets/shimmer_loading.dart';

import '../../../../models/group.dart';
import '../../../../models/member.dart';
import '../../../../routes/navigation_services.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/enums/type_bill_enum.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/card_item.dart';
import '../../../../widgets/pie_chart_custom.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    Member member =
        Provider.of<MemberViewModel>(context, listen: false).currentUser!;
    Provider.of<PersonalStatisticViewModel>(context, listen: false)
        .getSpentMoneyInCurrentMonth(member.groupsIdList, member.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        return await () async {
          String userId = Provider.of<MemberViewModel>(context, listen: false)
              .currentUser!
              .id;
          Member member =
              await Provider.of<MemberViewModel>(context, listen: false)
                  .getUserById(userId);
          if (!mounted) return;
          Provider.of<MemberViewModel>(context, listen: false)
              .setCurrentUser(member);
          await Provider.of<PersonalStatisticViewModel>(context, listen: false)
              .getSpentMoneyInCurrentMonth(member.groupsIdList, member.id);
        }();
      },
      child: Consumer3<MemberViewModel, PersonalStatisticViewModel,
          GroupViewModel>(
        builder: (context, memberModel, statisticModel, groupModel, _) {
          Member? member = memberModel.currentUser;
          Map<TypeBill, Map<String, double>> typeRatio =
              statisticModel.typeRatio;
          Map<Group, Map<String, double>> groupRatio =
              statisticModel.groupRadio;

          List<ChartData> typeChartData = [];
          typeRatio.forEach((key, value) {
            var item = ChartData(
                key.toStringValue(), value['value']!, value['percent']!);
            typeChartData.add(item);
          });

          List<ChartData> groupChartData = [];
          groupRatio.forEach((key, value) {
            var item = ChartData(key.name, value['value']!, value['percent']!);
            groupChartData.add(item);
          });

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeTabHeader(
                      title:
                          "Xin chào ${member != null ? member.firstName : ""}!"),
                  const SizedBox(
                    height: 32.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 20),
                    height: 168,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(AssetPaths.imagePath.getCardImagePath),
                      fit: BoxFit.cover,
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ConstantStrings.appString.spentMoneyInMonth,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        statisticModel.spentMoney != null
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "VND",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: AppColors.whiteColor,
                                        height: 1.5),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    formatter.format(
                                        statisticModel.spentMoney!.round()),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 36,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ],
                              )
                            : const ShimmerLoading(
                                width: double.infinity,
                                height: 40,
                                border: 4,
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.navBarStartColor,
                          AppColors.navBarEndColor
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              ConstantStrings.appString.typeStatistic,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                        typeChartData.isNotEmpty
                            ? PieChartCustom(chartData: typeChartData)
                            : SizedBox(
                                height: 300,
                                child: Center(
                                  child: Text(
                                      ConstantStrings.appString.notHaveData),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.navBarStartColor,
                          AppColors.navBarEndColor
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              ConstantStrings.appString.groupStatistic,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                        groupChartData.isNotEmpty
                            ? PieChartCustom(chartData: groupChartData)
                            : SizedBox(
                                height: 300,
                                child: Center(
                                  child: Text(
                                      ConstantStrings.appString.notHaveData),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    ConstantStrings.appString.joinedGroup,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<List<Group>>(
                    stream: groupModel.groupsListStream(),
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
                                ShimmerLoading(
                                    width: double.infinity,
                                    height: 70,
                                    border: 8),
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
          );
        },
      ),
    );
  }
}
