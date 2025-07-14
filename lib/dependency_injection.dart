import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
import 'domain/repositories/biography_repository.dart';
import 'domain/repositories/ai_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/story_repository_impl.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'data/repositories/biography_repository_impl.dart';
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

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

// Data Sources
final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSource(
    ref.read(firebaseAuthProvider),
    ref.read(firebaseFirestoreProvider),
    ref.read(googleSignInProvider),
  );
});

final firestoreStoryDataSourceProvider =
    Provider<FirestoreStoryDataSource>((ref) {
  return FirestoreStoryDataSource(ref.read(firebaseFirestoreProvider));
});

final firestoreChatDataSourceProvider =
    Provider<FirestoreChatDataSource>((ref) {
  return FirestoreChatDataSource(ref.read(firebaseFirestoreProvider));
});

final firebaseStorageDataSourceProvider =
    Provider<FirebaseStorageDataSource>((ref) {
  return FirebaseStorageDataSourceImpl(ref.read(firebaseStorageProvider));
});

final geminiApiServiceProvider = Provider<GeminiApiService>((ref) {
  return GeminiApiServiceImpl(ref.read(dioProvider));
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(firebaseAuthDataSourceProvider));
});

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepositoryImpl(ref.read(firestoreStoryDataSourceProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(ref.read(firestoreChatDataSourceProvider));
});

final biographyRepositoryProvider = Provider<BiographyRepository>((ref) {
  return BiographyRepositoryImpl();
});

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepositoryImpl(ref.read(geminiApiServiceProvider));
});

// Use Cases
final getAuthStatusUseCaseProvider = Provider<GetAuthStatusUseCase>((ref) {
  return GetAuthStatusUseCase(ref.read(authRepositoryProvider));
});

final signInWithEmailUseCaseProvider = Provider<SignInWithEmailUseCase>((ref) {
  return SignInWithEmailUseCase(ref.read(authRepositoryProvider));
});

final signUpWithEmailUseCaseProvider = Provider<SignUpWithEmailUseCase>((ref) {
  return SignUpWithEmailUseCase(ref.read(authRepositoryProvider));
});

final signInWithGoogleUseCaseProvider =
    Provider<SignInWithGoogleUseCase>((ref) {
  return SignInWithGoogleUseCase(ref.read(authRepositoryProvider));
});

final signInWithAppleUseCaseProvider = Provider<SignInWithAppleUseCase>((ref) {
  return SignInWithAppleUseCase(ref.read(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.read(authRepositoryProvider));
});

final updateUserUseCaseProvider = Provider<UpdateUserUseCase>((ref) {
  return UpdateUserUseCase(ref.read(authRepositoryProvider));
});

final getUserStoriesUseCaseProvider = Provider<GetUserStoriesUseCase>((ref) {
  return GetUserStoriesUseCase(ref.read(storyRepositoryProvider));
});

final getPublicStoriesUseCaseProvider =
    Provider<GetPublicStoriesUseCase>((ref) {
  return GetPublicStoriesUseCase(ref.read(storyRepositoryProvider));
});

final getStoryByIdUseCaseProvider = Provider<GetStoryByIdUseCase>((ref) {
  return GetStoryByIdUseCase(ref.read(storyRepositoryProvider));
});

final createStoryUseCaseProvider = Provider<CreateStoryUseCase>((ref) {
  return CreateStoryUseCase(ref.read(storyRepositoryProvider));
});

final updateStoryUseCaseProvider = Provider<UpdateStoryUseCase>((ref) {
  return UpdateStoryUseCase(ref.read(storyRepositoryProvider));
});

final deleteStoryUseCaseProvider = Provider<DeleteStoryUseCase>((ref) {
  return DeleteStoryUseCase(ref.read(storyRepositoryProvider));
});

final searchStoriesUseCaseProvider = Provider<SearchStoriesUseCase>((ref) {
  return SearchStoriesUseCase(ref.read(storyRepositoryProvider));
});

final getChatMessagesUseCaseProvider = Provider<GetChatMessagesUseCase>((ref) {
  return GetChatMessagesUseCase(ref.read(chatRepositoryProvider));
});

final saveChatMessageUseCaseProvider = Provider<SaveChatMessageUseCase>((ref) {
  return SaveChatMessageUseCase(ref.read(chatRepositoryProvider));
});

final clearChatHistoryUseCaseProvider =
    Provider<ClearChatHistoryUseCase>((ref) {
  return ClearChatHistoryUseCase(ref.read(chatRepositoryProvider));
});

final postChatMessageUseCaseProvider = Provider<PostChatMessageUseCase>((ref) {
  return PostChatMessageUseCase(ref.read(aiRepositoryProvider));
});

final generateStoryFromChatUseCaseProvider =
    Provider<GenerateStoryFromChatUseCase>((ref) {
  return GenerateStoryFromChatUseCase(
    ref.read(aiRepositoryProvider),
    ref.read(storyRepositoryProvider),
  );
});

// Services
final fileUploadServiceProvider = Provider<FileUploadService>((ref) {
  return FileUploadService(ref.read(firebaseStorageDataSourceProvider));
});
