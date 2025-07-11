import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/story_entity.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
class StoryModel with _$StoryModel implements StoryEntity {
  @Implements<StoryEntity>()
  const factory StoryModel({
    String? id,
    required String userId,
    required String title,
    required String content,
    @Default([]) List<String> imageUrls,
    required DateTime createdAt,
    required StoryMood mood,
    @Default([]) List<String> tags,
    @Default(false) bool isPublic,
  }) = _StoryModel;

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);
}
