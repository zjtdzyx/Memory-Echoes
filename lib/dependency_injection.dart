import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_echoes/data/datasources/remote/firebase_auth_datasource.dart';
import 'package:memory_echoes/data/datasources/remote/firestore_story_datasource.dart';
import 'package:memory_echoes/data/repositories/auth_repository_impl.dart';
import 'package:memory_echoes/data/repositories/story_repository_impl.dart';
import 'package:memory_echoes/data/repositories/ai_repository_impl.dart';
import 'package:memory_echoes/domain/repositories/auth_repository.dart';
import 'package:memory_echoes/domain/repositories/story_repository.dart';
import 'package:memory_echoes/domain/repositories/ai_repository.dart';
import 'package:memory_echoes/domain/usecases/auth_usecases.dart';
import 'package:memory_echoes/domain/usecases/story_usecases.dart';
import 'package:memory_echoes/domain/usecases/ai_chat_usecases.dart';

// Firebase
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

// DataSources
final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) =>
    FirebaseAuthDataSource(
        ref.watch(firebaseAuthProvider), ref.watch(firestoreProvider)));

final firestoreStoryDataSourceProvider = Provider<FirestoreStoryDataSource>(
    (ref) => FirestoreStoryDataSource(ref.watch(firestoreProvider)));

// Repositories
final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => AuthRepositoryImpl(ref.watch(firebaseAuthDataSourceProvider)));

final storyRepositoryProvider = Provider<StoryRepository>(
    (ref) => StoryRepositoryImpl(ref.watch(firestoreStoryDataSourceProvider)));

final aiRepositoryProvider =
    Provider<AiRepository>((ref) => AiRepositoryImpl());

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

// UseCases - AI
final postChatMessageUseCaseProvider = Provider<PostChatMessageUseCase>(
    (ref) => PostChatMessageUseCase(ref.watch(aiRepositoryProvider)));
