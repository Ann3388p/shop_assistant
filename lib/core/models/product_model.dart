// class ProductModel{
//   String id;
//   Productid productid;
//   int quantity;
//   String price;
//
//   ProductModel({this.id, this.productid, this.quantity, this.price});
//
//   ProductModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productid = json['productid'] != null
//         ? new Productid.fromJson(json['productid'])
//         : null;
//     quantity = json['quantity'];
//     price = json['price'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     if (this.productid != null) {
//       data['productid'] = this.productid.toJson();
//     }
//     data['quantity'] = this.quantity;
//     data['price'] = this.price;
//     return data;
//   }
// }
//
// class Productid {
//   String productname;
//   String price;
//   Images image;
//
//   Productid({this.productname, this.price, this.image});
//
//   Productid.fromJson(Map<String, dynamic> json) {
//     productname = json['productname'];
//     price = json['price'];
//     image = json['image'] != null ? new Images.fromJson(json['image']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['productname'] = this.productname;
//     data['price'] = this.price;
//     if (this.image != null) {
//       data['image'] = this.image.toJson();
//     }
//     return data;
//   }
// }
//
// class Images {
//   String primary;
//   List<String> secondary;
//
//   Images({this.primary, this.secondary});
//
//   Images.fromJson(Map<String, dynamic> json) {
//     primary = json['primary'];
//     if (json['secondary'] != null) {
//       secondary = [];
//       json['secondary'].forEach((v) {
//         secondary.add(v);
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['primary'] = this.primary;
//     // if (this.secondary != null) {
//     //   data['secondary'] = this.secondary.map((v) => v.toJson()).toList();
//     // }
//     return data;
//   }
// }
