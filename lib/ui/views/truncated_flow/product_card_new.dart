import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';

import '../../../core/models/truncated_flow_delivery_model.dart';
import '../../viewmodel/order_details_viewmodel.dart';
import '../../viewmodel/product_picking_viewmodel.dart';
import '../../viewmodel/shopping_screen_viewmodel.dart';
import '../product_picking_screen/product_quantity_dialog.dart';

class ProductDetailsCardWithCheckBoxNew extends StatefulWidget{

  final Products? product;
  String? productName;
  String? price;

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




  ProductDetailsCardWithCheckBoxNew(
      {
        Key? key,
        //this.title,
        this.isSelected = true,
        this.count = 0,
        this.productName,
        this.price,

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

      }): super(key: key);

  @override
  State<ProductDetailsCardWithCheckBoxNew> createState() => _ProductDetailsCardWithCheckBoxNew();
}



class _ProductDetailsCardWithCheckBoxNew extends State<ProductDetailsCardWithCheckBoxNew> {


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
    return Stack(
      children: [
        //Text(widget.title.toString()),

        /*GestureDetector(
          child: Checkbox(
            value: Provider.of<OrderDetailsViewModel>(
                context, listen: false).isSelected,
            onChanged: (value) {
              setState(() {
                Provider.of<OrderDetailsViewModel>(
                    context, listen: false).isSelected = value!;

              });
            },
          ),
        ),*/

        Container(
          // width: 390,
          // height: 100,
          child: Row(
            children: [

              Container(
                width: 340,
                height: 90,
                child: Card(

                  color: Provider.of<OrderDetailsViewModel>(
                      context, listen: false).isSelected == true ? Colors.green[100] : Colors.white,
                  child: Row(
                    children: [

                      Checkbox(
                        value: Provider.of<OrderDetailsViewModel>(
                            context, listen: false).isSelected,
                        onChanged: (value) {

                           // widget.onTapNotFound;

                          setState(() {
                          //  widget.onTapNotFound;
                            Provider.of<OrderDetailsViewModel>(
                                context, listen: false).isSelected = value!;


                          });
                        },
                        activeColor: Colors.green,
                      ),

                      Container(
                       // width: 206,
                       // height: 180,
                        padding: EdgeInsets.symmetric(
                            vertical: 14, horizontal: 13),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        /*  boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 20, // soften the shadow
                              spreadRadius: -15,
                              offset: Offset(1, 1),
                            )
                          ],*/
                        ),
                        child: Column(
                            children: [


                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
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

                                        SizedBox(
                                          width: 5,
                                        ),

                                        Transform.rotate(
                                          angle: 3 / 4,
                                          child: Text(
                                            '+',
                                            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                              fontSize: 30,
                                              fontWeight: FontWeight.w200,
                                              //color: ColorTheme.primaryTextColor.withOpacity(0.3),
                                            ),
                                          ),
                                        ),

                                      ]),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 100,
                                    margin: EdgeInsets.only(right: 100),
                                    child: Text(
                                      '${this.widget.productName}',
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.copyWith(
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                             /* Container(
                                height: 5,
                              ),*/
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
                                         RichText(
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



                                          Padding(
                                            padding: const EdgeInsets.only(left:90.0),
                                            child: Builder(
                                                builder: (context) {
                                                  if(Provider.of<OrderDetailsViewModel>(
                                                      context, listen: false).isSelected == true) {
                                                    return Column(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: widget
                                                          .onTapEditButton,


                                                          child: Text("Change Qty",
                                                            style: Theme
                                                                .of(context)
                                                                .textTheme
                                                                .subtitle2
                                                                ?.copyWith(
                                                              //   color: ColorTheme.primaryTextColor.withOpacity(0.3),
                                                              color: Colors.green,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 14,
                                                            ),),
                                                        )
                                                      ],
                                                    );

                                                  }
                                                  else{
                                                    return Container();
                                                  }
                                                }
                                            ),
                                          ),

                                        ],
                                      ),
                                    );
                                  }
                              ),
                            /*  Builder(
                                  builder: (context) {
                                    if(Provider.of<OrderDetailsViewModel>(
                                        context, listen: false).isSelected == true) {
                                      return Column(
                                        children: [
                                          Text("Change Q")
                                        ],
                                      );

                                    }
                                    else{
                                      return AbsorbPointer(
                                        absorbing: true,
                                        child: Column(
                                          children: [
                                            Text("Change Qty")
                                          ],
                                        )

                                      );
                                    }
                                  }
                              ),*/

                              // SizedBox(
                              //   height: 20,
                              // ),


                            ]),

                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }




}
