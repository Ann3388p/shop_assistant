import 'package:shop_assistant/core/models/order_details_model.dart';

class TravelTimeAndDistanceModel{
  DistanceMatrixType? travelTime;
  DistanceMatrixType? travelDistance;

  TravelTimeAndDistanceModel.fromJson(Map<String, dynamic> body){
    travelTime = DistanceMatrixType.fromJson(body['travelTime']);
    travelDistance = DistanceMatrixType.fromJson(body['travelDistance']);
  }
}