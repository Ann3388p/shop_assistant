class UserTruncatedModel{
  bool? shopAsstTruncatedFlow;
  UserTruncatedModel({this.shopAsstTruncatedFlow});

  UserTruncatedModel.fromJson(Map<String, dynamic> json) {
    shopAsstTruncatedFlow= json["shopAsstTruncatedFlow"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopAsstTruncatedFlow'] = this.shopAsstTruncatedFlow;
    return data;
  }
}