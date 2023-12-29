class MessageModel {
  final String id;
  final String sender;
  final String receiver;
  final String text;
  final DateTime time;

  MessageModel({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.time,
  });
}
