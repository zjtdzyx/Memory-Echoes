import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart';

// Data Sources
import 'data/datasources/remote/firebase_auth_datasource.dart';
import 'data/datasources/remote/firestore_story_datasource.dart';
import 'data/datasources/remote/firebase_storage_datasource.dart';
import 'data/datasources/remote/gemini_api_service.dart';

// Repositories
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/story_repository_impl.dart';
import 'data/repositories/ai_repository_impl.dart';

// Domain Repositories
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/story_repository.dart';
import 'domain/repositories/ai_repository.dart';

// Use Cases
import 'domain/usecases/auth_usecases.dart';
import 'domain/usecases/story_usecases.dart';
import 'domain/usecases/ai_chat_usecases.dart';

// Services
import 'core/services/file_upload_service.dart';

// External Dependencies
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
final firebaseStorageProvider = Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options = BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );
  return dio;
});

// Data Sources
final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSourceImpl(
    ref.read(firebaseAuthProvider),
    ref.read(firestoreProvider),
  );
});

final firestoreStoryDataSourceProvider = Provider<FirestoreStoryDataSource>((ref) {
  return FirestoreStoryDataSourceImpl(ref.read(firestoreProvider));
});

final firebaseStorageDataSourceProvider = Provider<FirebaseStorageDataSource>((ref) {
  return FirebaseStorageDataSourceImpl(ref.read(firebaseStorageProvider));
});

final geminiApiServiceProvider = Provider<GeminiApiService>((ref) {
  return GeminiApiServiceImpl(ref.read(dioProvider));
});

// Services
final fileUploadServiceProvider = Provider<FileUploadService>((ref) {
  return FileUploadService(ref.read(firebaseStorageDataSourceProvider));
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(firebaseAuthDataSourceProvider));
});

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepositoryImpl(ref.read(firestoreStoryDataSourceProvider));
});

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepositoryImpl(ref.read(geminiApiServiceProvider));
});

// Use Cases
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.read(authRepositoryProvider));
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.read(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.read(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.read(authRepositoryProvider));
});

final createStoryUseCaseProvider = Provider<CreateStoryUseCase>((ref) {
  return CreateStoryUseCase(
    ref.read(storyRepositoryProvider),
    ref.read(aiRepositoryProvider),
  );
});

final getUserStoriesUseCaseProvider = Provider<GetUserStoriesUseCase>((ref) {
  return GetUserStoriesUseCase(ref.read(storyRepositoryProvider));
});

final getPublicStoriesUseCaseProvider = Provider<GetPublicStoriesUseCase>((ref) {
  return GetPublicStoriesUseCase(ref.read(storyRepositoryProvider));
});

final likeStoryUseCaseProvider = Provider<LikeStoryUseCase>((ref) {
  return LikeStoryUseCase(ref.read(storyRepositoryProvider));
});

final sendChatMessageUseCaseProvider = Provider<SendChatMessageUseCase>((ref) {
  return SendChatMessageUseCase(ref.read(aiRepositoryProvider));
});

final generateStoryFromChatUseCaseProvider = Provider<GenerateStoryFromChatUseCase>((ref) {
  return GenerateStoryFromChatUseCase(
    ref.read(aiRepositoryProvider),
    ref.read(storyRepositoryProvider),
  );
});
