import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart';

// Data Sources
import 'data/datasources/remote/firebase_auth_datasource.dart';
import 'data/datasources/remote/firestore_story_datasource.dart';
import 'data/datasources/remote/firestore_chat_datasource.dart';
import 'data/datasources/remote/firebase_storage_datasource.dart';
import 'data/datasources/remote/gemini_api_service.dart';

// Repositories
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/story_repository.dart';
import 'domain/repositories/chat_repository.dart';
import 'domain/repositories/ai_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/story_repository_impl.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'data/repositories/ai_repository_impl.dart';

// Use Cases
import 'domain/usecases/auth_usecases.dart';
import 'domain/usecases/story_usecases.dart';
import 'domain/usecases/chat_usecases.dart';
import 'domain/usecases/ai_chat_usecases.dart';

// Services
import 'core/services/file_upload_service.dart';

// Firebase instances
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

// Data Sources
final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSource(
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseFirestoreProvider),
  );
});

final firestoreStoryDataSourceProvider =
    Provider<FirestoreStoryDataSource>((ref) {
  return FirestoreStoryDataSource(ref.watch(firebaseFirestoreProvider));
});

final firestoreChatDataSourceProvider =
    Provider<FirestoreChatDataSource>((ref) {
  return FirestoreChatDataSource(ref.watch(firebaseFirestoreProvider));
});

final firebaseStorageDataSourceProvider =
    Provider<FirebaseStorageDataSource>((ref) {
  return FirebaseStorageDataSourceImpl(ref.watch(firebaseStorageProvider));
});

final geminiApiServiceProvider = Provider<GeminiApiService>((ref) {
  return GeminiApiServiceImpl(ref.watch(dioProvider));
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(firebaseAuthDataSourceProvider));
});

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepositoryImpl(ref.watch(firestoreStoryDataSourceProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(ref.watch(firestoreChatDataSourceProvider));
});

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepositoryImpl(ref.watch(geminiApiServiceProvider));
});

// Services
final fileUploadServiceProvider = Provider<FileUploadService>((ref) {
  return FileUploadService(ref.watch(firebaseStorageDataSourceProvider));
});

// UseCases - Auth
final getAuthStatusUseCaseProvider = Provider<GetAuthStatusUseCase>(
    (ref) => GetAuthStatusUseCase(ref.watch(authRepositoryProvider)));
final signInWithEmailUseCaseProvider = Provider<SignInWithEmailUseCase>(
    (ref) => SignInWithEmailUseCase(ref.watch(authRepositoryProvider)));
final signUpWithEmailUseCaseProvider = Provider<SignUpWithEmailUseCase>(
    (ref) => SignUpWithEmailUseCase(ref.watch(authRepositoryProvider)));
final signOutUseCaseProvider = Provider<SignOutUseCase>(
    (ref) => SignOutUseCase(ref.watch(authRepositoryProvider)));
final updateUserUseCaseProvider = Provider<UpdateUserUseCase>(
    (ref) => UpdateUserUseCase(ref.watch(authRepositoryProvider)));

// UseCases - Story
final getUserStoriesUseCaseProvider = Provider<GetUserStoriesUseCase>(
    (ref) => GetUserStoriesUseCase(ref.watch(storyRepositoryProvider)));
final getPublicStoriesUseCaseProvider = Provider<GetPublicStoriesUseCase>(
    (ref) => GetPublicStoriesUseCase(ref.watch(storyRepositoryProvider)));
final getStoryByIdUseCaseProvider = Provider<GetStoryByIdUseCase>(
    (ref) => GetStoryByIdUseCase(ref.watch(storyRepositoryProvider)));
final createStoryUseCaseProvider = Provider<CreateStoryUseCase>(
    (ref) => CreateStoryUseCase(ref.watch(storyRepositoryProvider)));
final updateStoryUseCaseProvider = Provider<UpdateStoryUseCase>(
    (ref) => UpdateStoryUseCase(ref.watch(storyRepositoryProvider)));
final deleteStoryUseCaseProvider = Provider<DeleteStoryUseCase>(
    (ref) => DeleteStoryUseCase(ref.watch(storyRepositoryProvider)));

// UseCases - AI Chat
final sendChatMessageUseCaseProvider = Provider<SendChatMessageUseCase>(
    (ref) => SendChatMessageUseCase(ref.watch(aiRepositoryProvider)));
final generateStoryFromChatUseCaseProvider =
    Provider<GenerateStoryFromChatUseCase>((ref) =>
        GenerateStoryFromChatUseCase(ref.watch(aiRepositoryProvider),
            ref.watch(storyRepositoryProvider)));
final postChatMessageUseCaseProvider = Provider<PostChatMessageUseCase>(
    (ref) => PostChatMessageUseCase(ref.watch(aiRepositoryProvider)));

// UseCases - Chat
final getChatMessagesUseCaseProvider = Provider<GetChatMessagesUseCase>(
    (ref) => GetChatMessagesUseCase(ref.watch(chatRepositoryProvider)));
final saveChatMessageUseCaseProvider = Provider<SaveChatMessageUseCase>(
    (ref) => SaveChatMessageUseCase(ref.watch(chatRepositoryProvider)));
final clearChatHistoryUseCaseProvider = Provider<ClearChatHistoryUseCase>(
    (ref) => ClearChatHistoryUseCase(ref.watch(chatRepositoryProvider)));
