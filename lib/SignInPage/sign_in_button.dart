import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:velo/Helpers/google_auth.dart';
import 'package:velo/firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../HomePage/main.dart';

class SignInButton extends StatelessWidget {
  User? user;

  Future<void> signInWithGoogle(BuildContext context) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    GoogleAuth.signInWithGoogle().then(
      (value) {
        user = value.user!;
        if (!user!.providerData[0].email!.endsWith("thapar.edu")) {
          GoogleAuth.signout();
          Fluttertoast.showToast(
              msg: "Please login with your thapar.edu email");
          return;
        }
        GoogleAuth.registerOnDatabase().then((value) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Color.fromARGB(255, 216, 217, 216))),
      onPressed: () {
        signInWithGoogle(context);
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            children: [
              Image.asset(
                'Assets/googlelogo.png',
                height: 30,
              ),
              Spacer(),
              Text(
                'Sign in with Google',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C9869),
                  fontSize: 18,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
