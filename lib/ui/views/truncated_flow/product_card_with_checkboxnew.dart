import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';

import '../../../core/models/truncated_flow_delivery_model.dart';
import '../../viewmodel/order_details_viewmodel.dart';
import '../../viewmodel/product_picking_viewmodel.dart';
import '../../viewmodel/shopping_screen_viewmodel.dart';
import '../product_picking_screen/product_quantity_dialog.dart';

class ProductCardWithCheckBox extends StatefulWidget{

  final Products? product;
  String? productName;
  String? productImage;
  String? price;
  String? promoPrice;
  String? uom;
  int? quantity;
  int? perQuantity;
  int? shopAssistantQuantity;
  // String? title;
  final Color? cardColor;
  List<bool?>? isSelectedCheckBox;
  bool? isSelected;
  int count;
  var orderId;
  Widget? onCheckBox;
  Widget? checkBoxSelected;
  VoidCallback? onTapEditButton;
  VoidCallback? onTapNotFound;
  VoidCallback? onTapCheckBox;
  ValueChanged<bool?>? onChanged;
  int? index;


  ProductCardWithCheckBox(
      {
        Key? key,
        //this.title,
        this.isSelected = true,
        this.count = 0,
        this.productImage,
        this.productName,
        this.price,
        this.promoPrice,
        this.uom,
        this.quantity,
        this.shopAssistantQuantity,
        this.product,
        this.orderId,
        this.onTapEditButton,
        this.onTapNotFound,
        this.onTapCheckBox,
        this.onCheckBox,
        this.checkBoxSelected,
        this.perQuantity,
        this.onChanged,
        this.index,
        this.isSelectedCheckBox,
        this.cardColor

      }): super(key: key);

  @override
  State<ProductCardWithCheckBox> createState() => _ProductCardWithCheckBox();
}

/*class MyCard extends StatefulWidget {
  final ProductDetailsCardWithCheckBox data;

  const MyCard({required this.data});

  @override
  _MyCardState createState() => _MyCardState();
}*/

class _ProductCardWithCheckBox extends State<ProductCardWithCheckBox> {



  final TextEditingController _countController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _countController.text = widget.count.toString();
  }



  getProductQuantity() {
    // by default the initial status would be 0
    // only after shopping the status would change

    if (widget.product!.status == 0 || widget.product!.status == 2) {
      return widget.product!.quantity;
    }
    return widget.product!.shopAssistantQuantity;
  }

  bool shoppingIsComplete() {
    if (widget.product!.status == 0)
      return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 340,
      height: 95,
      child: Stack(
        children: [
          //Text(widget.title.toString()),

          Card(
            color: widget.cardColor,
            // color: widget.isSelectedCheckBox[widget.index!] == true ? Color(0xFFC5E6C9) : Colors.white,
            child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(

                        key: UniqueKey(),
                        value: widget.isSelectedCheckBox![widget.index!],
                        onChanged: widget.onChanged,
                        activeColor: Color.fromRGBO(106, 169, 42, 1),
                      ),
                      //widget.onCheckBox!,
                      Row(
                          children: [
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
                                              if(widget.shopAssistantQuantity != null )
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
                            SizedBox(width: 5,),

                            Transform.rotate(
                              angle: 3 / 4,
                              child: Text(
                                '+',
                                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  //color: ColorTheme.primaryTextColor.withOpacity(0.3),
                                ),
                              ),
                            ),

                          ]),

                      Container(
                        width: 200,
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          '${this.widget.productName}',
                          style: Theme
                              .of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(
                              fontWeight: FontWeight.w600,fontStyle: FontStyle.normal),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    ],
                  ),
                  /*Container(
                    width: 13,
                  ),*/

                  Builder(
                      builder: (context) {
                        /*if (widget.shopAssistantQuantity == 0)
                          return Text("Item not found",
                            //style: textTheme.subtitle2!.copyWith(color: Colors.red),
                          );*/
                        return Container(
                          //height: 26,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween,
                            children: [
                              this.widget.promoPrice != null
                                  ? Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left:50.0),
                                  child: RichText(
                                    text: TextSpan(

                                      children: [
                                        TextSpan(
                                          text: ' ₹${this.widget
                                              .promoPrice}',
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(
                                            fontWeight: FontWeight
                                                .w700,
                                            fontSize: 14,
                                            // color: ColorTheme.primaryColor,
                                          ),

                                        ),


                                        TextSpan(
                                          text: ' (${this.widget.perQuantity} ${this.widget.uom})',
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .subtitle2
                                              ?.copyWith(
                                            //   color: ColorTheme.primaryTextColor.withOpacity(0.3),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),

                                        TextSpan(
                                          text: '${this.widget.price}',
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .subtitle2
                                              ?.copyWith(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            decoration: TextDecoration
                                                .lineThrough,
                                          ),
                                        ),


                                      ],

                                    ),
                                  ),
                                ),
                              )

                                  : Padding(
                                    padding: const EdgeInsets.only(left:50.0),
                                    child: RichText(
                                text: TextSpan(
                                    text: ' ₹${this.widget.price}',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      //color: ColorTheme.primaryColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' (${this.widget.perQuantity} ${this.widget.uom})',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .subtitle2
                                            ?.copyWith(
                                          //   color: ColorTheme.primaryTextColor.withOpacity(0.3),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                ),
                              ),
                                  ),

                              Row(
                                children: [
                                  Builder(
                                      builder: (context) {
                                        //if(widget.isSelectedCheckBox == true){
                                          if(widget.isSelectedCheckBox![widget.index!] == true || widget.shopAssistantQuantity == null) {
                                          return Stack(
                                            children: [
                                              Builder(
                                                  builder: (context) {
                                                    if (Provider
                                                        .of<
                                                        OrderDetailsViewModel>(
                                                        context, listen: false)
                                                        .orderData
                                                        .lastStatus ==
                                                        'Order-Ready')
                                                      return Container();

                                                    else {

                                                      return GestureDetector(
                                                        onTap: widget
                                                            .onTapEditButton,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(right:14.0),
                                                          child: Text(
                                                            "Change Qty",
                                                            style: Theme
                                                                .of(context)
                                                                .textTheme
                                                                .subtitle2
                                                                ?.copyWith(
                                                              //   color: ColorTheme.primaryTextColor.withOpacity(0.3),
                                                              color: Color.fromRGBO(106, 169, 42, 1),
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                              ),


                                            ],
                                          );
                                        }
                                        return Container();
                                      }
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                  ),


                  SizedBox(
                    height: 20,
                  ),
                  /*Column(
                    children: [


                      Container(

                        width: 130,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green[200],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete_forever),
                              onPressed: _decrementCount,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${widget.count}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text('/',
                                    style: TextStyle(fontSize: 20)),
                                Text(
                                  widget.quantity!.toString(),
                                  style: TextStyle(fontSize: 20),
                                ),

                              ],
                            ),

                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: _incrementCount,
                            ),
                          ],
                        ),
                      ),




                    ],
                  ),*/

                ],

            ),
          ),


        ],

      ),

    );
  }




}
