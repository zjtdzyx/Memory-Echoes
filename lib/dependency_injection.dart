import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_echoes/data/datasources/remote/firebase_auth_datasource.dart';
import 'package:memory_echoes/data/datasources/remote/firestore_story_datasource.dart';
import 'package:memory_echoes/data/datasources/remote/firestore_biography_datasource.dart';
import 'package:memory_echoes/data/datasources/remote/firebase_storage_datasource.dart';
import 'package:memory_echoes/data/datasources/remote/gemini_api_service.dart';
import 'package:memory_echoes/data/repositories/auth_repository_impl.dart';
import 'package:memory_echoes/data/repositories/story_repository_impl.dart';
import 'package:memory_echoes/data/repositories/biography_repository_impl.dart';
import 'package:memory_echoes/data/repositories/ai_repository_impl.dart';
import 'package:memory_echoes/domain/repositories/auth_repository.dart';
import 'package:memory_echoes/domain/repositories/story_repository.dart';
import 'package:memory_echoes/domain/repositories/biography_repository.dart';
import 'package:memory_echoes/domain/repositories/ai_repository.dart';
import 'package:memory_echoes/domain/usecases/auth_usecases.dart';
import 'package:memory_echoes/domain/usecases/story_usecases.dart';
import 'package:memory_echoes/domain/usecases/ai_chat_usecases.dart';
import 'package:memory_echoes/core/services/file_upload_service.dart';

// Firebase
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
final firebaseStorageProvider =
    Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);

// HTTP Client
final dioProvider = Provider<Dio>((ref) => Dio());

// DataSources
final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) =>
    FirebaseAuthDataSource(
        ref.watch(firebaseAuthProvider), ref.watch(firestoreProvider)));

final firestoreStoryDataSourceProvider = Provider<FirestoreStoryDataSource>(
    (ref) => FirestoreStoryDataSource(ref.watch(firestoreProvider)));

final firestoreBiographyDataSourceProvider =
    Provider<FirestoreBiographyDataSource>(
        (ref) => FirestoreBiographyDataSource(ref.watch(firestoreProvider)));

final firebaseStorageDataSourceProvider = Provider<FirebaseStorageDataSource>(
    (ref) => FirebaseStorageDataSourceImpl(ref.watch(firebaseStorageProvider)));

final geminiApiServiceProvider = Provider<GeminiApiService>(
    (ref) => GeminiApiServiceImpl(ref.watch(dioProvider)));

// Services
final fileUploadServiceProvider = Provider<FileUploadService>(
    (ref) => FileUploadService(ref.watch(firebaseStorageDataSourceProvider)));

// Repositories
final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => AuthRepositoryImpl(ref.watch(firebaseAuthDataSourceProvider)));

final storyRepositoryProvider = Provider<StoryRepository>(
    (ref) => StoryRepositoryImpl(ref.watch(firestoreStoryDataSourceProvider)));

final biographyRepositoryProvider = Provider<BiographyRepository>((ref) =>
    BiographyRepositoryImpl(ref.watch(firestoreBiographyDataSourceProvider)));

final aiRepositoryProvider = Provider<AiRepository>(
    (ref) => AiRepositoryImpl(ref.watch(geminiApiServiceProvider)));

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
final getStoryByIdUseCaseProvider = Provider<GetStoryByIdUseCase>(
    (ref) => GetStoryByIdUseCase(ref.watch(storyRepositoryProvider)));
final createStoryUseCaseProvider = Provider<CreateStoryUseCase>(
    (ref) => CreateStoryUseCase(ref.watch(storyRepositoryProvider)));
final updateStoryUseCaseProvider = Provider<UpdateStoryUseCase>(
    (ref) => UpdateStoryUseCase(ref.watch(storyRepositoryProvider)));
final deleteStoryUseCaseProvider = Provider<DeleteStoryUseCase>(
    (ref) => DeleteStoryUseCase(ref.watch(storyRepositoryProvider)));
final searchStoriesUseCaseProvider = Provider<SearchStoriesUseCase>(
    (ref) => SearchStoriesUseCase(ref.watch(storyRepositoryProvider)));

// 添加公开故事用例
final getPublicStoriesUseCaseProvider = Provider<GetPublicStoriesUseCase>(
    (ref) => GetPublicStoriesUseCase(ref.watch(storyRepositoryProvider)));

// UseCases - AI Chat
final sendChatMessageUseCaseProvider = Provider<SendChatMessageUseCase>(
    (ref) => SendChatMessageUseCase(ref.watch(aiRepositoryProvider)));
final generateStoryFromChatUseCaseProvider =
    Provider<GenerateStoryFromChatUseCase>((ref) =>
        GenerateStoryFromChatUseCase(ref.watch(aiRepositoryProvider),
            ref.watch(storyRepositoryProvider)));
final postChatMessageUseCaseProvider = Provider<PostChatMessageUseCase>(
    (ref) => PostChatMessageUseCase(ref.watch(aiRepositoryProvider)));
