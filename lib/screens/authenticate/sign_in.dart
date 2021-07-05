import 'package:chatbat/screens/authenticate/restpassword_dialog.dart';
import 'package:chatbat/screens/home/horizontal_or_line.dart';
import 'package:chatbat/services/auth.dart';
import 'package:chatbat/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              iconTheme: Theme.of(context).iconTheme,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 0.0,
              title: Text(
                "ChatBat",
              ),
              actions: <Widget>[
                Transform.scale(
                    scale: 0.85, child: Image.asset("assets/splashscreen.png")),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text("Sign In",
                                style: Theme.of(context).textTheme.headline5),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            hintText: 'Email',
                            hintStyle: Theme.of(context).textTheme.bodyText2,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorLight,
                                    width: 2)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an Email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            hintText: 'Password',
                            hintStyle: Theme.of(context).textTheme.bodyText2,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColorLight,
                                    width: 2)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColorLight,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          validator: (val) => val.length < 5
                              ? 'Passwords must be at least 6 characters'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              try {
                                if (email.isNotEmpty && email != null) {
                                  _auth.resetPassword(email);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          ResetPasswordDialog());
                                } else {
                                  setState(() {
                                    error =
                                        "Please enter the email of an existing user";
                                  });
                                }
                              } catch (e) {
                                setState(() {
                                  error =
                                      "Someting went wrong. Check your email and try again";
                                });
                              }
                            },
                            child: Container(
                              child: Text("Forgot password?",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: 240,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                primary: Theme.of(context).accentColor),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    error =
                                        'Incorrect email, password or combination';
                                    loading = false;
                                  });
                                }
                              }
                            },
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  "Sign In",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.button,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                IconTheme(
                                    data: Theme.of(context).iconTheme,
                                    child: Icon(Icons.login))
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text(
                            error,
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        HorizontalOrLine(
                          label: "Or",
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text("",
                              style: TextStyle(
                                color: Theme.of(context).splashColor,
                                fontSize: 16,
                              )),
                        ),
                        SignInButton(
                          Buttons.Google,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)),
                          padding: EdgeInsets.only(left: 16, right: 4),
                          onPressed: () {
                            _auth.signInWithGoogle();
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SignInButton(
                          Buttons.Facebook,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          onPressed: () {
                            _auth.signInWithFacebook();
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SignInButton(
                          Buttons.Twitter,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          onPressed: () {
                            print("pressed");
                            _auth.signInWithTwitter();
                          },
                        ),
                        SizedBox(height: 30),
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.toggleView();
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          );
  }
}
