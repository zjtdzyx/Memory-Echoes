import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../common/warm_card.dart';

class StoryEditor extends StatefulWidget {
  final TextEditingController contentController;
  final Function(List<String>) onImagesChanged;
  final Function(String?) onAudioChanged;

  const StoryEditor({
    super.key,
    required this.contentController,
    required this.onImagesChanged,
    required this.onAudioChanged,
  });

  @override
  State<StoryEditor> createState() => _StoryEditorState();
}

class _StoryEditorState extends State<StoryEditor> {
  final List<String> _selectedImages = [];
  String? _audioUrl;
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 内容输入框
        WarmCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: widget.contentController,
              maxLines: null,
              minLines: 8,
              decoration: const InputDecoration(
                hintText: '在这里记录你的温暖回忆...\n\n可以描述当时的场景、心情、或者任何让你印象深刻的细节。',
                border: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 媒体工具栏
        WarmCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '添加媒体',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                
                // 工具按钮
                Row(
                  children: [
                    _MediaButton(
                      icon: Icons.photo_outlined,
                      label: '照片',
                      onPressed: _pickImages,
                    ),
                    const SizedBox(width: 16),
                    _MediaButton(
                      icon: _isRecording ? Icons.stop : Icons.mic_outlined,
                      label: _isRecording ? '停止' : '录音',
                      onPressed: _toggleRecording,
                      isActive: _isRecording,
                    ),
                    const SizedBox(width: 16),
                    _MediaButton(
                      icon: Icons.camera_alt_outlined,
                      label: '拍照',
                      onPressed: _takePhoto,
                    ),
                  ],
                ),
                
                // 已选择的图片预览
                if (_selectedImages.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: index < _selectedImages.length - 1 ? 8 : 0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  child: const Icon(Icons.image),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
                
                // 音频预览
                if (_audioUrl != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.audiotrack,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '录音文件',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _removeAudio,
                          icon: Icon(
                            Icons.close,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((image) => image.path));
      });
      widget.onImagesChanged(_selectedImages);
    }
  }

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      setState(() {
        _selectedImages.add(image.path);
      });
      widget.onImagesChanged(_selectedImages);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    widget.onImagesChanged(_selectedImages);
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
    
    if (_isRecording) {
      // TODO: 开始录音
    } else {
      // TODO: 停止录音并保存
      setState(() {
        _audioUrl = 'recorded_audio_url'; // 模拟录音URL
      });
      widget.onAudioChanged(_audioUrl);
    }
  }

  void _removeAudio() {
    setState(() {
      _audioUrl = null;
    });
    widget.onAudioChanged(null);
  }
}

class _MediaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isActive;

  const _MediaButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive 
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : null,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isActive 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
