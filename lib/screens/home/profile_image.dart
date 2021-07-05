import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String userID;
  final double size;
  ProfileImage({this.userID, this.size});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData || !snapshot.data.exists) {
            return CircularProgressIndicator(
                color: Theme.of(context).accentColor);
          }
          var userDocument = snapshot.data;
          return Container(
            width: size,
            height: size,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(userDocument['imageURL'], fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              }),
            ),
          );
        });
  }
}
