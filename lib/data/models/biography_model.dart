import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/biography_entity.dart';

part 'biography_model.freezed.dart';
part 'biography_model.g.dart';

@freezed
class BiographyModel with _$BiographyModel implements BiographyEntity {
  const factory BiographyModel({
    required String id,
    required String userId,
    required String title,
    required String content,
    @Default([]) List<String> storyIds,
    @Default('') String coverImageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isPublic,
    @Default(BiographyTheme.classic) BiographyTheme theme,
  }) = _BiographyModel;

  factory BiographyModel.fromJson(Map<String, dynamic> json) =>
      _$BiographyModelFromJson(json);
}
