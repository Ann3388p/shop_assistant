import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/order_details_model.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';
import 'package:shop_assistant/ui/shared_widgets/dialog_box_options.dart';
import 'package:shop_assistant/ui/viewmodel/product_picking_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/shopping_screen_viewmodel.dart';
import 'package:shop_assistant/ui/views/product_picking_screen/product_quantity_dialog.dart';

class ProductPickingScreen extends StatefulWidget {
  Products productData;
  ProductPickingScreen(this.productData);
  @override
  _ProductPickingScreenState createState() => _ProductPickingScreenState();
}

class _ProductPickingScreenState extends State<ProductPickingScreen> {
  @override
  void initState() {
    Provider.of<ProductPickingViewModel>(context,listen: false).setProductData(widget.productData);
   print("${widget.productData.productid!.image!.primary} ");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Consumer<ProductPickingViewModel>(
        builder: (context, value, child) {
          return SingleChildScrollView(
            child: Center(
              child: Container(
                width: width*.8,
                child: Column(
                  children: [
                    Container(
                      height :200,
                      //width: 150,
                      child:Hero(
                        tag: '${widget.productData.productid!.image!.primary}',
                        child: CachedNetworkImage(
                           imageUrl:"${widget.productData.productid!.image!.primary}",
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      width: MediaQuery.of(context).size.width*.85,
                      child: Text(
                        '${widget.productData.productid!.productname}',
                        style: TextStyle(
                          color:Colors.black87,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text(
                          'M.R.P :  ',
                          style: TextStyle(
                            //fontWeight: FontWeight,
                            fontSize: 18,
                            color: Colors.black,
                            letterSpacing:.5,
                          ),
                        ),
                        Text(
                          '₹ ${widget.productData.productPrice}',
                          style: TextStyle(
                            //fontWeight: FontWeight,
                              fontSize: 18,
                              color: Colors.black ,
                              // decoration: data.promoprice!=null?
                              // TextDecoration.lineThrough:
                              // TextDecoration.none,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 5,),
                    Align(
                      alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: 'Unit of measure : '),
                              // TextSpan(
                              //   text: 'bold',
                              //   style: TextStyle(fontWeight: FontWeight.bold),
                              // ),
                              TextSpan(text: ' ${widget.productData.productid!.uom}'),
                            ],
                          ),
                        )
                        // Text("${widget.productData.productid!.uom}",
                        // style: TextStyle(
                        //   color: Colors.grey
                        // ),)
                    ),

                    SizedBox(height: 20,),
                    SizedBox(
                      width : double.infinity,
                      child: CommonPrimaryButton(
                        title: 'Found Item',
                        onPressed: (){
                          ProductQuantityDialog(context,widget.productData.quantity);
                        },
                      )
                    ),
                    SizedBox(height: 15,),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                          onPressed: (){
                            DialogBoxOptions(
                              context: context,
                              heading: 'Confirm',
                              message: 'Are you sure the product is not available ?',
                              onPositive: ()=>value.updateProductStatus(
                                  context,
                                  Provider.of<ShoppingScreenViewModel>(context,listen: false).orderDetails!.id,
                                  0)
                            );
                          },
                          child: Text("Can't find an item",style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18
                          ),)
                      ),
                    )
                    // TextField(
                    //   textDirection: TextDirection.rtl,
                    //   decoration: InputDecoration(
                    //     suffixText:"/ 5" ,
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(7),
                    //     )
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        }
      )
    );
  }
}
