import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/chat_message_entity.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessageModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String content;
  @JsonKey(name: 'is_user')
  final bool isUser;
  final DateTime timestamp;
  final String type;
  final Map<String, dynamic>? metadata;

  const ChatMessageModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.type = 'text',
    this.metadata,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      userId: entity.userId,
      content: entity.content,
      isUser: entity.isUser,
      timestamp: entity.timestamp,
      type: entity.type.name,
      metadata: entity.metadata,
    );
  }

  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      userId: userId,
      content: content,
      isUser: isUser,
      timestamp: timestamp,
      type: MessageType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => MessageType.text,
      ),
      metadata: metadata,
    );
  }
}
