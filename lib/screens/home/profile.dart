import 'package:chatbat/models/preferences.dart';
import 'package:chatbat/models/user.dart';
import 'package:chatbat/screens/home/displayname.dart';
import 'package:chatbat/screens/home/email.dart';
import 'package:chatbat/screens/home/profilePictureSearch.dart';
import 'package:chatbat/screens/home/profile_image.dart';
import 'package:chatbat/screens/home/range.dart';
import 'package:chatbat/screens/home/theme_button.dart';
import 'package:chatbat/services/auth.dart';
import 'package:chatbat/services/database.dart';
import 'package:chatbat/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;
  final picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthService _authService = AuthService();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User currentUser;
  String newDisplayName;
  String newPassword;
  String confirmPassword;
  String currentRange = Preferences.getCurrentRange();

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final user = Provider.of<User>(context);
    currentUser = user;

    Future<String> uploadImage(var imageFile) async {
      String filePath = 'images/${currentUser.uid}.png';
      Reference ref = _storage.ref().child(filePath);
      UploadTask uploadTask = ref.putFile(imageFile);

      var downloadURL = await (await uploadTask).ref.getDownloadURL();
      return downloadURL.toString();
    }

    Future getImage(ImageSource source) async {
      final pickedFile = await picker.getImage(source: source);

      if (pickedFile != null) {
        Navigator.pop(context);
        _image = File(pickedFile.path);
        await DatabaseService(uid: user.uid)
            .uploadImageURL(await uploadImage(_image), currentUser.uid);
      } else {
        print("No image selected");
      }
    }

    //Notifies child widget to update its state and show the new range
    notify() {
      setState(() {});
    }

    _removeDeviceToken(User user) async {
      String fcmToken = await _fcm.getToken();

      if (fcmToken != null) {
        var tokenRef = _db
            .collection('users')
            .doc(user.uid)
            .collection('tokens')
            .doc(fcmToken);

        await tokenRef.delete();
      }
    }

    void _imageModalBottomSheet(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).accentColor,
                    ),
                    title: Text('Open Camera',
                        style: Theme.of(context).textTheme.bodyText1),
                    onTap: () {
                      getImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.image, color: Theme.of(context).accentColor),
                    title: Text('Browse Images',
                        style: Theme.of(context).textTheme.bodyText1),
                    onTap: () {
                      getImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            );
          });
    }

    void _changeDisplayNameDialog() {
      showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Change Username',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Icon(
                Icons.alternate_email,
                color: Theme.of(context).accentColor,
              )
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: TextField(
            onChanged: (value) => value.length > 0
                ? newDisplayName = value
                : newDisplayName = null,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              hintText: 'Enter new Username',
              hintStyle: Theme.of(context).textTheme.bodyText2,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColorLight, width: 2)),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).accentColor, width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColorLight, width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  primary: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.button,
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  primary: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  if (newDisplayName != null) {
                    DatabaseService(uid: user.uid)
                        .newDisplayName(currentUser.uid, newDisplayName);
                    Navigator.pop(context);
                  }
                },
                child:
                    Text('Change', style: Theme.of(context).textTheme.button))
          ],
        ),
      );
    }

    void _changePasswordDialog() {
      showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Change Password',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Icon(
              Icons.lock,
              color: Theme.of(context).accentColor,
            )
          ]),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) =>
                    value.length > 5 ? newPassword = value : newPassword = null,
                obscureText: true,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  hintText: 'Enter new Password',
                  hintStyle: Theme.of(context).textTheme.bodyText2,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorLight,
                          width: 2)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColorLight, width: 2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) => value.length > 5
                    ? confirmPassword = value
                    : confirmPassword = null,
                obscureText: true,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  hintText: 'Confirm Password',
                  hintStyle: Theme.of(context).textTheme.bodyText2,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorLight,
                          width: 2)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).accentColor, width: 2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColorLight, width: 2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  primary: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child:
                    Text('Cancel', style: Theme.of(context).textTheme.button)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  primary: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  print("Pressed");
                  if (newPassword != null && newPassword == confirmPassword) {
                    print("CHANGED");
                    _authService.changePassword(newPassword);
                    Navigator.pop(context);
                  }
                },
                child:
                    Text('Change', style: Theme.of(context).textTheme.button))
          ],
        ),
      );
    }

    return user != null
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: Text('Profile'),
              actions: [
                GestureDetector(
                  child: Icon(Icons.logout),
                  onTap: () async {
                    Navigator.pop(context);
                    await _removeDeviceToken(user);
                    await _auth.signOut();
                  },
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    color: Theme.of(context).scaffoldBackgroundColor),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        child: Column(
                          children: [
                            Stack(fit: StackFit.loose, children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 250,
                                    width: 250,
                                    child: Stack(
                                      clipBehavior: Clip.antiAlias,
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Transform.scale(
                                          scale: 3.5,
                                          child: ProfilePictureSearch(),
                                        ),
                                        Container(
                                          // decoration: new BoxDecoration(
                                          //   shape: BoxShape.circle,
                                          //   border: Border.all(
                                          //     color:
                                          //         Theme.of(context).accentColor,
                                          //     width: 14,
                                          //   ),
                                          // ),
                                          child: Transform.scale(
                                            scale: 1.1,
                                            child: ProfileImage(
                                              userID: user.uid,
                                              size: 200,
                                            ),
                                          ),
                                        ),
                                        SleekCircularSlider(
                                            appearance:
                                                CircularSliderAppearance(
                                                    infoProperties:
                                                        InfoProperties(
                                                      mainLabelStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .headline5,
                                                      modifier: (value) => "",
                                                    ),
                                                    size: 234,
                                                    customWidths:
                                                        CustomSliderWidths(
                                                            progressBarWidth:
                                                                12,
                                                            handlerSize: 4),
                                                    angleRange: 360,
                                                    startAngle: 180,
                                                    customColors:
                                                        CustomSliderColors(
                                                            gradientEndAngle:
                                                                (360.0 + 180),
                                                            gradientStartAngle:
                                                                180,
                                                            shadowColor: Theme
                                                                    .of(context)
                                                                .primaryColor)),
                                            min: 5,
                                            max: 100,
                                            initialValue: currentRange != null
                                                ? double.parse(currentRange)
                                                : 15,
                                            onChange: (double value) async {
                                              setState(() {
                                                currentRange = value.toString();
                                              });
                                              notify();
                                            },
                                            onChangeEnd: (double value) async {
                                              DatabaseService(uid: user.uid)
                                                  .updateSearchRadius(value);
                                              await Preferences.setCurrentRange(
                                                  currentRange);
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 185.0, right: 160.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          _imageModalBottomSheet(context);
                                        },
                                        child: new CircleAvatar(
                                          radius: 25.0,
                                          child: Icon(Icons.camera_alt),
                                          backgroundColor:
                                              Theme.of(context).accentColor,
                                          foregroundColor: Colors.white,
                                        ),
                                      )
                                    ],
                                  )),
                            ]),
                            Container(
                              child: Column(
                                children: [
                                  DisplayName(
                                    userID: user.uid,
                                    isProfileSection: true,
                                    isChatHeader: false,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  EmailWidget(
                                    userID: user.uid,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      RangeWidget(
                        currentRange: this.currentRange,
                        notify: notify(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 10, 16, 20),
                                child: Column(
                                  children: [
                                    Text(
                                      'Edit Account',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          primary:
                                              Theme.of(context).accentColor,
                                        ),
                                        onPressed: () {
                                          _changeDisplayNameDialog();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Username',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button,
                                            ),
                                            IconTheme(
                                                data:
                                                    Theme.of(context).iconTheme,
                                                child:
                                                    Icon(Icons.alternate_email))
                                          ],
                                        )),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          primary:
                                              Theme.of(context).accentColor,
                                        ),
                                        onPressed: () {
                                          _changePasswordDialog();
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              'Password',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button,
                                            ),
                                            IconTheme(
                                                data:
                                                    Theme.of(context).iconTheme,
                                                child: Icon(Icons.lock))
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ThemeButtonWidget(),
                        ],
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: DatabaseService(uid: user.uid)
                            .getSearching(user.uid),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          80, 16, 80, 16),
                                      child: Container(
                                        width: 240,
                                        height: 60,
                                        child: ElevatedButton(
                                            onPressed: () {},
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                Text("Start Searching",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .button,
                                                    textAlign: TextAlign.start),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                IconTheme(
                                                    data: Theme.of(context)
                                                        .iconTheme,
                                                    child: Icon(
                                                        Icons.wifi_tethering))
                                              ],
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0),
                                              ),
                                              primary:
                                                  Theme.of(context).accentColor,
                                            )),
                                      )));
                            default:
                              if (snapshot.data.exists) {
                                return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16))),
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            80, 16, 80, 16),
                                        child: Container(
                                          width: 240,
                                          height: 60,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                DatabaseService(uid: user.uid)
                                                    .removeUserSearching();
                                              },
                                              child: Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  Text("Stop Searching",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .button,
                                                      textAlign:
                                                          TextAlign.start),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  IconTheme(
                                                      data: Theme.of(context)
                                                          .iconTheme,
                                                      child: Icon(Icons
                                                          .portable_wifi_off)),
                                                ],
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                shape:
                                                    new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          30.0),
                                                ),
                                                primary: Theme.of(context)
                                                    .accentColor,
                                              )),
                                        )));
                              } else {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        80, 16, 80, 16),
                                    child: Container(
                                      width: 240,
                                      height: 60,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            DatabaseService(uid: user.uid)
                                                .updateLocation(
                                                    double.parse(currentRange));
                                            // FirebaseFirestore.instance
                                            //     .collection('users/${user.uid}/chattingWith')
                                            //     .snapshots()
                                            //     .listen((event) {
                                            //   for (DocumentChange dc in event.docChanges) {
                                            //     if (dc.type == DocumentChangeType.added) {
                                            //       //Some sort of notification of a new match
                                            //     }
                                            //   }
                                            // });
                                          },
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Text("Start Searching",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button,
                                                  textAlign: TextAlign.start),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              IconTheme(
                                                  data: Theme.of(context)
                                                      .iconTheme,
                                                  child: Icon(
                                                      Icons.wifi_tethering))
                                            ],
                                          ), //Search Icon (track_changes, wifi_tethering)
                                          style: ElevatedButton.styleFrom(
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                            ),
                                            primary:
                                                Theme.of(context).accentColor,
                                          )),
                                    ),
                                  ),
                                );
                              }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Loading();
  }
}
