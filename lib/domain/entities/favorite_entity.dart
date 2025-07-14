import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_entity.freezed.dart';

@freezed
class FavoriteEntity with _$FavoriteEntity {
  const factory FavoriteEntity({
    required String id,
    required String userId,
    required String itemId,
    required String itemType, // 'story' or 'biography'
    required DateTime createdAt,
    String? title,
    String? description,
    String? imageUrl,
  }) = _FavoriteEntity;
}
