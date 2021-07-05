import 'package:equatable/equatable.dart';

class User extends Equatable{
  final String uid;
  final double radius;
  final bool searching;
  final DateTime searchTime;
  final DateTime timestamp;
  final String displayName;
  final String email;

  User(
      {this.uid,
      this.radius,
      this.searching,
      this.searchTime,
      this.timestamp,
      this.displayName,
      this.email});
  
  @override
  List<Object> get props => [uid, radius, searching, searchTime, timestamp, displayName, email];
}
