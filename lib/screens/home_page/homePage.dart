import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:money_lans/profile/Profile.dart';
import 'package:money_lans/screens/home_page/homePageHelpers.dart';

import '../../services/Authentication.dart';
import '../feed/Feed.dart';

class HomePage extends StatefulWidget {
  String name;
  HomePage({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController homeController = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: homeController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
        children: [
          Feed(),
          Profile(name: widget.name),
        ],
      ),
      bottomNavigationBar: Provider.of<homePageHelpers>(context, listen: false)
          .bottomNavBar(pageIndex, homeController),
    );
  }
}
