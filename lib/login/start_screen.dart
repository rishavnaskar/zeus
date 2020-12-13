import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:zeus/login/signin_screen.dart';
import 'package:zeus/login/signup_screen.dart';
import 'google_sign_in.dart';

String pageId;

class StartScreen extends StatefulWidget {
  StartScreen({this.email, this.password});
  final String email;
  final String password;
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            backgroundColor: Color(0xff520935)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StartCarousel(),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 16.0),
              child: Text('Let\'s get started',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 25.0,
                      fontFamily: 'Montserrat')),
            ),

            ///Sign Up Button
            Expanded(flex: 2, child: SizedBox(height: 20.0)),
            Hero(
              tag: 'signUp',
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 15.0,
                    color: Color(0xff520935),
                    child: Text('Sign Up with email',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      setState(() {
                        pageId = SignUpScreen().pageId;
                      });
                      Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SignUpScreen()));
                    }),
              ),
            ),

            ///Or text
            Expanded(flex: 1, child: SizedBox(height: 5.0)),
            Center(
                child: Text('Or', style: TextStyle(fontFamily: 'Montserrat'))),
            Expanded(flex: 1, child: SizedBox(height: 5.0)),

            ///SingIn Button
            Hero(
              tag: 'signIn',
              child: RaisedButton(
                  child: Text('Sign In',
                      style: TextStyle(fontFamily: 'Montserrat')),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Color(0xff520935), width: 2.0)),
                  elevation: 6.0,
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      pageId = SignInScreen().pageId;
                    });
                    Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => SignInScreen(),
                            maintainState: true));
                  }),
            ),
            Expanded(flex: 2, child: SizedBox(height: 20.0)),

            Container(height: 2.0, color: Colors.grey),
            Expanded(flex: 1, child: SizedBox(height: 5.0)),

            ///GoogleSignIn Button
            SignInButton(
              Buttons.Google,
              padding: EdgeInsets.only(left: 30.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                GoogleLoginIn().googleLogInUser(context);
              },
            ),
            Expanded(flex: 1, child: SizedBox(height: 5.0)),
          ],
        ),
      ),
    );
  }
}

class StartCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Carousel(
            images: [
              ExactAssetImage('assets/image1.jpg'),
              ExactAssetImage('assets/image4.jpg'),
              ExactAssetImage('assets/image3.jpg'),
            ],
            showIndicator: true,
            animationDuration: Duration(seconds: 1),
            dotBgColor: Colors.white.withOpacity(0.2),
            dotIncreasedColor: Colors.red,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.6,
          color: Colors.black.withOpacity(0.6),
        ),
        Positioned(
          top: 70.0,
          right: 30.0,
          child: Text(
            'ZEUS',
            style: TextStyle(
              fontSize: 55.0,
              color: Colors.white,
              letterSpacing: 3.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Positioned(
          top: 140.0,
          right: 30.0,
          child: Text(
            'A COVID-19 helper app',
            style: TextStyle(
              color: Colors.grey,
              letterSpacing: 1.0,
              fontWeight: FontWeight.bold,
              wordSpacing: 2.0,
            ),
          ),
        ),
      ],
    );
  }
}
