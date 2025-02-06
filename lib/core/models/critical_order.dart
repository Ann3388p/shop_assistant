import 'package:shop_assistant/core/models/order_details_model.dart';

class CriticalOrder {
  String? id;
  Orderid? orderid;
  Storeid? storeid;
  int? orderNumber;
  int? counter;
  String? scheduledDateAndTime;
  int? scheduledMinutes;
  String? lastStatus;
  String? notification;
  String? updatedAt;

  CriticalOrder(
      {this.id,
      this.orderid,
      this.storeid,
      this.orderNumber,
      this.counter,
      this.scheduledDateAndTime,
      this.scheduledMinutes,
      this.lastStatus,
      this.notification,

      this.updatedAt});

  CriticalOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderid =
        json['orderid'] != null ? new Orderid.fromJson(json['orderid']) : null;
    storeid =
        json['storeid'] != null ? new Storeid.fromJson(json['storeid']) : null;
    orderNumber = json['orderNumber'];
    counter = json['counter'];
    scheduledDateAndTime = json['scheduledDateAndTime'];
    scheduledMinutes = json['scheduledMinutes'];
    lastStatus = json['lastStatus'];
    notification = json['notification'];
    updatedAt = json['updatedAt'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.orderid != null) {
      data['orderid'] = this.orderid!.toJson();
    }
    if (this.storeid != null) {
      data['storeid'] = this.storeid!.toJson();
    }
    data['orderNumber'] = this.orderNumber;
    data['counter'] = this.counter;
    data['scheduledDateAndTime'] = this.scheduledDateAndTime;
    data['scheduledMinutes'] = this.scheduledMinutes;
    data['lastStatus'] = this.lastStatus;
    data['notification'] = this.notification;
    data['updatedAt'] = this.updatedAt;

    return data;
  }
}

class Orderid {
  String? id;
  int? orderNumber;
  List<Products>? products;
  List<Stats>? stats;
  var totalPrice;
  int? productCount;
  var totalPriceUser;
  var totalPriceDelivery;
  String? deliveryType;
  String? deliveryAddress;
  String? deliveryDate;
  String? deliveryTime;
  double? deliveryLat;
  double? deliveryLng;
  String? mobileNumber;
  String? customerName;
  String? specialInstructions;
  String? commentsSeller;
  String? lastStatus;
  ShopAssistantId? shopAssistantId;

  Orderid(
      {this.id,
      this.orderNumber,
      this.products,
      this.stats,
      this.totalPrice,
      this.productCount,
      this.totalPriceUser,
      this.totalPriceDelivery,
      this.deliveryType,
      this.deliveryAddress,
      this.deliveryDate,
      this.deliveryTime,
      this.deliveryLat,
      this.deliveryLng,
      this.mobileNumber,
      this.customerName,
      this.specialInstructions,
      this.commentsSeller,
        this.shopAssistantId,
      this.lastStatus});

