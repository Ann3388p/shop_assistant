
class TruncatedFlowOrderDetailsModel {
  String? id;
  int? orderNumber;
  var totalPrice;
  var totalPriceDelivery;
  String? deliveryAddress;
  String? deliveryDate;
  List<Stats>? stats;

  List<Products>? products;
  Storeid? storeid;
  String? deliveryTime;
  ShopAssistantId? shopAssistantId;
  ShopAssistantId? deliveryPartnerId;
  String? lastStatus;
  int? paymentStatus;
  int? deliveryCharge;

  TruncatedFlowOrderDetailsModel(
      {this.id,
        this.orderNumber,
        this.totalPrice,
        this.totalPriceDelivery,
        this.deliveryAddress,
        this.stats,
        this.deliveryDate,
        this.products,
        this.storeid,
        this.deliveryTime,
        this.shopAssistantId,
        this.deliveryPartnerId,
        this.lastStatus,
        this.paymentStatus,
        this.deliveryCharge});

  TruncatedFlowOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['orderNumber'];
    totalPrice = json['totalPrice'];
    totalPriceDelivery = json['totalPriceDelivery'];
    deliveryAddress = json['deliveryAddress'];
    deliveryDate = json['deliveryDate'];
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
    storeid =
    json['storeid'] != null ? new Storeid.fromJson(json['storeid']) : null;
    deliveryTime = json['deliveryTime'];
    shopAssistantId = json['shopAssistantId'] != null
        ? new ShopAssistantId.fromJson(json['shopAssistantId'])
        : null;
    deliveryPartnerId = json['deliveryPartnerId'] != null
        ? new ShopAssistantId.fromJson(json['deliveryPartnerId'])
        : null;
    lastStatus = json['lastStatus'];
    paymentStatus = json['paymentStatus'];
    deliveryCharge = json['deliveryCharge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    data['totalPrice'] = this.totalPrice;
    data['totalPriceDelivery'] = this.totalPriceDelivery;
    data['deliveryAddress'] = this.deliveryAddress;
    data['deliveryDate'] = this.deliveryDate;
    if (this.stats != null) {
      data['stats'] = this.stats!.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.storeid != null) {
      data['storeid'] = this.storeid!.toJson();
    }
    data['deliveryTime'] = this.deliveryTime;
    if (this.shopAssistantId != null) {
      data['shopAssistantId'] = this.shopAssistantId!.toJson();
    }
    if (this.deliveryPartnerId != null) {
      data['deliveryPartnerId'] = this.deliveryPartnerId!.toJson();
    }
    data['lastStatus'] = this.lastStatus;
    data['paymentStatus'] = this.paymentStatus;
    data['deliveryCharge'] = this.deliveryCharge;
    return data;
  }
}

class Stats {
  String? createdTime;
  String? created;

  Stats({this.createdTime});

  Stats.fromJson(Map<String, dynamic> json) {
    created = json['created'];
    createdTime = json['createdTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created'] = this.created;
    data['createdTime'] = this.createdTime;
    return data;
  }
}


class Products {
  String? id;
  int? status;
  int? shopAssistantQuantity;
  int? quantity;
  Productid? productid;

  Products({this.id,this.status,
    this.quantity,
    this.shopAssistantQuantity, this.productid});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    shopAssistantQuantity = json['shopAssistantQuantity'];
    quantity = json['quantity'];
    productid = json['productid'] != null
        ? new Productid.fromJson(json['productid'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['quantity'] = this.quantity;
    data['shopAssistantQuantity'] = this.shopAssistantQuantity;
    if (this.productid != null) {
      data['productid'] = this.productid!.toJson();
    }
    return data;
  }
}

class Productid {
  String? id;
  String? price;
  String? promoprice;
  String? productname;
  String? quantity;
  Image? image;
  String? uom;

  Productid(
      {this.id,
        this.price,
        this.promoprice,
        this.productname,
        this.quantity,
        this.image,
        this.uom,
      });

  Productid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    promoprice = json['promoprice'];
    productname = json['productname'];
    quantity = json['quantity'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    uom = json['uom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['promoprice'] = this.promoprice;
    data['productname'] = this.productname;
    data['quantity'] = this.quantity;
    data['uom'] = this.uom;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}

class Image {
  String? primary;

  Image({this.primary});

  Image.fromJson(Map<String, dynamic> json) {
    primary = json['primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['primary'] = this.primary;
    return data;
  }
}

class Storeid {
  String? storeName;

  Storeid({this.storeName});

  Storeid.fromJson(Map<String, dynamic> json) {
    storeName = json['storeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storeName'] = this.storeName;
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