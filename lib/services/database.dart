import 'package:chatbat/models/message.dart';
import 'package:chatbat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //Storage reference
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //Collection reference
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection("chats");

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference searchingCollection =
      FirebaseFirestore.instance.collection("searching");

  //Insert fields that users would need
  Future setInitialUserData(String displayName, String email, String photoURL) async {
    if (photoURL == null) {
      String defaultPhotoFilePath = 'images/profilebat.png';
      Reference ref = _storage.ref().child(defaultPhotoFilePath);
      photoURL = await ref.getDownloadURL();
    }

    return await userCollection.doc(uid).set({
      "displayName": displayName,
      "email": email,
      "imageURL": photoURL,
    });
  }

  //Update searching for current user
  Future updateUserSearching(double longitude, double latitude, int radius) {
    var map = new Map();
    map["geohash"] = GeoFirePoint(latitude, longitude).hash;
    map["geopoint"] = GeoPoint(latitude, longitude);
    return searchingCollection.doc(uid).set({
      "searchTime": DateTime.now(),
      "coordinates": GeoPoint(latitude, longitude),
      "g": map,
      "radius": radius
    });
  }

  //Remove searching for current user
  Future removeUserSearching() {
    return searchingCollection.doc(uid).delete();
  }

  //userlist from snapshot
  List<User> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return User(
          uid: (doc.data())['uid'],
          radius: (doc.data())['radius'] ?? 1,
          searching: (doc.data())['searching'] ?? false,
          searchTime: (doc.data())['searchTime'],
          timestamp: (doc.data())['timestamp'],
          displayName: (doc.data())['displayName'],
          email: (doc.data())['email']);
    }).toList();
  }

  //Upload imageURL to user
  Future uploadImageURL(String url, String uid) {
    return userCollection.doc(uid).update({
      "imageURL": url,
    });
  }

  //Get imageURL of user
  Future<String> getImageURL(String uid) async {
    String url;
    await userCollection.doc(uid).get().then((snapshot) {
      url = (snapshot.data())['imageURL'].toString();
    });
    return url;
  }

  // Get imageURL
  Future<String> getImageURLNEW(String uid) async {
    String url;
    Stream<QuerySnapshot> ref =
        FirebaseFirestore.instance.collection("users/$uid").snapshots();
    ref.listen((snap) {
      snap.docChanges.forEach((element) {
        url = (element.doc.data())['imageURL'].toString();
      });
    });
    return url;
  }

  // Change display name
  Future<void> newDisplayName(String uid, String newDisplayName) async {
    if (newDisplayName != null) {
      await userCollection.doc(uid).update({"displayName": newDisplayName});
    }
  }

  //messagelist from snapshot
  List<Message> _messageListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Message(
        messageId: (doc.id),
        uid: (doc.data())['uid'],
        message: (doc.data())['message'],
        timestamp: (doc.data())['timestamp'],
        isImage: (doc.data())['isImage'],
        imageURL: (doc.data())['imageURL']
      );
    }).toList();
  }

  //Get user stream
  Stream<List<User>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  //Get chattingWith stream
  Stream<List<User>> getchattingWith(String uid) {
    return FirebaseFirestore.instance
        .collection('users/$uid/chattingWith')
        .snapshots()
        .map(_userListFromSnapshot);
  }

  //Uploads message for both users
  Future uploadMessage(
      String senderid, String receiverid, String message, bool isImage, String imageURL) async {
    final senderRef =
        FirebaseFirestore.instance.collection('chats/$senderid/$receiverid');

    final receiverRef =
        FirebaseFirestore.instance.collection('chats/$receiverid/$senderid');

    var timeOfSend = DateTime.now();

    await senderRef
        .add({'uid': senderid, 'message': message, 'timestamp': timeOfSend, 'isImage': isImage, 'imageURL': imageURL});
    await receiverRef
        .add({'uid': senderid, 'message': message, 'timestamp': timeOfSend, 'isImage': isImage, 'imageURL': imageURL});
    await FirebaseFirestore.instance
        .collection('users/$receiverid/chattingWith')
        .doc(senderid)
        .update({'isSeen': false});
  }

  //Get messages of the uid
  Stream<List<Message>> getMessages(String sender) {
    return FirebaseFirestore.instance
        .collection('chats/${this.uid}/$sender')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(_messageListFromSnapshot);
  }

  //Gets the latest message in a conversation
  Stream<List<Message>> getLatestMessage(String receiver) {
    return FirebaseFirestore.instance
        .collection('chats/$receiver/messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map(_messageListFromSnapshot);
  }

  //Gets the searching state of the user
  Stream<DocumentSnapshot> getSearching(String currentUserID) {
    return FirebaseFirestore.instance
        .collection('searching/')
        .doc(currentUserID)
        .snapshots();
  }

  //Get isSeen of chattingWith
  Stream<DocumentSnapshot> getIsSeen(String userID) {
    return FirebaseFirestore.instance
        .collection('users/${this.uid}/chattingWith')
        .doc(userID)
        .snapshots();
  }

  //Set isSeen of chattingWith
  Future<void> setIsSeen(String userID, bool value) async {
    await FirebaseFirestore.instance
        .collection('users/${this.uid}/chattingWith')
        .doc(userID)
        .update({'isSeen': value});
  }

  //Add user to blocked list of current user as well as removing the chat
  Future<void> blockUser(String userID) async {
    await FirebaseFirestore.instance
        .collection('users/${this.uid}/blocked')
        .doc(userID)
        .set({'timestamp': DateTime.now()});
    deleteChat(userID);
  }

  //GET LIST OF BLOCKED USERS TO POTENTIALLY UNBLOCK

  //Deletes the chat for both users. Users can still match again in the future
  Future<void> deleteChat(String userID) async {
    await FirebaseFirestore.instance
        .collection('users/${this.uid}/chattingWith')
        .doc(userID)
        .delete();

    await FirebaseFirestore.instance
        .collection('users/$userID/chattingWith')
        .doc(this.uid)
        .delete();
  }

  //Updates searching radius if the doc exists in the searching collection
  Future<void> updateSearchRadius(double value) async {
    value = (value / 5).round().toDouble() * 5;
    final roundedValue = value.ceil().toInt();
    FirebaseFirestore.instance.collection('searching/').doc(this.uid).get().then((value) async {
      if (value.exists){
        FirebaseFirestore.instance.collection('searching/').doc(this.uid).update({
          "radius": roundedValue
        });
      }
    });
  }

  //Updates the loction of the user
  Future<void> updateLocation(double value) async {
    Location location = new Location();
    LocationData currentLocation = await location.getLocation();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    value = (value / 5).round().toDouble() * 5;
    final roundedValue = value.ceil().toInt();
    await this.updateUserSearching(currentLocation.longitude, currentLocation.latitude, roundedValue);
    // await this.updatelongitudeAndLatitude(
    //     currentLocation.longitude, currentLocation.latitude);
  }

  //Update radius
  void updateRadius(double value) async {
    value = (value / 5).round().toDouble() * 5;
    final roundedValue = value.ceil().toInt();
    FirebaseFirestore.instance.collection('searching/').doc(this.uid).get().then((value) async {
      if (value.exists){
        await FirebaseFirestore.instance.collection('searching/').doc(this.uid).update({
          "radius": roundedValue
        });
      }
    });
  }
}
