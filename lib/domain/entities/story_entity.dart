import '../enums/story_mood.dart';

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
}
