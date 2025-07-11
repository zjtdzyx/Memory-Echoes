import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../data/datasources/remote/firebase_storage_datasource.dart';

class FileUploadService {
  final FirebaseStorageDataSource _storageDataSource;
  final ImagePicker _imagePicker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();

  FileUploadService(this._storageDataSource);

  // 选择并上传单张图片
  Future<String?> pickAndUploadImage(String userId, {ImageSource source = ImageSource.gallery}) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      final File imageFile = File(pickedFile.path);
      return await _storageDataSource.uploadImage(imageFile, userId);
    } catch (e) {
      throw Exception('图片选择和上传失败: $e');
    }
  }

  // 选择并上传多张图片
  Future<List<String>> pickAndUploadMultipleImages(String userId) async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFiles.isEmpty) return [];

      final List<File> imageFiles = pickedFiles.map((file) => File(file.path)).toList();
      return await _storageDataSource.uploadMultipleImages(imageFiles, userId);
    } catch (e) {
      throw Exception('多图片选择和上传失败: $e');
    }
  }

  // 开始录音
  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final Directory tempDir = await getTemporaryDirectory();
        final String filePath = '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: filePath,
        );
      } else {
        throw Exception('录音权限未授予');
      }
    } catch (e) {
      throw Exception('开始录音失败: $e');
    }
  }

  // 停止录音并上传
  Future<String?> stopRecordingAndUpload(String userId) async {
    try {
      final String? filePath = await _audioRecorder.stop();
      
      if (filePath == null) return null;

      final File audioFile = File(filePath);
      if (!audioFile.existsSync()) return null;

      final String downloadUrl = await _storageDataSource.uploadAudio(audioFile, userId);
      
      // 删除临时文件
      await audioFile.delete();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('停止录音和上传失败: $e');
    }
  }

  // 取消录音
  Future<void> cancelRecording() async {
    try {
      await _audioRecorder.cancel();
    } catch (e) {
      throw Exception('取消录音失败: $e');
    }
  }

  // 检查录音状态
  Future<bool> isRecording() async {
    return await _audioRecorder.isRecording();
  }

  // 删除文件
  Future<void> deleteFile(String fileUrl) async {
    try {
      await _storageDataSource.deleteFile(fileUrl);
    } catch (e) {
      throw Exception('删除文件失败: $e');
    }
  }

  // 压缩图片
  Future<File> compressImage(File imageFile) async {
    try {
      // 这里可以使用 flutter_image_compress 包来压缩图片
      // 暂时返回原文件
      return imageFile;
    } catch (e) {
      throw Exception('图片压缩失败: $e');
    }
  }

  // 获取文件大小
  Future<int> getFileSize(String filePath) async {
    try {
      final File file = File(filePath);
      return await file.length();
    } catch (e) {
      return 0;
    }
  }

  // 验证文件类型
  bool isValidImageFile(String filePath) {
    final String extension = filePath.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }

  bool isValidAudioFile(String filePath) {
    final String extension = filePath.toLowerCase().split('.').last;
    return ['mp3', 'm4a', 'wav', 'aac'].contains(extension);
  }
}
