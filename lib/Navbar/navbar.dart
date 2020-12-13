import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:zeus/Main/Helper/Home/home_screen.dart';
import 'package:zeus/Main/Predictor/Home/home_screen.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
  double gap = 10;
  List body = [HelperHomeScreen(), PredictorHomeScreen()];
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
                  offset: Offset(0, 25),
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
                  icon: LineIcons.heart_o,
                  iconColor: Colors.black,
                  iconActiveColor: Color(0xff520935),
                  text: 'Helper',
                  textStyle: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  textColor: Color(0xff520935),
                  backgroundColor: Colors.grey[100],
                  iconSize: 24,
                  padding: padding,
                  gap: gap,
                ),
                GButton(
                  icon: LineIcons.bar_chart,
                  iconColor: Colors.black,
                  iconActiveColor: Color(0xff520935),
                  text: 'Predictor',
                  textStyle: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  textColor: Color(0xff520935),
                  backgroundColor: Colors.grey[100],
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
