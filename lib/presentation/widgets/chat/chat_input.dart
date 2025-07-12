import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/services/file_upload_service.dart';
import '../../../dependency_injection.dart';

class ChatInput extends ConsumerStatefulWidget {
  final Function(String) onSendMessage;
  final bool isLoading;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    this.isLoading = false,
  });

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _audioPath;

  @override
  void dispose() {
    _controller.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      // 请求录音权限
      final permission = await Permission.microphone.request();
      if (!permission.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('需要录音权限才能使用语音功能')),
        );
        return;
      }

      // 开始录音
      final hasPermission = await _audioRecorder.hasPermission();
      if (hasPermission) {
        await _audioRecorder.start();
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('录音启动失败: $e')),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _audioPath = path;
      });

      if (path != null) {
        // TODO: 实现语音转文字功能
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('语音录制完成，语音转文字功能开发中')),
        );
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('录音停止失败: $e')),
      );
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightCream,
        border: Border(
          top: BorderSide(
            color: AppTheme.primaryOrange.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 语音录制按钮
          GestureDetector(
            onTapDown: (_) => _startRecording(),
            onTapUp: (_) => _stopRecording(),
            onTapCancel: () => _stopRecording(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    _isRecording ? AppTheme.errorRed : AppTheme.primaryOrange,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.warmShadow,
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 文本输入框
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppTheme.primaryOrange.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: '输入你的想法...',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 发送按钮
          GestureDetector(
            onTap: widget.isLoading ? null : _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.isLoading
                    ? AppTheme.primaryOrange.withOpacity(0.5)
                    : AppTheme.primaryOrange,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppTheme.warmShadow,
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 24,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
