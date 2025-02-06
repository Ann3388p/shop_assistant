import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/order_billing_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/shopping_screen_viewmodel.dart';

class BillUpload extends StatefulWidget {
  @override
  _BillUploadState createState() => _BillUploadState();
}

class _BillUploadState extends State<BillUpload> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Consumer<OrderBillingViewModel>(
        builder: (context,value, child) {
          return WillPopScope(
            onWillPop: ()async{
              value.previousStep();
              return Future.value(false);
            },
            child: Center(
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Bill Upload",style: TextStyle(fontSize: 24),),
                      SizedBox(height: 10,),
                      Container(
                          height: height*.5,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)
                          ),
                          child: Builder(
                            builder: (BuildContext context) {
                              if(value.imageFile != null){
                                return Image.file(value.imageFile);
                              }
                              return Center(child: Text("No image selected"));
                            },)
                      ),
                      SizedBox(height: 10,),
                      value.showButtons(
                          context: context,
                          orderID: Provider.of<ShoppingScreenViewModel>(context,listen: false).orderDetails!.id,
                          userID: Provider.of<UserDataViewModel>(context,listen: false).userID)
                    ],
                  ),
                  Positioned(
                    right: 0,
                      top: 20,
                      child: ClipOval(
                        child: GestureDetector(
                          onTap: ()=>Provider.of<OrderBillingViewModel>(context,listen: false).removeBillImage(context),
                          child: Container(
                             padding: EdgeInsets.all(10),
                              color: Colors.blue,
                              child: Icon(Icons.close,color: Colors.white,)
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
          );
        }
    );
    // floatingActionButton: FloatingActionButton(
    //   onPressed: ()async{
    //     try {
    //       PickedFile file = await _picker.getImage(
    //           source: ImageSource.camera);
    //       setState(() {
    //         _imageFile = File(file.path);
    //       });
    //       print(file.path);
    //     }catch(err){
    //       print(err.toString());
    //     }
    //   },
    //   child: Icon(Icons.camera_alt,color: Colors.white,),
    // ),

  }
}