  Orderid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['orderNumber'];
    if (json['stats'] != null) {
      stats = <Stats>[];
      json['stats'].forEach((v) {
        stats!.add(new Stats.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    totalPrice = json['totalPrice'];
    productCount = json['productCount'];
    totalPriceUser = json['totalPriceUser'];
    totalPriceDelivery = json['totalPriceDelivery'];
    deliveryType = json['deliveryType'];
    deliveryAddress = json['deliveryAddress'];
    deliveryDate = json['deliveryDate'];
    deliveryTime = json['deliveryTime'];
    deliveryLat = json['deliveryLat'];
    deliveryLng = json['deliveryLng'];
    mobileNumber = json['mobileNumber'];
    customerName = json['customerName'];
    specialInstructions = json['specialInstructions'];
    commentsSeller = json['commentsSeller'];
    shopAssistantId = json['shopAssistantId'] != null
        ? ShopAssistantId.fromJson(json['shopAssistantId']): null;
    lastStatus = json['lastStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    if (this.stats != null) {
      data['stats'] = this.stats!.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['totalPrice'] = this.totalPrice;
    data['productCount'] = this.productCount;
    data['totalPriceUser'] = this.totalPriceUser;
    data['totalPriceDelivery'] = this.totalPriceDelivery;
    data['deliveryType'] = this.deliveryType;
    data['deliveryAddress'] = this.deliveryAddress;
    data['deliveryDate'] = this.deliveryDate;
    data['deliveryTime'] = this.deliveryTime;
    data['deliveryLat'] = this.deliveryLat;
    data['deliveryLng'] = this.deliveryLng;
    data['mobileNumber'] = this.mobileNumber;
    data['customerName'] = this.customerName;
    data['specialInstructions'] = this.specialInstructions;
    data['commentsSeller'] = this.commentsSeller;
    data['lastStatus'] = this.lastStatus;
    if (this.shopAssistantId != null)
    {
      data['shopAssistantId'] = this.shopAssistantId!.toJson();
    }
    return data;
  }
}

class Stats {
  String? status;

  Stats({this.status});

  Stats.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}

class Products {
  String? id;
  var productPrice;
  int? quantity;
  int? shopAssistantQuantity;
  String? price;
  int? status;
  Productid? productid;

  Products(
      {this.id,
      this.productPrice,
      this.quantity,
      this.shopAssistantQuantity,
      this.price,
      this.status,
      this.productid});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productPrice = json['productPrice'];
    quantity = json['quantity'];
    shopAssistantQuantity = json['shopAssistantQuantity'];
    price = json['price'];
    status = json['status'];
    productid = json['productid'] != null
        ? new Productid.fromJson(json['productid'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productPrice'] = this.productPrice;
    data['quantity'] = this.quantity;
    data['shopAssistantQuantity'] = this.shopAssistantQuantity;
    data['price'] = this.price;
    data['status'] = this.status;
    if (this.productid != null) {
      data['productid'] = this.productid!.toJson();
    }
    return data;
  }
}

class Productid {
  String? productname;
  String? id;
  String? desc;

  Productid({this.productname, this.id, this.desc});

  Productid.fromJson(Map<String, dynamic> json) {
    productname = json['productname'];
    id = json['id'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productname'] = this.productname;
    data['id'] = this.id;
    data['desc'] = this.desc;
    return data;
  }
}

class ShopAssistantId {
  String? id;
  String? firstName;
  ShopAssistantId({this.id, this.firstName});
  ShopAssistantId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    return data;
  }
}

// Web socket response
class LiveCriticalOrder {
  int? version;
  String? id;
  String? orderid;
  String? storeid;
  int? orderNumber;
  int? counter;
  String? scheduledDateAndTime;
  int? scheduledMinutes;
  String? lastStatus;
  String? notification;
  String? updatedAt;

  LiveCriticalOrder(
      {this.version,
      this.id,
      this.orderid,
      this.storeid,
      this.orderNumber,
      this.counter,
      this.scheduledDateAndTime,
      this.scheduledMinutes,
      this.lastStatus,
      this.notification,
      this.updatedAt});

  LiveCriticalOrder.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    id = json['id'];
    orderid = json['orderid'];
    storeid = json['storeid'];
    orderNumber = json['orderNumber'];
    counter = json['counter'];
    scheduledDateAndTime = json['scheduledDateAndTime'];
    scheduledMinutes = json['scheduledMinutes'];
    lastStatus = json['lastStatus'];
    notification = json['notification'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['id'] = this.id;

    data['orderid'] = this.orderid!;
    data['storeid'] = this.storeid;
    data['orderNumber'] = this.orderNumber;
    data['counter'] = this.counter;
    data['scheduledDateAndTime'] = this.scheduledDateAndTime;
    data['scheduledMinutes'] = this.scheduledMinutes;
    data['lastStatus'] = this.lastStatus;
    data['notification'] = this.notification;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

// class Orderid {
//   String? id;
//   int? orderNumber;
//   List<Products>? products;
//   var totalPrice;
//   int? productCount;
//   double? totalPriceUser;
//   String? deliveryType;
//   String? deliveryAddress;
//   String? deliveryDate;
//   String? deliveryTime;
//   double? deliveryLat;
//   double? deliveryLng;
//   String? mobileNumber;
//   String? customerName;
//   Null? specialInstructions;
//   Null? commentsSeller;
//   String? lastStatus;
//
//   Orderid(
//       {this.id,
//       this.orderNumber,
//       this.products,
//       this.totalPrice,
//       this.productCount,
//       this.totalPriceUser,
//       this.deliveryType,
//       this.deliveryAddress,
//       this.deliveryDate,
//       this.deliveryTime,
//       this.deliveryLat,
//       this.deliveryLng,
//       this.mobileNumber,
//       this.customerName,
//       this.specialInstructions,
//       this.commentsSeller,
//       this.lastStatus});
//
//   Orderid.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     orderNumber = json['orderNumber'];
//     if (json['products'] != null) {
//       products = <Products>[];
//       json['products'].forEach((v) {
//         products!.add(new Products.fromJson(v));
//       });
//     }
//     totalPrice = json['totalPrice'];
//     productCount = json['productCount'];
//     totalPriceUser = json['totalPriceUser'];
//     deliveryType = json['deliveryType'];
//     deliveryAddress = json['deliveryAddress'];
//     deliveryDate = json['deliveryDate'];
//     deliveryTime = json['deliveryTime'];
//     deliveryLat = json['deliveryLat'];
//     deliveryLng = json['deliveryLng'];
//     mobileNumber = json['mobileNumber'];
//     customerName = json['customerName'];
//     specialInstructions = json['specialInstructions'];
//     commentsSeller = json['commentsSeller'];
//     lastStatus = json['lastStatus'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['orderNumber'] = this.orderNumber;
//     if (this.products != null) {
//       data['products'] = this.products!.map((v) => v.toJson()).toList();
//     }
//     data['totalPrice'] = this.totalPrice;
//     data['productCount'] = this.productCount;
//     data['totalPriceUser'] = this.totalPriceUser;
//     data['deliveryType'] = this.deliveryType;
//     data['deliveryAddress'] = this.deliveryAddress;
//     data['deliveryDate'] = this.deliveryDate;
//     data['deliveryTime'] = this.deliveryTime;
//     data['deliveryLat'] = this.deliveryLat;
//     data['deliveryLng'] = this.deliveryLng;
//     data['mobileNumber'] = this.mobileNumber;
//     data['customerName'] = this.customerName;
//     data['specialInstructions'] = this.specialInstructions;
//     data['commentsSeller'] = this.commentsSeller;
//     data['lastStatus'] = this.lastStatus;
//     return data;
//   }
// }
//
// class Products {
//   String? id;
//   double? productPrice;
//   int? quantity;
//   Null? shopAssistantQuantity;
//   String? price;
//   int? status;
//   Productid? productid;
//
//   Products(
//       {this.id,
//       this.productPrice,
//       this.quantity,
//       this.shopAssistantQuantity,
//       this.price,
//       this.status,
//       this.productid});
//
//   Products.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productPrice = json['productPrice'];
//     quantity = json['quantity'];
//     shopAssistantQuantity = json['shopAssistantQuantity'];
//     price = json['price'];
//     status = json['status'];
//     productid = json['productid'] != null
//         ? new Productid.fromJson(json['productid'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['productPrice'] = this.productPrice;
//     data['quantity'] = this.quantity;
//     data['shopAssistantQuantity'] = this.shopAssistantQuantity;
//     data['price'] = this.price;
//     data['status'] = this.status;
//     if (this.productid != null) {
//       data['productid'] = this.productid!.toJson();
//     }
//     return data;
//   }
// }

// class Productid {
//   String? productname;
//   String? id;
//   String? desc;
//
//   Productid({this.productname, this.id, this.desc});
//
//   Productid.fromJson(Map<String, dynamic> json) {
//     productname = json['productname'];
//     id = json['id'];
//     desc = json['desc'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['productname'] = this.productname;
//     data['id'] = this.id;
//     data['desc'] = this.desc;
//     return data;
//   }
// }
