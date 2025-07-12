import '../entities/biography_entity.dart';

abstract class BiographyRepository {
  Future<List<BiographyEntity>> getUserBiographies(String userId);
  Future<List<BiographyEntity>> getBiographies(String userId) =>
      getUserBiographies(userId);
  Future<BiographyEntity> getBiographyById(String biographyId);
  Future<BiographyEntity> createBiography(BiographyEntity biography);
  Future<BiographyEntity> updateBiography(BiographyEntity biography);
  Future<void> deleteBiography(String biographyId);
}
