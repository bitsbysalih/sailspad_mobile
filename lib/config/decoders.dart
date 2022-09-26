import 'package:sailspad/app/models/ar_card.dart';
import 'package:sailspad/app/networking/ar_card_api_service.dart';
import 'package:sailspad/app/networking/user_api_service.dart';

import '../app/models/user.dart';
import '../app/networking/api_service.dart';

/*
|--------------------------------------------------------------------------
| Model Decoders
| -------------------------------------------------------------------------
| Model decoders are used in 'app/networking/' for morphing json payloads
| into Models.
|
| Learn more https://nylo.dev/docs/3.x/decoders#model-decoders
|--------------------------------------------------------------------------
*/

final modelDecoders = {
  List<User>: (data) =>
      List.from(data).map((json) => User.fromJson(json)).toList(),
  User: (data) => User.fromJson(data),

  List<ArCard>: (data) =>
      List.from(data).map((json) => ArCard.fromJson(json)).toList(),
  ArCard: (data) => ArCard.fromJson(data),

  // User: (data) => User.fromJson(data),

  // ...
};

/*
|--------------------------------------------------------------------------
| API Decoders
| -------------------------------------------------------------------------
| API decoders are used when you need to access an API service using the
| 'api' helper. E.g. api<MyApiService>((request) => request.fetchData());
|
| Learn more https://nylo.dev/docs/3.x/decoders#api-decoders
|--------------------------------------------------------------------------
*/

final Map<Type, dynamic> apiDecoders = {
  ApiService: ApiService(),
  UserApiService: UserApiService(),
  ArCardApiService: ArCardApiService(),
  // ...
};
