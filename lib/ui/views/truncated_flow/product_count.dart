import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';

import '../../../core/models/truncated_flow_delivery_model.dart';
import '../../viewmodel/order_details_viewmodel.dart';
import '../../viewmodel/product_picking_viewmodel.dart';
import '../../viewmodel/shopping_screen_viewmodel.dart';
import '../product_picking_screen/product_quantity_dialog.dart';

class ProductDetailsCardWithCheckBox extends StatefulWidget{

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
  bool isSelected;
  int count;
  var orderId;
  Widget? onCheckBox;

  Widget? checkBoxSelected;

  VoidCallback? onTapEditButton;
  VoidCallback? onTapNotFound;
  VoidCallback? onTapCheckBox;




  ProductDetailsCardWithCheckBox(
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
        this.perQuantity

  }): super(key: key);

  @override
  State<ProductDetailsCardWithCheckBox> createState() => _ProductDetailsCardWithCheckBox();
}

/*class MyCard extends StatefulWidget {
  final ProductDetailsCardWithCheckBox data;

  const MyCard({required this.data});

  @override
  _MyCardState createState() => _MyCardState();
}*/

class _ProductDetailsCardWithCheckBox extends State<ProductDetailsCardWithCheckBox> {


  final TextEditingController _countController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _countController.text = widget.count.toString();
    List<bool> isSelected = List<bool>.generate(Provider.of<OrderDetailsViewModel>(
        context, listen: false).orderData.products!.length, (index) => false);

  }


  void _incrementCount() {
    setState(() {
      widget.count++;
    });
  }

  void _decrementCount() {
    setState(() {
      if (widget.count > 0) {
        widget.count--;
      }
    });
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

  void _toggleCheckbox() {
    setState(() {
      widget.isSelected  = !widget.isSelected ;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: 300,
      child: Card(
        child: Stack(
          children: [
            //Text(widget.title.toString()),




            GestureDetector(
              /*onTap: () {
                setState(() {



                  Provider.of<OrderDetailsViewModel>(
                      context, listen: false).isSelected =! Provider.of<OrderDetailsViewModel>(
                      context, listen: false).isSelected;
                //  widget.isSelected = !widget.isSelected;



                });
              },*/

              child: Padding(
                padding: const EdgeInsets.only(top: 55.0),
                child:
                //widget.checkBoxSelected,

                Checkbox(
                  value: Provider.of<OrderDetailsViewModel>(
                      context, listen: false).isSelected,
                  onChanged: (value) {
                    setState(() {
                      Provider.of<OrderDetailsViewModel>(
                          context, listen: false).isSelected = value!;



                    });
                  },
                ),
              ),
            ),

            GestureDetector(
              /*onTap: () {
                setState(() {
                  widget.isSelected = !widget.isSelected;
                });
              },*/
              child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Container(
                  width: 350,
                  height: 250,
                  child: Card(
                    color: Colors.green[100],
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        width: 180,
                        height: 110,
                        padding: EdgeInsets.symmetric(
                            vertical: 14, horizontal: 13),
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
                                        errorWidget: (context, url, err) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        '${this.widget.productName}',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .subtitle1
                                            ?.copyWith(
                                            fontWeight: FontWeight.w600),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 13,
                                ),
                                Builder(
                                    builder: (context) {
                                      if (widget.shopAssistantQuantity == 0)
                                        return Text("Item not found",
                                          //style: textTheme.subtitle2!.copyWith(color: Colors.red),
                                        );
                                      return Container(
                                        //height: 26,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            this.widget.promoPrice != null
                                                ? Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 50.0),
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: '₹${this.widget.price}',
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
                                                        text: ' / ${this.widget.perQuantity} ${this.widget
                                                            .uom}',
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .subtitle2
                                                            ?.copyWith(
                                                          //color: ColorTheme.primaryTextColor.withOpacity(0.3),
                                                          fontWeight: FontWeight
                                                              .w700,
                                                          fontSize: 12,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )

                                                : RichText(
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
                                                    text: ' / ${this.widget.perQuantity} ${this.widget.uom}',
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        ?.copyWith(
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
                                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      //color: ColorTheme.primaryTextColor.withOpacity(0.3),
                                      ),
                                      ),
                                      ),
                                      Container(
                                      width: 2.25,
                                      ),

                                        Container(
                                          width: 2.25,
                                        ),
                                       /* Builder(
                                            builder: (context) {
                                              if(widget.count >=0 &&widget.quantity != widget.count)
                                                return Container();
                                              return Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.green[100],
                                                ),
                                                child: Text(
                                                  '${this.widget.quantity}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      ?.copyWith(fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                            }
                                        ),*/


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







                                     /* Text(
                                      '${this.widget.quantity}',
                                      style: Theme.of(context).textTheme.headline6?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                      ),*/
                                      ])
                                            /*Row(
                                            children: [
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
                                              Container(
                                                width: 2.25,
                                              ),
                                              Text(
                                              '${this.widget.quantity}',
                                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                    ),


                                             */ /* Builder(
                                                  builder: (context) {
                                                    if(widget.shopAssistantQuantity!>=0 && widget.quantity != widget.shopAssistantQuantity)
                                                      return Container();
                                                    return Container(
                                                      padding: EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        //color: ColorTheme.backgroundGreenishWhite,
                                                      ),
                                                      child: Text(
                                                        '${this.widget.quantity}',
                                                        style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    );
                                                  }
                                              ),
                                              Builder(
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
                                                        child:RichText(
                                                          text: TextSpan(
                                                              text: '${this.widget.quantity} ',
                                                              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                                              fontWeight: FontWeight.w700,
                                                                  decoration: TextDecoration.lineThrough
                                                              ),
                                                              //textAlign: TextAlign.center,
                                                              children: [
                                                                TextSpan(
                                                                  text: ' ${this.widget.shopAssistantQuantity} ',
                                                                  style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                                                    fontWeight: FontWeight.w700,
                                                                  ),
                                                                )
                                                              ]
                                                          ),
                                                        ),


                                                       */ /**/ /* Text('${this.widget.quantity}',
                                                            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                                              fontWeight: FontWeight.w700,

                                                            )),*/ /**/ /*

                                                        */ /**/ /*RichText(
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
                                        ),*/ /**/ /*
                                                      );
                                                    }
                                                    return Container();
                                                  }
                                              )*/ /*
                                            ],
                                          ),*/

                                          ],
                                        ),
                                      );
                                    }
                                ),
                                Builder(
                                  builder: (context) {
                                    if(Provider.of<OrderDetailsViewModel>(
                                        context, listen: false).isSelected == true) {
                                      return Row(
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Builder(
                                                builder: (context) {
                                                  if (Provider
                                                      .of<
                                                      OrderDetailsViewModel>(
                                                      context, listen: false)
                                                      .orderData
                                                      .lastStatus ==
                                                      'Order-Ready') {
                                                    return ElevatedButton(

                                                      onPressed: widget
                                                          .onTapNotFound,
                                                      child: Text(
                                                          "Can't Find Item"),
                                                      style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty
                                                            .all<Color>(Colors
                                                            .grey),
                                                      ),
                                                    );
                                                  }
                                                  else {
                                                    return ElevatedButton(
                                                      onPressed: widget.onTapNotFound,
                                                      child: Text(
                                                          "Can't Find Item"),
                                                      style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty
                                                            .all<Color>(Colors
                                                            .green),
                                                      ),
                                                    );
                                                  }
                                                }
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0, left: 20),
                                            child: Builder(
                                                builder: (context) {
                                                  if (Provider
                                                      .of<
                                                      OrderDetailsViewModel>(
                                                      context, listen: false)
                                                      .orderData
                                                      .lastStatus ==
                                                      'Order-Ready')
                                                    return ElevatedButton(

                                                      onPressed: widget
                                                          .onTapEditButton,
                                                      child: Text("Edit"),
                                                      style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty
                                                            .all<Color>(
                                                            Colors.grey),
                                                      ),
                                                    );

                                                  else {
                                                    return ElevatedButton(

                                                      onPressed: widget
                                                          .onTapEditButton,
                                                      child: Text("Edit"),
                                                      style: ButtonStyle(
                                                        backgroundColor: MaterialStateProperty
                                                            .all<Color>(Colors
                                                            .green),
                                                      ),
                                                    );
                                                  }
                                                }
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    else{
                                      return AbsorbPointer(
                                        absorbing: true,
                                        child: Row(
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Builder(
                                                  builder: (context) {
                                                    if (Provider
                                                        .of<
                                                        OrderDetailsViewModel>(
                                                        context, listen: false)
                                                        .orderData
                                                        .lastStatus ==
                                                        'Order-Ready') {

                                                      return ElevatedButton(

                                                        onPressed: widget
                                                            .onTapNotFound,
                                                        child: Text(
                                                            "Can't Finnd Item"),
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty
                                                              .all<Color>(Colors
                                                              .grey),
                                                        ),
                                                      );
                                                    }
                                                    else {
                                                      return widget.onCheckBox!;
                                                      /*return ElevatedButton(

                                                        onPressed: widget
                                                            .onTapNotFound,
                                                        child: Text(
                                                            "Can't Find Item"),
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty
                                                              .all<Color>(Colors
                                                              .green),
                                                        ),
                                                      );*/
                                                    }
                                                  }
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0, left: 20),
                                              child: Builder(
                                                  builder: (context) {
                                                    if (Provider
                                                        .of<
                                                        OrderDetailsViewModel>(
                                                        context, listen: false)
                                                        .orderData
                                                        .lastStatus ==
                                                        'Order-Ready')
                                                      return ElevatedButton(

                                                        onPressed: widget
                                                            .onTapEditButton,
                                                        child: Text("Edit"),
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty
                                                              .all<Color>(
                                                              Colors.grey),
                                                        ),
                                                      );

                                                    else {
                                                      return ElevatedButton(

                                                        onPressed: widget
                                                            .onTapEditButton,
                                                        child: Text("Edit"),
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStateProperty
                                                              .all<Color>(Colors
                                                              .green),
                                                        ),
                                                      );
                                                    }
                                                  }
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
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


                              ]),
                        ),


                        /*Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title'),
                          Text('Subtitle'),
                        ],
                      ),*/
                      ),
                    ),
                  ),
                ),


              ),
            ),

          ],
        ),


      ),

    );
  }




}
