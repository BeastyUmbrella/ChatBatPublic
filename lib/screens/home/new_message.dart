import 'dart:io';
import 'package:chatbat/models/user.dart';
import 'package:chatbat/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

class NewMessage extends StatefulWidget {
  final String receiver;
  NewMessage({@required this.receiver});

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String messageText = '';
  bool isPressed = false;
  File _image;
  final picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  toggleColor() {
    setState(() {
      isPressed = !isPressed;
    });
  }

  resetMessageText() {
    setState(() {
      messageText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final DatabaseService _database = DatabaseService(uid: user.uid);

    void sendMessage() async {
      toggleColor();
      FocusScope.of(context).unfocus();
      _controller.clear();
      await _database.uploadMessage(
          user.uid, widget.receiver, messageText, false, null);
      toggleColor();
      resetMessageText();
    }

    void sendImage(String imageURL) async {
      FocusScope.of(context).unfocus();
      _controller.clear();
      await _database.uploadMessage(
          user.uid, widget.receiver, "Sent a photo", true, imageURL);
      resetMessageText();
    }

    Future<String> uploadImage(File imageFile) async {
      String fileName = basename(imageFile.path);
      Reference ref = _storage
          .ref()
          .child('chats')
          .child(widget.receiver)
          .child(DateTime.now().toString() + fileName);
      UploadTask uploadTask = ref.putFile(imageFile);

      var downloadURL = await (await uploadTask).ref.getDownloadURL();
      return downloadURL.toString();
    }

    Future getImage(ImageSource source) async {
      final pickedFile = await picker.getImage(source: source);

      if (pickedFile != null) {
        Navigator.pop(context);
        _image = File(pickedFile.path);
        String imageURL = await uploadImage(_image);
        sendImage(imageURL);
      } else {
        print("No image selected");
      }
    }

    void _imageModalBottomSheet(context) {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
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

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.fromLTRB(8, 10, 8, 14),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    child: Icon(Icons.image,
                        color: Theme.of(context).accentColor, size: 24),
                    onTap: () {
                      _imageModalBottomSheet(context);
                    }),
                isDense: true,
                filled: true,
                hintText: 'Type a message...',
                hintStyle: Theme.of(context).textTheme.bodyText2,
                fillColor: Theme.of(context).canvasColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColorLight, width: 3)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).accentColor, width: 3),
                  borderRadius: BorderRadius.circular(25),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColorLight, width: 3),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: (val) => setState(() {
                messageText = val;
              }),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: messageText.trim().isEmpty ? null : sendMessage,
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 3,
                    color: isPressed
                        ? Theme.of(context).accentColor
                        : Theme.of(context).primaryColorLight),
                shape: BoxShape.circle,
                color: Theme.of(context).canvasColor,
              ),
              child: Icon(Icons.send, color: Theme.of(context).accentColor),
            ),
          ),
        ],
      ),
    );
  }
}
