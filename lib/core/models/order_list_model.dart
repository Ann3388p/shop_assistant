class OrderListModel {
  String? id;
  int? orderNumber;
  String? storeid;
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
  var discountPrice;

  OrderListModel(
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
        this.discountPrice,
        this.finalBillAmount,
        this.totalPriceDelivery});

  OrderListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['orderNumber'];
   // storeid = json['storeid'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    totalPrice = json['totalPrice'];
    deliveryAddress = json['deliveryAddress'];
    deliveryDate = json['deliveryDate'];
    deliveryTime = json['deliveryTime'];
    deliveryType = json['deliveryType'];
    mobileNumber = json['mobileNumber'];
    customerName = json['customerName'];
    specialInstructions = json['specialInstructions'];
    if (json['stats'] != null) {
      stats = <Stats>[];
      json['stats'].forEach((v) {
        stats!.add(new Stats.fromJson(v));
      });
    }
    lastStatus = json['lastStatus'];
    deliveryCharge = json['deliveryCharge']??0.0;
    totalPriceDelivery = json['totalPriceDelivery'];
    discountPrice = json['discountPrice']??0.0;
    finalBillAmount = json['finalBillAmount']??0.0;
    if(finalBillAmount > 0){
      totalPriceDelivery = finalBillAmount - discountPrice + deliveryCharge;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    data['storeid'] = this.storeid;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
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
    return data;
  }
}

class Products {
  String? id;
  Productid? productid;
  int? quantity;
  String? price;

  Products({this.id, this.productid, this.quantity, this.price});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productid = json['productid'] != null
        ? new Productid.fromJson(json['productid'])
        : null;
    quantity = json['quantity'];
    price = json['price'];
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
  String? productname;
  String? price;

  Productid({this.productname, this.price});

  Productid.fromJson(Map<String, dynamic> json) {
    productname = json['productname'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productname'] = this.productname;
    data['price'] = this.price;
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


