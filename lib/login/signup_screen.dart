import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:zeus/login/google_sign_in.dart';
import 'package:zeus/login/start_screen.dart';
import 'package:zeus/services/constants.dart';

class SignUpScreen extends StatefulWidget {
  final String pageId = 'SignUpScreen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String name, email, password;
  bool _isLoading = false, passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: WillPopScope(
        onWillPop: () {
          setState(() {
            pageId = null;
          });
          Navigator.pushReplacement(context,
              PageRouteBuilder(pageBuilder: (_, __, ___) => StartScreen()));
          return Future.value(false);
        },
        child: ModalProgressHUD(
          inAsyncCall: _isLoading,
          progressIndicator: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Color(0xff520935)),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/covid_back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(color: Colors.black.withOpacity(0.7)),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 30),
                        IconButton(
                            icon: Icon(Icons.arrow_back),
                            color: Colors.white,
                            alignment: Alignment.topLeft,
                            onPressed: () {
                              setState(() {
                                pageId = null;
                              });
                              Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          StartScreen()));
                            }),
                        Hero(
                          tag: 'signUp',
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              padding: EdgeInsets.all(10.0),
                              child: Text('Sign Up',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      letterSpacing: 2.0)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                      color: Color(0xff520935), width: 2.0)),
                              elevation: 6.0,
                              color: Color(0xff520935),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 12),
                        Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                  color: Color(0xff520935), width: 2.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.0),
                              Text('Your name',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      letterSpacing: 2.0,
                                      fontFamily: 'Montserrat')),
                              SizedBox(height: 20.0),
                              TextField(
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 0.0),
                                  enabledBorder: kSignInTextFieldDecoration,
                                  focusedBorder: kSignInTextFieldDecoration,
                                  icon: Icon(Icons.person_outline,
                                      color: Colors.white),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                              ),
                              SizedBox(height: 20.0),
                              Text('Set an email',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      letterSpacing: 2.0,
                                      fontFamily: 'Montserrat')),
                              SizedBox(height: 20.0),
                              TextField(
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 0.0),
                                  enabledBorder: kSignInTextFieldDecoration,
                                  focusedBorder: kSignInTextFieldDecoration,
                                  icon: Icon(Icons.email, color: Colors.white),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                              ),
                              SizedBox(height: 40.0),
                              Text('Set a password',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      letterSpacing: 2.0,
                                      fontFamily: 'Montserrat')),
                              TextField(
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: passwordVisible,
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 0.0),
                                    enabledBorder: kSignInTextFieldDecoration,
                                    focusedBorder: kSignInTextFieldDecoration,
                                    icon: GestureDetector(
                                      child: Icon(Icons.remove_red_eye,
                                          color: Colors.white),
                                      onTap: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                    )),
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                              ),
                              Expanded(child: SizedBox(height: 20.0)),
                              Align(
                                alignment: Alignment.center,
                                child: RaisedButton(
                                  color: Color(0xff520935),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 40.0),
                                  elevation: 15.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Text('Sign Up',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontFamily: 'Montserrat',
                                          letterSpacing: 2.0)),
                                  onPressed: () {
                                    setState(() {
                                      _isLoading = true;
                                      GoogleLoginIn().emailSignUp(
                                          email, password, name, context);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
