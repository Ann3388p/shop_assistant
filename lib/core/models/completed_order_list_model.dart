import 'package:shop_assistant/core/models/order_details_model.dart';
import 'package:shop_assistant/core/models/order_list_model.dart';

class CompletedOrderListModel{
  int? count;
  List<OrderListModel>? items;
  CompletedOrderListModel({
    this.count,
    this.items
  });
  CompletedOrderListModel.fromJson(Map<String, dynamic> json){
    count = json["count"];
    items = [];
    if(json["items"]!=null){
      json["items"].forEach((val)=>items!.add(OrderListModel.fromJson(val)));
    }
  }
}