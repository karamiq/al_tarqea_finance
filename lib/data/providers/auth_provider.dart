import 'dart:io';

import 'package:al_tarqea_finance/data/models/requests_models/login_request_model.dart';
import 'package:al_tarqea_finance/data/providers/authentication_provider.dart';
import 'package:al_tarqea_finance/data/repositories/auth_repository.dart';

import '../models/authentication_model.dart';
import '../services/clients/_clients.dart';

part 'auth_provider.g.dart';

@riverpod
class Login extends _$Login with AsyncXNotifierMixin<AuthenticationModel> {
  @override
  Future<AsyncX<AuthenticationModel>> build() => idle();

  @useResult
  RunXCallback<AuthenticationModel> run(LoginRequestModel data) => handle(() async {
        final user = await ref.read(authRepositoryProvider).login(data);
        await ref.read(authenticationProvider.notifier).update((state) => user);
        return user;
      });
}

@riverpod
class Signup extends _$Signup with AsyncXNotifierMixin<AuthenticationModel> {
  @override
  Future<AsyncX<AuthenticationModel>> build() => idle();

  @useResult
  RunXCallback<AuthenticationModel> run(String firstName, String lastName, File selectedImage) =>
      handle(() async {
        final user = await ref.read(authRepositoryProvider).signup(
              firstName: firstName,
              lastName: lastName,
              selectedImage: selectedImage,
            );
        // print('at the provider level Uploading file: ${selectedImage.path} ');
        await ref.read(authenticationProvider.notifier).update((state) => user);
        return user;
      });
}
