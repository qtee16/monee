import 'package:flutter/material.dart';
import 'package:spending_app/views/tab_screen/tabs/group_tab/group_tab.dart';
import 'package:spending_app/views/tab_screen/tabs/home_tab/home_tab.dart';
import 'package:spending_app/views/tab_screen/tabs/profile_tab/profile_tab.dart';
import 'package:spending_app/views/tab_screen/widgets/tab_nav_bar.dart';

import '../../constants.dart';
import '../../widgets/app_toaster.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final _listTab = [
    const HomeTab(),
    const GroupTab(),
    const ProfileTab(),
  ];

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigateToPage(int pageIndex, BuildContext context) {
    try {
      _pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn);
    } catch (e) {
      AppToaster.showToast(
        context: context,
        msg: ConstantStrings.appString.errorOccur,
        type: AppToasterType.failed,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TabNavBar(navigateToPage: navigateToPage,),
      backgroundColor: Colors.transparent,
      drawerScrimColor: Colors.transparent,
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetPaths.imagePath.getBackgroundImagePath),
                fit: BoxFit.cover),
          ),
          child: SafeArea(
            child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _listTab.length,
                itemBuilder: (_, index) => _listTab[index],
                allowImplicitScrolling: false,
                controller: _pageController,
                scrollDirection: Axis.horizontal),
          ),
      ),
    );
  }
}
