import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/domain/entities/story_entity.dart';
import 'package:memory_echoes/data/models/story_model.dart';
import '../../../domain/enums/story_mood.dart';
import 'package:memory_echoes/presentation/providers/story_provider.dart';
import 'package:memory_echoes/presentation/providers/auth_provider.dart';

class CreateStoryPage extends ConsumerStatefulWidget {
  const CreateStoryPage({super.key});

  @override
  ConsumerState<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends ConsumerState<CreateStoryPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  StoryMood _mood = StoryMood.neutral;
  final List<String> _tags = [];
  final List<String> _imageUrls =
      []; // For simplicity, we'll manage URLs directly

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authState = ref.read(authProvider);
      final userId = authState.whenOrNull(authenticated: (user) => user.id);

      if (userId != null) {
        final newStory = StoryModel(
          userId: userId,
          title: _title,
          content: _content,
          mood: _mood,
          tags: _tags,
          imageUrls: _imageUrls,
          createdAt: DateTime.now(),
          isPublic: false,
        );
        try {
          await ref
              .read(storyListProvider(userId).notifier)
              .createStory(newStory);
          if (mounted) context.pop();
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('创建失败: $e')));
          }
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('用户未登录，无法创建故事')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // This page should not be reachable if unauthenticated, but as a safeguard:
    ref.watch(authProvider).whenOrNull(
      unauthenticated: (_) {
        Future.microtask(() => context.go('/login'));
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('创建新的记忆'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: '标题'),
                validator: (value) => value!.isEmpty ? '标题不能为空' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '内容'),
                maxLines: 10,
                validator: (value) => value!.isEmpty ? '内容不能为空' : null,
                onSaved: (value) => _content = value!,
              ),
              DropdownButtonFormField<StoryMood>(
                value: _mood,
                decoration: const InputDecoration(labelText: '心情'),
                items: StoryMood.values
                    .map((mood) => DropdownMenuItem(
                          value: mood,
                          child: Text(mood.toString().split('.').last),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _mood = value;
                    });
                  }
                },
              ),
              // A simple way to manage tags and images for this example
              TextFormField(
                decoration: const InputDecoration(labelText: '标签 (用逗号分隔)'),
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _tags.clear();
                    _tags.addAll(value.split(',').map((e) => e.trim()));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
