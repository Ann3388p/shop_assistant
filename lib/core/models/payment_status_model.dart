class PaymentStatusModel {
  int? paymentStatus;

  PaymentStatusModel({this.paymentStatus});

  PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    paymentStatus = json['paymentStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentStatus'] = this.paymentStatus;
    return data;
  }
}