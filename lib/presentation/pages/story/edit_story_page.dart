import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memory_echoes/domain/entities/story_entity.dart';
import 'package:memory_echoes/presentation/providers/story_provider.dart';

class EditStoryPage extends ConsumerWidget {
  final String storyId;
  const EditStoryPage({super.key, required this.storyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyState = ref.watch(storyDetailProvider(storyId));

    return storyState.when(
      data: (story) {
        return _EditStoryView(story: story);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _EditStoryView extends ConsumerStatefulWidget {
  final StoryEntity story;
  const _EditStoryView({required this.story});

  @override
  ConsumerState<_EditStoryView> createState() => _EditStoryViewState();
}

class _EditStoryViewState extends ConsumerState<_EditStoryView> {
  late final GlobalKey<FormState> _formKey;
  late String _title;
  late String _content;
  late StoryMood _mood;
  late List<String> _tags;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _title = widget.story.title;
    _content = widget.story.content;
    _mood = widget.story.mood;
    _tags = List.from(widget.story.tags);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedStory = widget.story.copyWith(
        title: _title,
        content: _content,
        mood: _mood,
        tags: _tags,
      );

      ref.read(storyListProvider.notifier).updateStory(updatedStory).then((_) {
        // Refresh the detail provider so the changes are visible when we pop back
        ref.refresh(storyDetailProvider(widget.story.id!));
        context.pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Update failed: $error')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑故事'),
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
                initialValue: _title,
                decoration: const InputDecoration(labelText: '标题'),
                validator: (value) => value!.isEmpty ? '标题不能为空' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _content,
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
              TextFormField(
                initialValue: _tags.join(', '),
                decoration: const InputDecoration(labelText: '标签 (用逗号分隔)'),
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _tags.clear();
                    _tags.addAll(value.split(',').map((e) => e.trim()));
                  } else {
                    _tags.clear();
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
