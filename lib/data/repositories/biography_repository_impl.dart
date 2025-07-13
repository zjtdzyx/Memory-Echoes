import 'package:memory_echoes/domain/entities/biography_entity.dart';
import 'package:memory_echoes/domain/repositories/biography_repository.dart';

class BiographyRepositoryImpl implements BiographyRepository {
  @override
  Future<BiographyEntity> createBiography(BiographyEntity biography) async {
    // TODO: 实现传记创建逻辑
    // 暂时返回传入的biography
    return biography;
  }

  @override
  Future<BiographyEntity> getBiographyById(String biographyId) async {
    // TODO: 实现传记获取逻辑
    throw UnimplementedError('getBiographyById not implemented');
  }

  @override
  Future<List<BiographyEntity>> getUserBiographies(String userId) async {
    // TODO: 实现用户传记列表获取逻辑
    return [];
  }

  @override
  Future<List<BiographyEntity>> getBiographies(String userId) async {
    return getUserBiographies(userId);
  }

  @override
  Future<BiographyEntity> updateBiography(BiographyEntity biography) async {
    // TODO: 实现传记更新逻辑
    return biography;
  }

  @override
  Future<void> deleteBiography(String biographyId) async {
    // TODO: 实现传记删除逻辑
    throw UnimplementedError('deleteBiography not implemented');
  }
}
