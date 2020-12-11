import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:zeus/Main/Helper/Home/home_screen.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
  double gap = 10;
  List body = [
    HomeScreen(),
    Container(color: Color(0xff1f1b24))
  ];
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView.builder(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _selectedIndex = page;
            });
          },
          itemCount: 2,
          itemBuilder: (context, position) {
            return Scaffold(
              body: body[position],
            );
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(
                  spreadRadius: -10,
                  blurRadius: 60,
                  offset: Offset(0,25),
                  color: Colors.black.withOpacity(0.4))
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: GNav(
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 900),
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  iconColor: Colors.black,
                  iconActiveColor: Color(0xff520935),
                  text: 'Helper',
                  textColor: Color(0xff520935),
                  backgroundColor: Colors.grey[100],
                  iconSize: 24,
                  padding: padding,
                  gap: gap,
                ),
                GButton(
                  icon: LineIcons.home,
                  iconColor: Colors.black,
                  iconActiveColor: Colors.white,
                  text: 'Predictor',
                  textColor: Colors.white,
                  backgroundColor: Color(0xff1f1b24),
                  iconSize: 24,
                  padding: padding,
                  gap: gap,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                _pageController.jumpToPage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
