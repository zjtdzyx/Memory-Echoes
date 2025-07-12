import 'package:memory_echoes/data/datasources/remote/firestore_biography_datasource.dart';
import 'package:memory_echoes/domain/entities/biography_entity.dart';
import 'package:memory_echoes/domain/repositories/biography_repository.dart';

class BiographyRepositoryImpl implements BiographyRepository {
  final FirestoreBiographyDataSource _remoteDataSource;

  BiographyRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<BiographyEntity>> getUserBiographies(String userId) {
    return _remoteDataSource.getUserBiographies(userId);
  }

  @override
  Future<BiographyEntity> getBiographyById(String biographyId) {
    return _remoteDataSource.getBiographyById(biographyId);
  }

  @override
  Future<BiographyEntity> createBiography(BiographyEntity biography) {
    return _remoteDataSource.createBiography(biography as dynamic);
  }

  @override
  Future<BiographyEntity> updateBiography(BiographyEntity biography) {
    return _remoteDataSource.updateBiography(biography as dynamic);
  }

  @override
  Future<void> deleteBiography(String biographyId) {
    return _remoteDataSource.deleteBiography(biographyId);
  }
}
