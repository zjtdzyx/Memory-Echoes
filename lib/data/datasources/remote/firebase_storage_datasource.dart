import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

abstract class FirebaseStorageDataSource {
  Future<String> uploadImage(File imageFile, String userId);
  Future<String> uploadAudio(File audioFile, String userId);
  Future<void> deleteFile(String fileUrl);
  Future<List<String>> uploadMultipleImages(List<File> imageFiles, String userId);
}

class FirebaseStorageDataSourceImpl implements FirebaseStorageDataSource {
  final FirebaseStorage _storage;

  FirebaseStorageDataSourceImpl(this._storage);

  @override
  Future<String> uploadImage(File imageFile, String userId) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
      final ref = _storage.ref().child('images/$userId/$fileName');
      
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'userId': userId,
            'uploadTime': DateTime.now().toIso8601String(),
          },
        ),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('图片上传失败: $e');
    }
  }

  @override
  Future<String> uploadAudio(File audioFile, String userId) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(audioFile.path)}';
      final ref = _storage.ref().child('audio/$userId/$fileName');
      
      final uploadTask = ref.putFile(
        audioFile,
        SettableMetadata(
          contentType: 'audio/mpeg',
          customMetadata: {
            'userId': userId,
            'uploadTime': DateTime.now().toIso8601String(),
          },
        ),
      );

      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('音频上传失败: $e');
    }
  }

  @override
  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('文件删除失败: $e');
    }
  }

  @override
  Future<List<String>> uploadMultipleImages(List<File> imageFiles, String userId) async {
    final List<String> downloadUrls = [];
    
    for (final imageFile in imageFiles) {
      try {
        final url = await uploadImage(imageFile, userId);
        downloadUrls.add(url);
      } catch (e) {
        // 如果某个文件上传失败，继续上传其他文件
        print('文件上传失败: ${imageFile.path}, 错误: $e');
      }
    }
    
    return downloadUrls;
  }
}
