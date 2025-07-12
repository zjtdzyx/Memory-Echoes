import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/file_upload_service.dart';
import '../../dependency_injection.dart';

// 文件上传状态 Provider
final fileUploadStateProvider = StateNotifierProvider<FileUploadNotifier, FileUploadState>((ref) {
  return FileUploadNotifier(ref.watch(fileUploadServiceProvider));
});

// 文件上传状态
class FileUploadState {
  final bool isUploading;
  final double progress;
  final String? error;
  final List<String> uploadedUrls;

  const FileUploadState({
    this.isUploading = false,
    this.progress = 0.0,
    this.error,
    this.uploadedUrls = const [],
  });

  FileUploadState copyWith({
    bool? isUploading,
    double? progress,
    String? error,
    List<String>? uploadedUrls,
  }) {
    return FileUploadState(
      isUploading: isUploading ?? this.isUploading,
      progress: progress ?? this.progress,
      error: error ?? this.error,
      uploadedUrls: uploadedUrls ?? this.uploadedUrls,
    );
  }
}

// 文件上传通知器
class FileUploadNotifier extends StateNotifier<FileUploadState> {
  final FileUploadService _fileUploadService;

  FileUploadNotifier(this._fileUploadService) : super(const FileUploadState());

  Future<void> uploadImages(List<String> imagePaths, String userId) async {
    state = state.copyWith(isUploading: true, error: null);

    try {
      final urls = await _fileUploadService.pickAndUploadMultipleImages(userId);
      
      state = state.copyWith(
        isUploading: false,
        progress: 1.0,
        uploadedUrls: urls,
      );
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = const FileUploadState();
  }
}
