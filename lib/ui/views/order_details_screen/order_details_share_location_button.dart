import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shop_assistant/core/models/order_details_model.dart';

class OrderDetailsShareLocationButton extends StatelessWidget {
  final OrderDetailsModel orderData;
  const OrderDetailsShareLocationButton({required this.orderData,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print("lat ==> $lat, lng ==>$lng");
    if(orderData.deliveryPartnerId != null && orderData.deliveryLat != null && orderData.deliveryLng != null)
      return TextButton.icon(
        onPressed: () async {
          //final Uri uri= Uri.parse('google.navigation:q=$lat,$lng');
          //await launchUrl(uri);
          //print(uri.toString());
          Share.share('''
           Order Number : ${orderData.orderNumber},\n
           Customer Name : ${orderData.customerName},\n
           Delivery Address : ${orderData.deliveryAddress},\n
           Delivery Location link : https://www.google.com/maps/search/?api=1&query=${orderData.deliveryLat},${orderData.deliveryLng}''');
        },
        icon: Icon(Icons.share),
        label: Text("Share Delivery Details"),);
    return TextButton.icon(
      onPressed: null,
      icon: Icon(Icons.share),
      label: Text("Share Delivery Details"),);
  }
}