import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth {
  static GoogleSignIn? googleSignIn;

  static Future<UserCredential> signInWithGoogle() async {
    googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn!.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static void signout() {
    GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
  }

  static Future<void> registerOnDatabase() async {
    User user = FirebaseAuth.instance.currentUser!;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("Users").child(user.uid);
    final snapshot = await userRef.get();
    if (!snapshot.exists) {
      await userRef.set({
        "name": user.providerData[0].displayName,
        "isRiding": false,
        "email": user.providerData[0].email,
        "points": 0
      });
    }
  }
}
