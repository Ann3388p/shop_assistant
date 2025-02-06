import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop_assistant/core/models/order_details_model.dart';
import 'package:shop_assistant/ui/views/product_picking_screen/product_picking_screen.dart';

class ProductBlock extends StatelessWidget {
  final _SECTIONPADDING = EdgeInsets.symmetric(horizontal: 15);
  Products productData;
  ProductBlock(this.productData);
  getQuantity(){
    if(productData.shopAssistantQuantity!=null){
      return productData.shopAssistantQuantity;
    }
    return productData.quantity;
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ProductPickingScreen(productData)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Card(
          //color: Theme.of(context).primaryColor,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.5,vertical: 1.5),
              //color: Colors.blue,
              padding: _SECTIONPADDING,
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Hero(
                        tag:'${productData.productid!.image!.primary}',
                        child: CachedNetworkImage(
                          imageUrl: '${productData.productid!.image!.primary}',
                          errorWidget: (context, url, error) => Icon(Icons.error),
                          //'${product.productid.images}',
                          height: 75,
                          width: 75,
                          fit: BoxFit.cover,),
                      )),
                  SizedBox(width: 30,),
                  Expanded(
                    child: Container(
                      height: 75,
                      // color: Colors.orange,
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${productData.productid!.productname}",
                              //"${product.productid.productname} ",
                              overflow:TextOverflow.ellipsis,maxLines:2,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 16)),
                          Text(
                              "₹ ${productData.productPrice}",
                              //" ₹ ${product.price}",
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 16)),
                          // SizedBox(height: 8),
                          Builder(
                            builder: (context) {
                              if(getQuantity() == 0){
                                return Text("Item not found",style: TextStyle(color: Colors.red));
                              }
                              return Text(
                                  "Qty : ${getQuantity()}",
                                  // " Qty: "+"${product.quantity}",
                                  style: TextStyle(color: Colors.black54));
                            }
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
