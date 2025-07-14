import '../entities/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteEntity>> getUserFavorites(String userId);
  Future<List<FavoriteEntity>> getFavoritesByType(
      String userId, String itemType);
  Future<void> addToFavorites(FavoriteEntity favorite);
  Future<void> removeFromFavorites(String favoriteId);
  Future<bool> isFavorite(String userId, String itemId);
}
