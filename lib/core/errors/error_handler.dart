import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_exception.dart';

class ErrorHandler {
  static AppException handleError(dynamic error) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return _handleDioError(error);
    }

    if (error is FirebaseAuthException) {
      return _handleFirebaseAuthError(error);
    }

    if (error is FirebaseException) {
      return _handleFirebaseStorageError(error);
    }

    return UnknownException(
      '未知错误: ${error.toString()}',
      originalError: error,
    );
  }

  static NetworkException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const NetworkException('连接超时，请检查网络连接');
      case DioExceptionType.sendTimeout:
        return const NetworkException('发送超时，请重试');
      case DioExceptionType.receiveTimeout:
        return const NetworkException('接收超时，请重试');
      case DioExceptionType.badResponse:
        return NetworkException(
          '服务器错误 (${error.response?.statusCode})',
          code: error.response?.statusCode.toString(),
        );
      case DioExceptionType.cancel:
        return const NetworkException('请求已取消');
      case DioExceptionType.connectionError:
        return const NetworkException('网络连接失败，请检查网络设置');
      default:
        return NetworkException(
          '网络请求失败: ${error.message}',
          originalError: error,
        );
    }
  }

  static AuthException _handleFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return const AuthException('用户不存在');
      case 'wrong-password':
        return const AuthException('密码错误');
      case 'email-already-in-use':
        return const AuthException('邮箱已被使用');
      case 'weak-password':
        return const AuthException('密码强度不够');
      case 'invalid-email':
        return const AuthException('邮箱格式不正确');
      case 'user-disabled':
        return const AuthException('账户已被禁用');
      case 'too-many-requests':
        return const AuthException('请求过于频繁，请稍后再试');
      case 'operation-not-allowed':
        return const AuthException('操作不被允许');
      default:
        return AuthException(
          '认证失败: ${error.message}',
          code: error.code,
          originalError: error,
        );
    }
  }

  static StorageException _handleFirebaseStorageError(FirebaseException error) {
    switch (error.code) {
      case 'storage/unauthorized':
        return const StorageException('没有权限访问存储');
      case 'storage/canceled':
        return const StorageException('上传已取消');
      case 'storage/unknown':
        return const StorageException('存储服务出现未知错误');
      case 'storage/object-not-found':
        return const StorageException('文件不存在');
      case 'storage/bucket-not-found':
        return const StorageException('存储桶不存在');
      case 'storage/project-not-found':
        return const StorageException('项目不存在');
      case 'storage/quota-exceeded':
        return const StorageException('存储配额已超出');
      case 'storage/unauthenticated':
        return const StorageException('用户未认证');
      case 'storage/retry-limit-exceeded':
        return const StorageException('重试次数超出限制');
      default:
        return StorageException(
          "存储操作失败: ${error.message}",
          code: error.code,
          originalError: error,
        );
    }
  }
}
