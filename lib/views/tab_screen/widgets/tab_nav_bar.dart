import 'package:flutter/material.dart';
import 'package:spending_app/constants.dart';


class TabNavBar extends StatefulWidget {
  final Function(int, BuildContext) navigateToPage;
  const TabNavBar({Key? key, required this.navigateToPage}) : super(key: key);

  @override
  State<TabNavBar> createState() => _TabNavBarState();
}

class _TabNavBarState extends State<TabNavBar> {
  var currentIndex = 0;

  final _listItem = [
    NavBarModel(ConstantStrings.appString.homePage, Icons.home_filled),
    NavBarModel(ConstantStrings.appString.group, Icons.groups),
    NavBarModel(ConstantStrings.appString.personal, Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.navBarStartColor, AppColors.navBarEndColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.clamp,
        ),
      ),
      child: BottomNavigationBar(
        items: _listItem
            .map((e) => BottomNavigationBarItem(
                icon: Icon(e.icon),
                label: e.title,
                ))
            .toList(),
        backgroundColor: Colors.transparent,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF3A61A0),
        unselectedItemColor: Colors.white,
        selectedLabelStyle: const TextStyle(color: Color(0xFF3A61A0)),
        currentIndex: currentIndex,
        onTap: (i) {
          setState(() {
            currentIndex = i;
          });
          widget.navigateToPage(i, context);
        },
      ),
    );
  }
}

class NavBarModel {
  final String title;
  final IconData icon;

  NavBarModel(this.title, this.icon);
}
