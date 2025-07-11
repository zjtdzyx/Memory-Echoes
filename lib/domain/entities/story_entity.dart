import 'package:freezed_annotation/freezed_annotation.dart';

enum StoryMood {
  happy,
  sad,
  nostalgic,
  peaceful,
  excited,
  neutral,
  adventurous,
}

abstract class StoryEntity {
  String? get id;
  String get userId;
  String get title;
  String get content;
  List<String> get imageUrls;
  DateTime get createdAt;
  StoryMood get mood;
  List<String> get tags;
  bool get isPublic;

  StoryEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    List<String>? imageUrls,
    DateTime? createdAt,
    StoryMood? mood,
    List<String>? tags,
    bool? isPublic,
  });
}
