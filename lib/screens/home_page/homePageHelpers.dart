import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class homePageHelpers with ChangeNotifier {
  Widget bottomNavBar(int index, PageController pageController) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: Colors.blue,
      unSelectedColor: Colors.grey,
      strokeColor: Colors.blue,
      scaleFactor: 0.5,
      iconSize: 25,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(index);
        notifyListeners();
      },
      backgroundColor: Colors.black87,
      items: [
        CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
        CustomNavigationBarItem(icon: Icon(FontAwesomeIcons.yinYang)),
        CustomNavigationBarItem(icon: Icon(EvaIcons.person)),
      ],
    );
  }
}
