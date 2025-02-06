import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop_assistant/core/models/order_details_model.dart';

class OrderDetailsProductItem extends StatefulWidget {
  final Products product;
  const  OrderDetailsProductItem(this.product,{Key? key}) : super(key: key);

  @override
  _OrderDetailsProductItemState createState() => _OrderDetailsProductItemState();
}

class _OrderDetailsProductItemState extends State<OrderDetailsProductItem> {
  final _SECTIONPADDING = EdgeInsets.symmetric(horizontal: 15);

  getProductQuantity(){

    // by default the initial status would be 0
    // only after shopping the status would change

    if (widget.product.status == 0 || widget.product.status == 2) {
      return widget.product.quantity;
    }
    return widget.product.shopAssistantQuantity;
  }

  bool shoppingIsComplete(){
    if (widget.product.status == 0)
      return false;
    return true;
    }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: _SECTIONPADDING,
        child: Row(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: CachedNetworkImage(
                  imageUrl:"${widget.product.productid!.image!.primary}",
                  //'${product.productid.images}',
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  height: 75,
                  width: 75,
                  fit: BoxFit.cover,)),
            SizedBox(width: 30,),
            Expanded(
              child: Container(
                height: 85,
                // color: Colors.orange,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${widget.product.productid!.productname}",
                        //"${product.productid.productname} ",
                        overflow:TextOverflow.ellipsis,maxLines:2,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 16)),
                    Text(
                        "₹ ${widget.product.productPrice}",
                        //" ₹ ${product.price}",
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 16)),
                    // SizedBox(height: 8),
                    Builder(
                      builder: (context) {
                        print("shop ass quantity is ${widget.product.shopAssistantQuantity}");
                        print("product status is ${widget.product.status}");
                        if(shoppingIsComplete()){
                         return Row(
                            children: [
                              Text(" Qty: ",
                                  style: TextStyle(color: Colors.black54,)
                              ),
                              Text("${widget.product.quantity}",
                                  style: TextStyle(color: Colors.black54,
                                      decoration:widget.product.shopAssistantQuantity!>=0 && widget.product.quantity!=widget.product.shopAssistantQuantity?TextDecoration.lineThrough:TextDecoration.none)
                              ),
                              Builder(
                                  builder: (context) {
                                    if(widget.product.shopAssistantQuantity!>=0 && widget.product.quantity != widget.product.shopAssistantQuantity){
                                      return Text(" ${widget.product.shopAssistantQuantity}",
                                        style: TextStyle(color: Colors.red,
                                        ),
                                      );
                                    }
                                    return Container();
                                  }
                              )
                            ],
                          );
                        }
                        return Text(
                            //"Qty : ${getProductQuantity()}",
                             " Qty: "+"${widget.product.quantity}",
                            style: TextStyle(color: Colors.black54));
                      }
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

