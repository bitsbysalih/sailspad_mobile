import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '../../app/models/user.dart';
import '../../app/networking/dio/base_api_service.dart';

class UserApiService extends BaseApiService {
  UserApiService({BuildContext? buildContext}) : super(buildContext);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  ///Sign up new User
  Future<User?> signUp({required dynamic data}) async {
    return await network<User>(
      request: (request) => request.post("/auth/signup", data: data),
    );
  }

  Future<User?> signIn({required dynamic data}) async {
    return await network<User>(
      request: (request) => request.post("/auth/signin", data: data),
    );
  }

  Future<dynamic> resendOtp() async {
    return await network(
      request: (request) => request.get("/auth/resend-otp"),
    );
  }

  Future<dynamic> verifyOtp({dynamic query}) async {
    return await network(
      request: (request) => request.post(
        "/auth/validate-email",
        queryParameters: query,
      ),
    );
  }

  Future<dynamic> addContactLinks({dynamic data}) async {
    return await network(
      request: (request) => request.put(
        "/user/",
        data: data,
      ),
    );
  }

  Future<dynamic> getuserDetails() async {
    return await network(
      request: (request) => request.get("/user/"),
    );
  }

  /// Find a User
  Future<User?> find({required int id}) async {
    return await network<User>(
      request: (request) => request.get("/endpoint-path/$id"),
    );
  }

  /// Create a User
  Future<User?> create({required dynamic data}) async {
    return await network<User>(
      request: (request) => request.post("/endpoint-path", data: data),
    );
  }

  /// Update a User
  Future<User?> update({dynamic query}) async {
    return await network<User>(
      request: (request) =>
          request.put("/endpoint-path", queryParameters: query),
    );
  }

  /// Delete a User
  Future<bool?> delete({required int id}) async {
    return await network<bool>(
      request: (request) => request.delete("/endpoint-path/$id"),
    );
  }

  displayError(DioError dioError, BuildContext context) {
    showToastNotification(
      context,
      title: 'Error on Sign up',
      description: dioError.response!.data['message'],
      style: ToastNotificationStyleType.DANGER,
    );
  }
}
