/*class ProductData {
  Data? data;

  ProductData({this.data});

  ProductData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  TruncatedOrderStatusToReady? truncatedOrderStatusToReady;

  Data({this.truncatedOrderStatusToReady});

  Data.fromJson(Map<String, dynamic> json) {
    truncatedOrderStatusToReady = json['truncatedOrderStatusToReady'] != null
        ? new TruncatedOrderStatusToReady.fromJson(
        json['truncatedOrderStatusToReady'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.truncatedOrderStatusToReady != null) {
      data['truncatedOrderStatusToReady'] =
          this.truncatedOrderStatusToReady!.toJson();
    }
    return data;
  }
}*/

class TruncatedOrderStatusToReadyModel {
  String? id;
  int? orderNumber;
  List<Products>? products;
  var totalPrice;
  var totalPriceDelivery;

  TruncatedOrderStatusToReadyModel(
      {this.id,
        this.orderNumber,
        this.products,
        this.totalPrice,
        this.totalPriceDelivery});

  TruncatedOrderStatusToReadyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['orderNumber'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    totalPrice = json['totalPrice'];
    totalPriceDelivery = json['totalPriceDelivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['totalPrice'] = this.totalPrice;
    data['totalPriceDelivery'] = this.totalPriceDelivery;
    return data;
  }
}

class Products {
  String? id;
  Productid? productid;
  int? productPrice;
  int? quantity;
  int? shopAssistantQuantity;
  String? price;
  int? status;

  Products(
      {this.id,
        this.productid,
        this.productPrice,
        this.quantity,
        this.shopAssistantQuantity,
        this.price,
        this.status});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productid = json['productid'] != null
        ? new Productid.fromJson(json['productid'])
        : null;
    productPrice = json['productPrice'];
    quantity = json['quantity'];
    shopAssistantQuantity = json['shopAssistantQuantity'];
    price = json['price'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.productid != null) {
      data['productid'] = this.productid!.toJson();
    }
    data['productPrice'] = this.productPrice;
    data['quantity'] = this.quantity;
    data['shopAssistantQuantity'] = this.shopAssistantQuantity;
    data['price'] = this.price;
    data['status'] = this.status;
    return data;
  }
}

class Productid {
  String? productname;

  Productid({this.productname});

  Productid.fromJson(Map<String, dynamic> json) {
    productname = json['productname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productname'] = this.productname;
    return data;
  }
}