import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_app/models/group.dart';
import 'package:spending_app/routes/navigation_services.dart';
import 'package:spending_app/view_models/group_view_model.dart';
import 'package:spending_app/views/group/tabs/member_tab.dart';
import 'package:spending_app/views/group/tabs/expense_tab.dart';
import 'package:spending_app/views/group/tabs/statistic_tab.dart';
import 'package:spending_app/views/group/widgets/my_tab.dart';
import 'package:spending_app/widgets/general_header.dart';

import '../../constants.dart';

class GroupScreen extends StatefulWidget {
  final Group group;

  const GroupScreen({Key? key, required this.group}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
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
          child: StreamBuilder<Group>(
            stream: Provider.of<GroupViewModel>(context, listen: false)
                .getStreamGroupById(widget.group.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var group = snapshot.data!;
                return CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GeneralHeader(
                              title: group.name,
                              onTap: () {
                                NavigationService().pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: MyTab(
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            border: Border(
                              bottom: BorderSide(color: Colors.white),
                            ),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicatorColor: Colors.white,
                            tabs: const [
                              Tab(icon: Icon(Icons.groups)),
                              Tab(icon: Icon(Icons.monetization_on_rounded)),
                              Tab(icon: Icon(Icons.bar_chart)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      child: TabBarView(
                        // physics: const NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          MemberTab(group: widget.group,),
                          ExpenseTab(group: widget.group,),
                          StatisticTab(group: widget.group,),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
