import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:chatbat/models/user.dart';
import 'package:chatbat/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter_twitter/flutter_twitter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;

  //Create user obj based on FirebaseUser
  User _userFromFirebaseUser(Auth.User user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream<User> get user {
    return _auth.userChanges().map(_userFromFirebaseUser);
  }

  //Sign in anonymously
  Future signInAnonymously(
      String displayName, String email) async {
    try {
      Auth.UserCredential result = await _auth.signInAnonymously();
      Auth.User user = result.user;

      //create a new document for the user with the uid
      await DatabaseService(uid: user.uid)
          .setInitialUserData(displayName, email, null);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      Auth.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Auth.User user = result.user;

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      Auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Auth.User user = result.user;

      //Create new document for the user with the uid
      await DatabaseService(uid: user.uid)
          .setInitialUserData(displayName, email, null);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Change password for current user
  changePassword(String newPassword) async {
    await _auth.currentUser.updatePassword(newPassword);
  }

  //Sign in with google
  Future signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final Auth.GoogleAuthCredential credential =
        Auth.GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    Auth.UserCredential result =
        await Auth.FirebaseAuth.instance.signInWithCredential(credential);

    Auth.User user = result.user;

    await DatabaseService(uid: user.uid).setInitialUserData(
        user.displayName,
        user.email,
        (user.photoURL.replaceRange(
            user.photoURL.length - 4, user.photoURL.length - 2, "1080")));
  }

  //Sign in with facebook
  Future signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    try {
      switch (result.status) {
        case FacebookLoginStatus.success:
          FacebookAccessToken accessToken = result.accessToken;
          Auth.AuthCredential credential =
              Auth.FacebookAuthProvider.credential(accessToken.token);
          Auth.UserCredential userCredential =
              await Auth.FirebaseAuth.instance.signInWithCredential(credential);
          Auth.User user = userCredential.user;
          await DatabaseService(uid: user.uid).setInitialUserData(
              user.displayName,
              user.email,
              await facebookLogin.getProfileImageUrl(width: 1080));
          break;
        case FacebookLoginStatus.cancel:
          print('Cancled login');
          break;
        case FacebookLoginStatus.error:
          print('There was an error');
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  // //Sign in with twitter
  Future signInWithTwitter() async {
    final TwitterLogin twitterLogin = TwitterLogin(
        consumerKey: "hG8dRpIvnNQwfk515Ea4h3J7f",
        consumerSecret: "a72mRg2KKbdotOpLhlL610ojJPoBFnCjZlD9nopMn1cTzrmnfP");

    final TwitterLoginResult result = await twitterLogin.authorize();
    try {
      switch (result.status) {
        case TwitterLoginStatus.loggedIn:
          Auth.AuthCredential credential = Auth.TwitterAuthProvider.credential(
              accessToken: result.session.token, secret: result.session.secret);
          Auth.UserCredential userCredential =
              await Auth.FirebaseAuth.instance.signInWithCredential(credential);
          Auth.User user = userCredential.user;
          DatabaseService(uid: user.uid).setInitialUserData(
              user.displayName,
              user.email,
              user.photoURL.replaceRange(
                  user.photoURL.length - 11, user.photoURL.length - 4, ""));
          break;
        case TwitterLoginStatus.cancelledByUser:
          break;
        case TwitterLoginStatus.error:
          print("error");
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  //Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Reset password email
  void resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
