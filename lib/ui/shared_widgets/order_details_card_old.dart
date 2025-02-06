// import 'package:flutter/material.dart';
// import 'package:shop_assistant/core/models/order_list_model.dart';
// import 'package:shop_assistant/ui/views/order_details_screen.dart';
//
// // ignore: must_be_immutable
// class OrderDetailsCard extends StatefulWidget {
//   OrderListModel data;
//   String actionButtonText;
//   VoidCallback onTapActionButton;
//   bool fromAssignedOrders;
//   OrderDetailsCard(this.data,{this.actionButtonText,this.onTapActionButton,this.fromAssignedOrders=false});
//   @override
//   _OrderDetailsCardState createState() => _OrderDetailsCardState();
// }
//
// class _OrderDetailsCardState extends State<OrderDetailsCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 15,),
//       child: InkWell(
//         onTap: (){
//           Navigator.of(context).push(MaterialPageRoute(builder:(context)=>OrderDetailsScreen(widget.data.id,startShopping: widget.fromAssignedOrders,)));
//         },
//         child: Card(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//           color: Theme.of(context).primaryColor,
//           elevation: 5,
//           child: Container(
//             margin: EdgeInsets.all(1),
//             padding: EdgeInsets.all(5),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               color: Colors.white,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   // mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Expanded(
//                         flex: 1,
//                         child: Text("Order ID : ${widget.data.orderNumber}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),)
//                     ),
//                     Expanded(
//                         flex: 1,
//                         child: Text('Total Price :₹ ${widget.data.totalPriceDelivery}')
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 5,),
//                 Divider(thickness: 1,),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                         flex: 1,
//                         child: Text('Address:',style: TextStyle(
//                             fontSize: 18
//                         ),)
//                     ),
//                     Expanded(
//                         flex: 3,
//                         child: Text('${widget.data.deliveryAddress}',style: TextStyle(fontSize: 18),)
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 5,),
//                 Divider(thickness: 1,),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                         flex: 1,
//                         child: Text('Quantity:',style: TextStyle(
//                             fontSize: 18
//                         ),)
//                     ),
//                     Expanded(
//                         flex: 3,
//                         child: Text('${widget.data.products.length} items',style: TextStyle(fontSize: 18),)
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 5,),
//                 Divider(thickness: 1,),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                         flex: 1,
//                         child: Text('Time:',style: TextStyle(
//                             fontSize: 18
//                         ),)
//                     ),
//                     Expanded(
//                         flex: 3,
//                         child: Text('${widget.data.deliveryTime}',style: TextStyle(fontSize: 18),)
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 5,),
//                 Divider(thickness: 1,),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Del. Charge:',style: TextStyle(
//                         fontSize: 18
//                     ),),
//                     Expanded(
//                         flex: 3,
//                         child: Text('₹ ${widget.data.deliveryCharge}',style: TextStyle(fontSize: 18),)
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 10,),
//                 Divider(thickness: 1,),
//                 Container(
//                   decoration: BoxDecoration(
//                     // color: Colors.grey,
//                     //borderRadius: BorderRadius.circular(5)
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(child: Row(
//                         children: [
//                           Icon(Icons.check_circle,color: Colors.green,),
//                           Text('Status : ${widget.data.lastStatus}',
//                             style: TextStyle(color: Colors.black54),),
//                         ],
//                       )),
//                       Row(
//                         children: [
//                           InkWell(
//                               onTap: widget.onTapActionButton,
//                               child: Text(widget.actionButtonText,
//                                 style: TextStyle(color: Theme.of(context).primaryColor),
//                               )
//                           ),
//                           Icon(Icons.navigate_next,color: Theme.of(context).primaryColor,)
//                         ],
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
