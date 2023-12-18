import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:my_app/api/auth/auth.api.dart';
import 'package:my_app/domain/dto/user/user.dto.dart';
import 'package:my_app/domain/model/user/user.model.dart';

import '../../core/response/response.dart';
import 'auth.repository.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository {
  final AuthApi _authApi;

  AuthRepositoryImpl(this._authApi);

  @override
  String? get currentUid => _authApi.currentUid;

  @override
  Future<Response<UserModel?>> getCurrentUser() async {
    try {
      final currentUser = (await _authApi.getCurrentUser())?.toModel();
      return Response<UserModel?>(
          status: currentUser != null ? Status.success : Status.error,
          data: currentUser);
    } catch (err) {
      return Response<UserModel>(status: Status.error, message: err.toString());
    }
  }

  @override
  Future<void> signOut() async => await _authApi.signOut();

  @override
  Future<Response<void>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _authApi.signInWithEmailAndPassword(email, password);
      return const Response<void>(
          status: Status.success, message: 'login success');
    } catch (err) {
      return Response<void>(status: Status.error, message: err.toString());
    }
  }

  @override
  Future<Response<UserCredential>> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential =
          await _authApi.createUserWithEmailAndPassword(email, password);
      return Response<UserCredential>(status: Status.success, data: credential);
    } catch (err) {
      return Response<UserCredential>(
          status: Status.error, message: err.toString());
    }
  }

  @override
  Future<Response<void>> saveUser(
      {required String uid,
      required String email,
      required String nickname}) async {
    try {
      await _authApi.saveUser(uid: uid, email: email, nickname: nickname);
      return const Response<void>(status: Status.success);
    } catch (err) {
      return Response<void>(status: Status.error, message: err.toString());
    }
  }
}
