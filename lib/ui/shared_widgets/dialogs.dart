import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_assistant/core/services/navigation_service.dart';
import 'package:shop_assistant/ui/shared_widgets/textfield_with_label.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/models/critical_order.dart';
import '../../core/models/user_data_viewmodel.dart';
import '../../core/utils/validations.dart';
import '../home_screen.dart';
import 'common_primary_button.dart';

class Dialogs{

  static showForceUpdateDialog(Map data){
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 100),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
            builder: (context,setState) {
              return Container(
                //height: height,
                width: width,
                //color: Colors.red,
                child: Material(
                  child: Column(
                    //mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(
                      //     width: 100,
                      //     child: logo
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: Text("NearShopz need an update",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline2,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                        child: Text("To use this app download the latest version "),
                      ),
                      CommonPrimaryButton(onPressed: () async {
                        if(Platform.isIOS){
                          Navigator.pop(context);
                          await launch(data['appStoreLink']);
                        }else{
                          Navigator.pop(context);
                          await launch(data['playStoreLink']);
                        }
                      }, title:"Update")
                    ],
                  ),
                ),
                //  margin: EdgeInsets.only( left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft:Radius.circular(20),
                      topRight: Radius.circular(20)
                  ),
                ),
              );
            }
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
  static showUpdateDialog(Map data){
    print('show update dialog invoked ================');
    _discardUpdate(String version) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("rejectedVersion",version);
    }
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    CupertinoAlertDialog iOSalert = CupertinoAlertDialog(
      // shape: const RoundedRectangleBorder(
      //     borderRadius:
      //     BorderRadius.all(Radius.circular(10))),
      // contentPadding:
      // const EdgeInsets.only(top: 50.0, bottom: 50.0, left: 20, right: 20),
      //backgroundColor: Color(backgroundGrey),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text("Update Now",style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 20),
            Text("A new version of Nearshopz is available",textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1),
            SizedBox(height: 20)
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: ()async{
          await launch(data['appStoreLink']);
        }, child: Text("Update Now")),
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Later")),
        TextButton(onPressed: (){
          _discardUpdate(data['latestVersionIOS']);
        }, child: Text("Ignore")),
      ],
    );
    AlertDialog androidAlert = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(10))),
      contentPadding:
      const EdgeInsets.only(top: 50.0, bottom: 50.0, left: 20, right: 20),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text("Update Now",style: Theme.of(context).textTheme.headline5),
            SizedBox(height: 20),
            Text("A new version of Nearshopz is available",textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1),
            SizedBox(height: 20)
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          _discardUpdate(data['latestVersionAndroid']);
          Navigator.pop(context);
        }, child: Text("Later")),
        TextButton(onPressed: ()async{
          await launch(data['playStoreLink']);
        }, child: Text("Update Now")),
      ],
    );
    showDialog(
      context: context,
      // barrierColor: CustomTheme.backgroundBlack.withOpacity(0.9),
      builder: (BuildContext context) {
        if(Platform.isIOS)
          return iOSalert;
        return androidAlert;
      },
    );
  }

  static void showRejectionReasonDialog(
      BuildContext context,
      {
        String? heading,
        required Function(String) onConfirm
      }
      ) {
    TextEditingController _reasonController = TextEditingController();
    //_reasonController.text = amount.toString();
    final _formKey =  GlobalKey<FormState>();
    AlertDialog alert = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(10))),
        contentPadding:
        const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20, right: 20),
        //backgroundColor: Color(backgroundGrey),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Builder(
                    builder: (context) {
                      if(heading!=null)
                        return Text("$heading",style: Theme.of(context).textTheme.headline5);
                      return Container();
                    }
                ),
                SizedBox(height: 20),
                TextFieldWithLabel(label: "Please add reason for rejection",
                  controller: _reasonController,
                  validator:(val)=>Validations.validateRequired(val!, "Reason"),
                  isVisibleMandatory: false,
                  //prefixIcon: Text("₹ "),
                  //keyboardType: TextInputType.number,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
                  // ],
                ),
                //Text(alertMessage,textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CommonPrimaryButton(
                      title: "Cancel",
                      expandButton: false,
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      buttonColor: Colors.grey,
                    ),
                    CommonPrimaryButton(title: "Confirm",
                        expandButton: false,
                        onPressed: (){
                      if(_formKey.currentState!.validate()){
                        onConfirm(_reasonController.text);
                      }
                    }),
                  ],
                )
              ],
            ),
          ),
        )
    );
    // show the dialog
    showDialog(
      context: context,
      // barrierColor: CustomTheme.backgroundBlack.withOpacity(0.9),
      builder: (BuildContext context) {
        return alert;
      },
    );

  }
  static void showErrorDialog(BuildContext context,String alertMessage,String? heading) {
    AlertDialog alert = AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(10))),
        contentPadding:
        const EdgeInsets.only(top: 50.0, bottom: 20.0, left: 20, right: 20),
        //backgroundColor: Color(backgroundGrey),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Builder(
                  builder: (context) {
                    if(heading!=null) {
                      return Padding(
                        padding: const EdgeInsets.only(right:140.0),
                        child: Text("$alertMessage",
                          textAlign: TextAlign.left,
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline4
                              ?.copyWith(fontWeight: FontWeight.w600),),
                      );
                    }
                    return Container();
                  }
              ),
              SizedBox(height: 20),
              Text(heading!,textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 180.0),
                child: TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        )
    );
    // show the dialog
    showDialog(
      context: context,
      // barrierColor: CustomTheme.backgroundBlack.withOpacity(0.9),
      builder: (BuildContext context) {
        return alert;
      },
    );

  }
                          static HomeScreen showCriticalOrderDialog({
                            required BuildContext context,
                          List<CriticalOrder>  ? criticalOrder,
                          Function(CriticalOrder) ? onSelected,
                            double ? currentPage,
                            LiveCriticalOrder ? liveOrder,
                            bool ? isDialogOpen,
                            // BuildContext? dialogContext,

                          })


                          {

                                      // final _formKey = GlobalKey<FormState>();
                                      // TextEditingController nameController = TextEditingController();


                                      Dialog criticalDialog = Dialog(
                                       // backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0)), //this right here
                                      child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 0.5),
                                      height: MediaQuery.of(context).size.height*0.65,
                                      decoration: const BoxDecoration(
                                      // color: ColorTheme.lightBackground,
                                      ),
                                      child: StatefulBuilder(
                                          builder: (context, setState) {
                                            final PageController _pageController = PageController();

                                            _pageController.addListener(() {
                                              setState(() {
                                                currentPage = _pageController.page!;
                                                print(currentPage);

                                              });
                                            });

                                            //////////////////////////////////////////////////////
                                            return SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  SizedBox(height: 15,),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 58.0),
                                                    child: Row(
                                                      children: [
                                                        Image.asset( 'assets/dashboard/warning.png'),

                                                        Text(
                                                          'Critical Orders',
                                                          textAlign: TextAlign.left,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .subtitle2
                                                              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  RichText(
                                                    text: TextSpan(
                                                      style: TextStyle(color: Colors.black54, fontSize: 14),
                                                      children: <InlineSpan>[
                                                        TextSpan(text: 'You have', style: TextStyle()),
                                                        WidgetSpan(child: SizedBox(width: 5)),
                                                        TextSpan(text: criticalOrder!.map((e) => e.orderid).length.toString(),style: TextStyle(color: Colors.red)),
                                                        WidgetSpan(child: SizedBox(width: 5)),
                                                        TextSpan(text: 'pending order requests', style: TextStyle())
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                    color: Colors.redAccent, //color of divider
                                                    height: 40, //height spacing of divider
                                                    thickness: 20, //thickness of divier line
                                                    // indent: 0, //spacing at the start of divider
                                                    // endIndent: 25, //spacing at the end of divider
                                                  ),
                                                  SizedBox(height: 8,),
                                                  CarouselSlider(
                                                    items: criticalOrder!.map((item) {
                                                      return Container(
                                                        height: 370,
                                                        width: 250,
                                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFFFFFFFF),
                                                          borderRadius: BorderRadius.circular(8),
                                                          border: Border.all(
                                                            color: const Color(0xFFF69A85C).withOpacity(0.5),
                                                            width: 1,
                                                            style: BorderStyle.solid,
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Color.fromARGB(50, 133, 190, 73),
                                                              blurRadius: 12.0, // soften the shadow
                                                              spreadRadius: 2.0, //extend the shadow
                                                              offset: Offset(
                                                                5.0, // Move to right 5  horizontally
                                                                5.0, // Move to bottom 5 Vertically
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 13.0, left: 45),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "ORDER#:",
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontFamily: 'Nunito',
                                                                      color: Colors.grey,
                                                                      height: 1.1,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    item.orderNumber.toString(),
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontFamily: 'Nunito',
                                                                      color: Colors.black,
                                                                      height: 1.1,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 25,
                                                            ),
                                                            Column(children: [
                                                              Text(
                                                                item.orderid!.customerName!,
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: 'Nunito',
                                                                  color: Colors.black,
                                                                  height: 1.1,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                item.orderid!.deliveryAddress!,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(

                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontFamily: 'Nunito',
                                                                  color: Colors.black54,
                                                                  height: 1.1,
                                                                ),
                                                              ),
                                                            ],),

                                                            SizedBox(
                                                              height: 4,
                                                            ),

                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 8, right:110 ),
                                                              child: Text(
                                                                item.orderid!.deliveryDate.toString(),
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: Color(0xFFF69A85C).withOpacity(0.8),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 8,right: 110),
                                                              child: Text(
                                                                item.orderid!.deliveryTime.toString(),
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Colors.red,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 8, left: 8),
                                                              child: Row(
                                                                children: [
                                                                Text(
                                                                  item.orderid!.stats!.last.status.toString(),
                                                                style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w400,
                                                                color: Colors.red,
                                                                ),
                                                                ),


                                                                  SizedBox(
                                                                    width: 25,
                                                                  ),
                                                                  Image.asset('assets/dashboard/rupee.png'),
                                                                  FittedBox(
                                                                    child: Text(
                                                                      item.orderid!.totalPriceDelivery.toStringAsFixed(2),
                                                                      style: TextStyle(
                                                                        fontSize: 12,
                                                                        fontWeight: FontWeight.w400,
                                                                        color: Colors.black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.all(9.0),
                                                              child: Text(
                                                         // item.orderid!.products!.length > 4 ?
                                                         //    item.orderid!.products!.map((e) => e.productid).map((e) => e!.productname).join(',').toString()
                                                                item.orderid!.products!.length > 1 ?
                                                                "${item.orderid!.products!.map((e) => e.productid).map((e) => e!.productname).first } & ${item.orderid!.products!.length} items":
                                                                "${item.orderid!.products!.map((e) => e.productid).map((e) => e!.productname).join(',').toString()}",
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                            ),


                                                            OutlinedButton(


                                                              style: OutlinedButton.styleFrom(
                                                                backgroundColor:Color(0xFF89C74A),
                                                                primary: Colors.white,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.all(Radius.circular(20),

                                                                  ),

                                                                ),
                                                                // side: BorderSide(color: Colors.red, width: 1),
                                                                // side: MaterialStateProperty.all(BorderSide(color: Colors.red, width: 2),
                                                              ),
                                                              // ),
                                                              onPressed:(){
                                                                // print(item.orderNumber);
                                                                onSelected!(item);
                                                                // setState(() {
                                                                //   isDialogVisible = false;
                                                                // });
                                                                // Navigator.pop(context);
                                                              },
                                                              child: Text('Order Details'),
                                                            ),




                                                          ],
                                                        ),
                                                      );

                                                      //Text(item);
                                                    }).toList(),
                                                    options: CarouselOptions(

                                                      height: 350,
                                                      aspectRatio: 16 / 9,
                                                      enlargeCenterPage: true,
                                                      enableInfiniteScroll: false,
                                                      enlargeFactor: 0.3,
                                                      onPageChanged: (index, reason) {
                                                        setState(() {
                                                          currentPage = index.toDouble();
                                                          // print("Cuurent page ==>${currentPage}");

                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  // Positioned(
                                                  //   bottom: 10,
                                                  //   left: 0,
                                                  //   right: 0,

                                              Container(
                                                child: DotsIndicator(
                                                  // dotsCount: criticalOrder!.map((e) => e.orderid).length,
                                                  dotsCount:criticalOrder.map((e) => e.orderid).length >= 1 ?
                                                  criticalOrder.map((e) => e.orderid).length : 1,
                                                  position: currentPage!,
                                                  decorator: DotsDecorator(
                                                    activeColor: Color(0xFF89C74A),
                                                    activeSize: const Size(18.0, 9.0),
                                                    activeShape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5.0)),
                                                  ),
                                                ),
                                              ),

                                                  // Builder(
                                                  //   builder: (context) {
                                                  //     if(criticalOrder.map((e) => e.orderid).length >= 1 &&criticalOrder.map((e) => e.orderid).length != null&& currentPage != null)
                                                  //       {
                                                  //         return Container(
                                                  //           child: DotsIndicator(
                                                  //             // dotsCount: criticalOrder!.map((e) => e.orderid).length,
                                                  //             dotsCount: criticalOrder.map((e) => e.orderid).length,
                                                  //             position: currentPage!,
                                                  //             decorator: DotsDecorator(
                                                  //               activeColor: Color(0xFF89C74A),
                                                  //               activeSize: const Size(18.0, 9.0),
                                                  //               activeShape: RoundedRectangleBorder(
                                                  //                   borderRadius: BorderRadius.circular(5.0)),
                                                  //             ),
                                                  //           ),
                                                  //         );
                                                  //       }
                                                  //     return Container();
                                                  //   }
                                                  // ),
                                                  // ),






                                                  SizedBox(height: 8,),



                                                ],

                                              ),
                                            );




                                  } ),

                                  ),
                                  );
                                        // if (isDialogOpen==true) {
                                        //   // Close the dialog
                                        //   print("Open dialog ====>${isDialogOpen}");
                                        //   Navigator.of(dialogContext!).maybePop();
                                        //   // Future.delayed(Duration.zero, () {
                                        //   //   Navigator.pop(dialogContext);
                                        //   // });
                                        //
                                        //   isDialogOpen = false;
                                        // }
                                      if(criticalOrder!.map((e) => e.orderid).length> 0)
                                        {

                                          if(Provider.of<UserDataViewModel>(context,listen: false).criticalOrderResponse !=null)
                                            {

                                              showDialog(
                                                context: context,
                                                // barrierColor: Colors.black.withOpacity(0.9),
                                                barrierDismissible: false,
                                                barrierColor: Color(0x00ffffff),
                                                builder: (BuildContext context) {
                                                  // dialogContext = dialogContext;
                                                  // isDialogOpen = true;

                                                  // if(criticalOrder!.map((e) => e.orderid).length> 0)
                                                  // {
                                                  return WillPopScope(
                                                      onWillPop: () async {
                                                    // Perform any custom logic here
                                                    // Return false to prevent the dialog from closing
                                                    return false;
                                                  },
                                                  child: criticalDialog);
                                                  // }

                                                },
                                              );
                                            }

                                        }

                                      return HomeScreen(isShowDialog: true);

                                      }

                          }
