

class TruncatedFlowShopAssistantModel {
  String? id;
  int? orderNumber;
  List<Products>? products;
  String? deliveryAddress;
  String? deliveryDate;
  var totalPrice;
  int? totalPriceDelivery;
  String? lastStatus;
  int? deliveryCharge;


  TruncatedFlowShopAssistantModel(
      {this.id,
        this.orderNumber,
        this.products,
        this.deliveryAddress,
        this.deliveryDate,
        this.totalPrice,
        this.totalPriceDelivery,
        this.lastStatus,
        this.deliveryCharge
      });

  TruncatedFlowShopAssistantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['orderNumber'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    deliveryAddress = json['deliveryAddress'];
    deliveryDate = json['deliveryDate'];
    totalPrice = json['totalPrice'];
    totalPriceDelivery = json['totalPriceDelivery'];
    lastStatus = json['lastStatus'];
    deliveryCharge = json['deliveryCharge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['deliveryAddress'] = this.deliveryAddress;
    data['deliveryDate'] = this.deliveryDate;
    data['totalPrice'] = this.totalPrice;
    data['totalPriceDelivery'] = this.totalPriceDelivery;
    data['lastStatus'] = this.lastStatus;
    data['deliveryCharge'] = this.deliveryCharge;
    return data;
  }
}

class Products {
  String? id;
  Productid? productid;

  Products({this.id, this.productid});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productid = json['productid'] != null
        ? new Productid.fromJson(json['productid'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.productid != null) {
      data['productid'] = this.productid!.toJson();
    }
    return data;
  }
}

class Productid {
  String? id;
  String? price;
  var promoprice;
  String? productname;
  Image? image;



  Productid({this.id, this.price, this.promoprice, this.productname});

  Productid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    promoprice = json['promoprice'];
    productname = json['productname'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['promoprice'] = this.promoprice;
    data['productname'] = this.productname;
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
