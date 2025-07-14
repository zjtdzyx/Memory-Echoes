import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_entity.freezed.dart';

@freezed
class FeedbackEntity with _$FeedbackEntity {
  const factory FeedbackEntity({
    required String id,
    required String userId,
    required String type, // 'bug', 'feature', 'general'
    required String title,
    required String content,
    required DateTime createdAt,
    String? email,
    String? status, // 'pending', 'processing', 'resolved'
  }) = _FeedbackEntity;
}
