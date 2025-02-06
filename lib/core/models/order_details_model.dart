class OrderDetailsModel {
  String? id;
  int? orderNumber;
  // String? storeid;
  Storeid? storeid;
  List<Products>? products;
  var totalPrice;

  String? deliveryAddress;
  String? deliveryDate;
  String? deliveryTime;
  String? deliveryType;
  String? mobileNumber;
  String? customerName;
  String? specialInstructions;
  List<Stats>? stats;
  String? lastStatus;
  var deliveryCharge;
  var totalPriceDelivery;
  var finalBillAmount;
  var deliveryLat;
  var deliveryLng;
  int? paymentStatus;

  DeliveryPartnerId? deliveryPartnerId;
  DeliveryPartnerId? shopAssistantId;
  String ? couponId;
  var discountPrice;
  DistanceMatrixType? travelTime;
  DistanceMatrixType? travelDistance;
  String? estimatedDeliveryTime;
  OrderDetailsModel(
      {this.id,
        this.orderNumber,
        this.storeid,
        this.products,
        this.totalPrice,

        this.deliveryAddress,
        this.deliveryDate,
        this.deliveryTime,
        this.deliveryType,
        this.mobileNumber,
        this.customerName,
        this.specialInstructions,
        this.stats,
        this.lastStatus,
        this.deliveryCharge,
        this.totalPriceDelivery,
        this.deliveryPartnerId,
        this.finalBillAmount,
        this.shopAssistantId,
        this.paymentStatus,
        this.couponId,
        this.discountPrice,
        this.travelTime,
        this.travelDistance,
        this.estimatedDeliveryTime
      });

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['orderNumber'];
    // storeid = json['storeid'];
    storeid =
    json['storeid'] != null ? new Storeid.fromJson(json['storeid']) : null;
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    deliveryPartnerId = json['deliveryPartnerId'] != null
        ? new DeliveryPartnerId.fromJson(json['deliveryPartnerId'])
        : null;
    shopAssistantId = json['shopAssistantId'] != null
        ? new DeliveryPartnerId.fromJson(json['shopAssistantId'])
        : null;
    couponId = json['couponId'];
    paymentStatus = json['paymentStatus'];

    discountPrice =  json['discountPrice']??0.0;
    totalPrice = json['totalPrice'];



    deliveryAddress = json['deliveryAddress'];
    deliveryDate = json['deliveryDate'];
    deliveryTime = json['deliveryTime'];
    deliveryType = json['deliveryType'];
    mobileNumber = json['mobileNumber'];
    customerName = json['customerName'];
    deliveryLat = json['deliveryLat'];
    deliveryLng = json['deliveryLng'];
    specialInstructions = json['specialInstructions'];
    if (json['stats'] != null) {
      stats = [];
      json['stats'].forEach((v) {
        stats!.add(new Stats.fromJson(v));
      });
    }
    lastStatus = json['lastStatus'];
    deliveryCharge = json['deliveryCharge']??0.0;
    totalPriceDelivery = json['totalPriceDelivery'];
    finalBillAmount = json['finalBillAmount']??0.0;
    travelDistance = DistanceMatrixType.fromJson(json['travelDistance']);
    travelTime = DistanceMatrixType.fromJson(json['travelTime']);
    estimatedDeliveryTime = json['estimatedDeliveryTime'];
    if(finalBillAmount>0){
      totalPriceDelivery = finalBillAmount - discountPrice + deliveryCharge;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    // data['storeid'] = this.storeid;

    data['paymentStatus'] = this.paymentStatus;

    if (this.storeid != null) {
      data['storeid'] = this.storeid!.toJson();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['couponId'] = this.couponId;
    data['discountPrice'] = this.discountPrice;
    data['totalPrice'] = this.totalPrice;

    data['deliveryAddress'] = this.deliveryAddress;
    data['deliveryDate'] = this.deliveryDate;
    data['deliveryTime'] = this.deliveryTime;
    data['deliveryType'] = this.deliveryType;
    data['mobileNumber'] = this.mobileNumber;
    data['customerName'] = this.customerName;
    data['specialInstructions'] = this.specialInstructions;
    if (this.stats != null) {
      data['stats'] = this.stats!.map((v) => v.toJson()).toList();
    }
    data['lastStatus'] = this.lastStatus;
    data['deliveryCharge'] = this.deliveryCharge;
    data['totalPriceDelivery'] = this.totalPriceDelivery;

    data['estimatedDeliveryTime'] = this.estimatedDeliveryTime;

    return data;
  }
}
class Storeid {
  String? storeName;
  String? id;

  Storeid({this.storeName});

  Storeid.fromJson(Map<String, dynamic> json) {
    storeName = json['storeName'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storeName'] = this.storeName;

    return data;
  }
}
class Products {
  String? id;
  int? status;
  Productid? productid;
  int? quantity;
  String? price;
  var productPrice;

  var totalProductPrice;

  var shopAssistantQuantity;

  Products({this.id, this.productid, this.quantity, this.price});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'] ?? 0;
    productid = json['productid'] != null
        ? new Productid.fromJson(json['productid'])
        : null;

    quantity = json['quantity'];
    price = json['price'];
    productPrice = json['productPrice'];

    totalProductPrice = json['totalProductPrice']?? 0;

    shopAssistantQuantity = json['shopAssistantQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.productid != null) {
      data['productid'] = this.productid!.toJson();
    }
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    return data;
  }
}

class Productid {
  String? id;
  String? productname;
  var uom;
  var quantity;
  String? price;
  String? promoprice;
  Images? image;

  Productid({this.id,this.productname, this.image, this.uom,this.price, this.promoprice,this.quantity});

  Productid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productname = json['productname'];
    price = json['price'];
    promoprice = json['promoprice'];
    uom = json['uom'];
    quantity = json['quantity'];
    image = json['image'] != null ? new Images.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productname'] = this.productname;
    data['price'] = this.price;
    data['promoprice'] = this.promoprice;
    data['quantity'] = this.quantity;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}

class Images {
  String? primary;
  List<String>? secondary;

  Images({this.primary, this.secondary});

  Images.fromJson(Map<String, dynamic> json) {
    primary = json['primary'];
    if (json['secondary'] != null) {
      secondary = [];
      json['secondary'].forEach((v) {
        secondary!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['primary'] = this.primary;
    // if (this.secondary != null) {
    //   data['secondary'] = this.secondary.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Stats {
  String? status;
  String? created;
  String? createdTime;

  Stats({this.status, this.created, this.createdTime});

  Stats.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    created = json['created'];
    createdTime = json['createdTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['created'] = this.created;
    data['createdTime'] = this.createdTime;
    return data;
  }
}

class DeliveryPartnerId {
  String? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;

  DeliveryPartnerId({this.id, this.firstName, this.lastName, this.phoneNumber});

  DeliveryPartnerId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}

class DistanceMatrixType{
  String? text;
  var value;

  DistanceMatrixType({
    this.text,
    this.value
  });

  DistanceMatrixType.fromJson(Map<String, dynamic> body){
    text = body['text'];
    value = body['value'];
  }
}
