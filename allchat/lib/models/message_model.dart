import 'package:robochat/constants.dart';

class MessageModel {
  final String? message;
  final String? id;
  final DateTime? messageTime;

  const MessageModel({this.message, this.id, this.messageTime});

  factory MessageModel.fromJson(json) {
    return MessageModel(
      message: json[kMessage],
      id: json[kId],
      messageTime: json[kTime].toDate(),
    );
  }
}
