import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/order_details_model.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';
import 'package:shop_assistant/ui/views/truncated_flow/product_details_card.dart';
import 'package:shop_assistant/ui/views/truncated_flow/quantity_button.dart';

import '../../viewmodel/order_details_viewmodel.dart';
import 'order_details.dart';

class ProductDialog extends StatefulWidget {

  String? productName;
  String? productImage;
  var price;
  int? quantity;
  int count;

  var orderId;

  ProductDialog({
    Key? key,
  this.productName,
  this.productImage,
  this.price,
  this.quantity,
    this.count = 0,
    this.orderId


}):super(key: key);

  @override
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {

  final _formKey = GlobalKey<FormState>();

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


  /*List<ProductCard> products = [
    ProductCard(image: "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
        name: "Product 1", count: 0),
    *//*ProductCard(image: "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
        name: "Product 2", count: 0),
    ProductCard(image: "https://docs.flutter.dev/assets/images/dash/dash-fainting.gif",
        name: "Product 3", count: 0),*//*
  ];*/

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:15.0),
      child: Dialog(
        child: Container(
          height: 250,
          padding: EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Text("Edit Products"),
              SizedBox(height: 15.0),
              Expanded(

                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.network(widget.productImage.toString(), width: 64.0, height: 64.0),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.productName.toString(), style: Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle1
                                  ?.copyWith(
                                  fontWeight: FontWeight.w600)),


                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Form(
                                    key:_formKey,
                                    child: QuantityButton(
                                        quantity: widget.count.toInt(),
                                        incrementButton: (){
                                      _incrementCount();
                                    },
                                        decrementButton: (){
                                      _decrementCount();
                                    }),
                                  ),
                                  SizedBox(width: 20,),

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
                                        Text(
                                          '${this.widget.quantity}',
                                          style: Theme.of(context).textTheme.headline6?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ])

                                  //Text("Out of ${widget.quantity.toString()}"),

                                ],
                              ),

                              /*Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            count++;
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                      Text(count.toString()),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (count > 0) count--;
                          });
                        },
                        icon: Icon(Icons.remove),
                      ),
                    ],
                  ),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )

                /*ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                  //  List<OrderDetailsModel> businesstypeList = <OrderDetailsModel>[];
                    return products[index];
                  },
                ),*/
              ),

              SizedBox(height: 22.0),
              CommonPrimaryButton(
                onPressed: ()
                {

                  if(_formKey.currentState!.validate()) {

                    print(widget.count);
                    // print("Shop qnty in model ${.products!.map((e) {
                    //   e.shopAssistantQuantity;
                    //   e.productPrice;
                    // })}");

                   // Provider.of<OrderDetailsViewModel>(context,listen: false).calculateProductPrice(widget.count,widget.price);
                   //Provider.of<OrderDetailsViewModel>(context,listen: false).calculateBillAmount(widget.price.toString(),widget.count,);
                    Provider.of<OrderDetailsViewModel>(context,listen: false).calculateBillAmount();
                    //Navigator.pop(context, result);
                    Navigator.of(context).pop(widget.count);
                  }
                },
                title: "Confirm",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
class ProductCard extends StatefulWidget {
  final String image;
  final String name;
  final int count;

  const ProductCard({Key? key, required this.image, required this.name, required this.count}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int count = 0;

  @override
  void initState() {
    count = widget.count;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.network(widget.image, width: 64.0, height: 64.0),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 8.0),
                  QuantityButton(quantity: 2, incrementButton: (){}, decrementButton: (){})
                  */
/*Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            count++;
                          });
                        },
                        icon: Icon(Icons.add),
                      ),
                      Text(count.toString()),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (count > 0) count--;
                          });
                        },
                        icon: Icon(Icons.remove),
                      ),
                    ],
                  ),*//*

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/



