class ChatMessageEntity {
  final String? id;
  final String text;
  final MessageSender sender;
  final DateTime createdAt;

  const ChatMessageEntity({
    this.id,
    required this.text,
    required this.sender,
    required this.createdAt,
  });

  ChatMessageEntity copyWith({
    String? id,
    String? text,
    MessageSender? sender,
    DateTime? createdAt,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      sender: sender ?? this.sender,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum MessageSender {
  user,
  ai,
}
