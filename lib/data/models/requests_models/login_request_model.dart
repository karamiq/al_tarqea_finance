import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../utils/annotations/annotations_lib.dart';

part 'login_request_model.freezed.dart';
part 'login_request_model.g.dart';

@freezedRequest
abstract class LoginRequestModel with _$LoginRequestModel {
  const LoginRequestModel._();

  @jsonSerializableRequest
  const factory LoginRequestModel({
    required String firstName,
    required String lastName,
  }) = _LoginRequestModel;

  @override
  Map<String, dynamic> toJson() =>
      _$LoginRequestModelToJson(this as _LoginRequestModel);
}
