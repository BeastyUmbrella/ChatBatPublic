import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Message extends Equatable{
  final String messageId;
  final String uid;
  final String message;
  final Timestamp timestamp;
  final bool isImage;
  final String imageURL;

  Message({this.messageId, this.uid, this.timestamp, this.message, this.isImage, this.imageURL});

  @override
  List<Object> get props => [messageId, uid, message, timestamp, isImage, imageURL];
}
