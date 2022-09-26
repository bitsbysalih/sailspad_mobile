import 'package:flutter/material.dart';
import '../../app/networking/dio/base_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '../../app/models/ar_card.dart';

class ArCardApiService extends BaseApiService {
  ArCardApiService({BuildContext? buildContext}) : super(buildContext);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  String? cardToEditId = '';

  /// Return a list of users
  Future<List<ArCard>?> fetchAll() async {
    return await network<List<ArCard>>(
      request: (request) => request.get("/card"),
    );
  }

  /// Find a ArCard
  Future<ArCard?> find({required String id}) async {
    return await network<ArCard>(
      request: (request) => request.get("/card/$id/details"),
    );
  }

  /// Create a ArCard
  Future<ArCard?> create({required dynamic data}) async {
    return await network<ArCard>(
      request: (request) => request.post("/card", data: data),
    );
  }

  Future<dynamic> listMarkers() async {
    return await network(
      request: (request) => request.get(
        "/card/marker",
      ),
    );
  }

  /// Update a ArCard
  Future<ArCard?> update({dynamic data, String, id}) async {
    return await network<ArCard>(
      request: (request) => request.put("/card/$id/edit", data: data),
    );
  }

  /// Delete a ArCard
  Future<bool?> delete({required int id}) async {
    return await network<bool>(
      request: (request) => request.delete("/endpoint-path/$id"),
    );
  }

  void setCardToEdit(String id) {
    cardToEditId = id;
  }

  String? returnCardId() {
    return cardToEditId;
  }

  displayError(DioError dioError, BuildContext context) {
    showToastNotification(
      context,
      title: 'Error Creating card',
      description: dioError.response!.data['errors'].toString(),
      style: ToastNotificationStyleType.DANGER,
    );
  }
}
