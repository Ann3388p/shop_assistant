import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';



class ProductDetailsCard extends StatefulWidget {

  String? productName;
  String? productImage;
  String? price;
  String? promoPrice;
  String? uom;
  int? quantity;
  int? shopAssistantQuantity;
  int count;
  int? perQuantity;

  ProductDetailsCard({
    Key? key,
    this.productImage,
    this.productName,
    this.price,
    this.promoPrice,
    this.uom,
    this.quantity,
    this.shopAssistantQuantity,
    this.count = 0,
    this.perQuantity,
  }): super(key: key);

  @override
  State<ProductDetailsCard> createState() => _ProductDetailsCardState();
}

class _ProductDetailsCardState extends State<ProductDetailsCard> {



  @override
  Widget build(BuildContext context) {
    bool quantityHasChanged(){
      return widget.shopAssistantQuantity!>=0 && widget.quantity != widget.shopAssistantQuantity;
    }
    var textTheme = Theme.of(context).textTheme;
    return Container(
      width: 206,
      height: 114,
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 20, // soften the shadow
            spreadRadius: -15,
            offset: Offset(1, 1),
          )
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  //constraints: BoxConstraints(maxHeight: 88, maxWidth: 40),
                  height: 40,
                  child: CachedNetworkImage(
                    imageUrl: '${this.widget.productImage}',
                    errorWidget: (context, url, err) => Icon(Icons.error),
                  ),
                ),
                Container(
                  width: 88,
                  margin: EdgeInsets.only(left: 17),
                  child: Text(
                    '${this.widget.productName}',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),

           /* Container(

              // width: 120,
              // height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: _decrementCount,
                  ),
                  Text(
                    '${widget.count}',
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _incrementCount,
                  ),
                ],
              ),
            ),*/


            Container(
              height: 13,
            ),
            Builder(
                builder: (context) {
                  if(widget.shopAssistantQuantity == 0)
                    return Text("Item not found",style: textTheme.subtitle2!.copyWith(color: Colors.red),);
                  return Container(
                    //height: 26,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        this.widget.promoPrice != null
                            ?
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: '₹${this.widget.price}',
                              style: textTheme.subtitle2?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                              children: [
                                TextSpan(
                                  text: ' ₹${this.widget.promoPrice}',
                                  style: textTheme.headline6?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                   // color: ColorTheme.primaryColor,
                                  ),
                                ),


                                TextSpan(
                                  text: ' / ${this.widget.perQuantity} ${this.widget.uom}',
                                  style: textTheme.subtitle2?.copyWith(
                                    //color: ColorTheme.primaryTextColor.withOpacity(0.3),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )

                            : RichText(
                          text: TextSpan(
                            text: ' ₹${this.widget.price}',
                            style: textTheme.headline6?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              //color: ColorTheme.primaryColor,
                            ),

                            children: [



                              TextSpan(
                                text: '/ ${this.widget.perQuantity} ${this.widget.uom}',
                                style: textTheme.subtitle2?.copyWith(
                               //   color: ColorTheme.primaryTextColor.withOpacity(0.3),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Transform.rotate(
                              angle: 3 / 4,
                              child: Text(
                                '+',
                                style: textTheme.subtitle2?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  //color: ColorTheme.primaryTextColor.withOpacity(0.3),
                                ),
                              ),
                            ),
                            Container(
                              width: 2.25,
                            ),


                            Builder(
                                builder: (context) {
                                  if(widget.quantity != null && widget.shopAssistantQuantity == null){
                                    return Text(
                                      '${this.widget.quantity}',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                        fontWeight: FontWeight
                                            .w600,
                                      ),
                                      textAlign: TextAlign
                                          .center,
                                    );
                                  }
                                  else {
                                    return Row(
                                      children: [
                                        Builder(
                                            builder: (context) {
                                              if(widget.shopAssistantQuantity != null)
                                                return Text(
                                                  '${this.widget.quantity}',
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .headline6
                                                      ?.copyWith(
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      decoration: TextDecoration.lineThrough
                                                  ),
                                                  textAlign: TextAlign
                                                      .center,

                                                );
                                              else{
                                                return Text(
                                                  '${this.widget.quantity}',
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .headline6
                                                      ?.copyWith(
                                                    fontWeight: FontWeight
                                                        .w600,

                                                  ),
                                                  textAlign: TextAlign
                                                      .center,

                                                );
                                              }
                                            }
                                        ),
                                        SizedBox(width: 5,),

                                        Builder(
                                            builder: (context) {
                                              //  print("INSIDE PRODUCT COUNT SHOP ${widget.shopAssistantQuantity}");
                                              if (widget.shopAssistantQuantity == null) {
                                                print("SHOP ASS.QTY IS EMPTY");
                                                return Container();
                                              }
                                              else {
                                                print("SHOP ASS.QTY IS NOT EMPTY");
                                                return Text(
                                                  '${this.widget
                                                      .shopAssistantQuantity}',
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .headline6
                                                      ?.copyWith(
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      color: Colors.red
                                                  ),

                                                  textAlign: TextAlign
                                                      .center,

                                                );
                                              }
                                            }
                                        ),
                                      ],
                                    );
                                  }
                                }
                            ),
                            /*Builder(
                                builder: (context) {
                                  *//*if(widget.shopAssistantQuantity!>=0 && widget.quantity != widget.shopAssistantQuantity)
                                    return Container();*//*
                                  return Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      //color: ColorTheme.backgroundGreenishWhite,
                                    ),
                                    child: Text(
                                      '${this.widget.quantity}',
                                      style: textTheme.subtitle2?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }
                            ),*/
                            /*Builder(
                                builder: (context) {
                                  if(widget.shopAssistantQuantity!>=0 && widget.quantity != widget.shopAssistantQuantity) {
                                    return Container(
                                      // width: 26,
                                      // height: 26,
                                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        gradient:  LinearGradient(colors: [Color(0xFFFFDB51), Color(0xFFFFC800)]),
                                      ),
                                      child: Text('${this.widget.quantity}',
                                        style: textTheme.subtitle2?.copyWith(
                                          fontWeight: FontWeight.w700,

                                      )),

                                      *//*RichText(
                                        text: TextSpan(
                                            text: '${this.widget.quantity} ',
                                            style: textTheme.subtitle2?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                decoration: TextDecoration.lineThrough
                                            ),
                                            //textAlign: TextAlign.center,
                                            children: [
                                              TextSpan(
                                                text: ' ${this.widget.shopAssistantQuantity} ',
                                                style: textTheme.subtitle2?.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                   // color: ColorTheme.errorRed
                                                ),
                                              )
                                            ]
                                        ),
                                      ),*//*
                                    );
                                  }
                                  return Container();
                                }
                            )*/
                          ],
                        ),
                      ],
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
