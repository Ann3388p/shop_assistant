class ShoppingCountModel {
  int? availableOrdersList;
  int? assignedOrdersList;
  int? totalCountShopping;
  int? readyOrdersList;
  int? readyOrdersListOfShopAssistant;
  int? totalCountDelivery;

  ShoppingCountModel(
      {this.availableOrdersList,
        this.assignedOrdersList,
        this.totalCountShopping,
        this.readyOrdersList,
        this.readyOrdersListOfShopAssistant,
        this.totalCountDelivery});

  ShoppingCountModel.fromJson(Map<String, dynamic> json) {
    availableOrdersList = json['availableOrdersList'];
    assignedOrdersList = json['assignedOrdersList'];
    totalCountShopping = json['totalCountShopping']??0;
    readyOrdersList = json['readyOrdersList'];
    readyOrdersListOfShopAssistant = json['readyOrdersListOfShopAssistant'];
    totalCountDelivery = json['totalCountDelivery']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['availableOrdersList'] = this.availableOrdersList;
    data['assignedOrdersList'] = this.assignedOrdersList;
    data['totalCountShopping'] = this.totalCountShopping;
    data['readyOrdersList'] = this.readyOrdersList;
    data['readyOrdersListOfShopAssistant'] =
        this.readyOrdersListOfShopAssistant;
    data['totalCountDelivery'] = this.totalCountDelivery;
    return data;
  }
}