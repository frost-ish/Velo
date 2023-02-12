import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:velo/SignInPage/sign_in_button.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0C9869),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 30, 50),
              child: Column(
                children: [
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      "Just a second!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 8),
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      "Let's personalize the app for you! Login with your college id to start riding.",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SignInButton(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 100),
                child: Image.asset(
                  'Assets/applogo1.png',
                  fit: BoxFit.cover,
                  height: 300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
