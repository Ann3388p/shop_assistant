import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsGetDirectionButton extends StatelessWidget {
  final  lat;
  final  lng;
  final String status;
  const OrderDetailsGetDirectionButton({required this.status, this.lat, this.lng,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Status ==> $status");
    print("lat ==> $lat, lng ==>$lng");
    if(status == "Order-Ready" && lat != null && lng != null)
      return TextButton.icon(
        onPressed: () async {
          final Uri uri= Uri.parse('google.navigation:q=$lat,$lng');
          await launchUrl(uri);
        },
        icon: Icon(Icons.directions),
        label: Text("Directions"),);
    return TextButton.icon(
      onPressed: null,
      icon: Icon(Icons.directions),
      label: Text("Directions"),);
  }
}
