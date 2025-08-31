import 'dart:io';

import 'package:al_tarqea_finance/data/models/authentication_model.dart';
import 'package:al_tarqea_finance/data/models/requests_models/login_request_model.dart';
import 'package:al_tarqea_finance/data/repositories/balance_repository.dart';
import 'package:al_tarqea_finance/data/services/clients/_clients.dart';
import 'package:al_tarqea_finance/data/repositories/file_upload_service.dart';
import 'package:al_tarqea_finance/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref);
}

class AuthRepository {
  final Ref ref;
  AuthRepository(this.ref);
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  final String _collection = 'users';

  Future<AuthenticationModel> login(LoginRequestModel request) async {
    final query = await _firestore
        .collection(_collection)
        .where('firstName', isEqualTo: request.firstName)
        .where('lastName', isEqualTo: request.lastName)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      final data = doc.data();
      return AuthenticationModel.fromJson(data).copyWith(uid: doc.id);
    } else {
      Utils.showErrorOverlay('المستخدم غير موجود');
      throw ('المستخدم غير موجود');
    }
  }

  Future<AuthenticationModel> signup({
    required String firstName,
    required String lastName,
    required File selectedImage,
  }) async {
    try {
      // check duplicate
      final existing = await _firestore
          .collection(_collection)
          .where('firstName', isEqualTo: firstName)
          .where('lastName', isEqualTo: lastName)
          .get();

      if (existing.docs.isNotEmpty) {
        Utils.showErrorOverlay('المستخدم موجود بالفعل');
        throw ('المستخدم موجود بالفعل');
      }

      final docRef = _firestore.collection(_collection).doc();
      final uid = docRef.id;

      final profileImageUrl =
          await ref.read(fileUploadServiceProvider).uploadFile(selectedImage, path: 'profile/$uid');

      await ref.read(balanceRepositoryProvider).setBalance(1000.0, userId: uid);

      final newUser = AuthenticationModel(
        uid: uid,
        firstName: firstName,
        lastName: lastName,
        profileImageUrl: profileImageUrl,
      );

      await docRef.set(newUser.toJson());

      return newUser;
    } catch (e) {
      rethrow;
    }
  }
}
