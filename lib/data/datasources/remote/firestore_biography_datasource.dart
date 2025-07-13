import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memory_echoes/data/models/biography_model.dart';

class FirestoreBiographyDataSource {
  final FirebaseFirestore _firestore;

  FirestoreBiographyDataSource(this._firestore);

  Future<List<BiographyModel>> getUserBiographies(String userId) async {
    final snapshot = await _firestore
        .collection('biographies')
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return BiographyModel.fromJson(data).copyWith(id: doc.id);
    }).toList();
  }

  Future<BiographyModel> getBiographyById(String biographyId) async {
    final doc =
        await _firestore.collection('biographies').doc(biographyId).get();
    if (!doc.exists) {
      throw Exception('传记不存在');
    }
    final data = doc.data() as Map<String, dynamic>;
    return BiographyModel.fromJson(data).copyWith(id: doc.id);
  }

  Future<BiographyModel> createBiography(BiographyModel biography) async {
    final docRef =
        await _firestore.collection('biographies').add(biography.toJson());
    return biography.copyWith(id: docRef.id);
  }

  Future<BiographyModel> updateBiography(BiographyModel biography) async {
    if (biography.id.isEmpty) {
      throw Exception('传记ID不能为空');
    }

    final updatedBiography = biography.copyWith(updatedAt: DateTime.now());
    await _firestore
        .collection('biographies')
        .doc(biography.id)
        .update(updatedBiography.toJson());

    return updatedBiography;
  }

  Future<void> deleteBiography(String biographyId) async {
    await _firestore.collection('biographies').doc(biographyId).delete();
  }

  Future<List<BiographyModel>> getPublicBiographies() async {
    final snapshot = await _firestore
        .collection('biographies')
        .where('isPublic', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .limit(20)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return BiographyModel.fromJson(data).copyWith(id: doc.id);
    }).toList();
  }
}
