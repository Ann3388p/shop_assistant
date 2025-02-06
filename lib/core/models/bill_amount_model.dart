class BillAmountModel{
  var billAmount;
  var paymentStatus;
  var finalBillAmount;
  BillAmountModel({
    this.billAmount,
    this.paymentStatus,
    this.finalBillAmount
  });
  BillAmountModel.fromJson(Map<String,dynamic> json){
    this.billAmount = json["viewOrder"]["totalPrice"];
    this.paymentStatus = json['viewOrder']['paymentStatus']??0;
    this.finalBillAmount = json['viewOrder']['finalBillAmount']??0.0;
  }
  @override
  String toString(){
    return 'BillAmountModel( billAmount : $billAmount, paymentStatus : $paymentStatus, finalBillAmount : $finalBillAmount)';
  }
}