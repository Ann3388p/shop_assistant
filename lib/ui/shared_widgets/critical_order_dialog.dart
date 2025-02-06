import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

import '../../core/models/critical_order.dart';
class CriticalOrderDialog extends StatefulWidget {
   List<CriticalOrder>  ? criticalOrder;
    Function(CriticalOrder) ? onSelected;
   Function(CriticalOrder) ? onSelectedReject;
   Function(CriticalOrder) ? onSelectedOrderDetails;
    // bool  isVisible;
   // List<VoidCallback> onPressedAccept = [];
   // VoidCallback? onPressedAccept;
   // VoidCallback? onPressedReject;
   CriticalOrderDialog({Key? key,this.criticalOrder,
     this.onSelected,
     this.onSelectedReject,
     this.onSelectedOrderDetails,
    // required  this.isVisible
     // this.onPressedAccept,this.onPressedReject
   }) : super(key: key);

  @override
  State<CriticalOrderDialog> createState() => _CriticalOrderDialogState();
}

class _CriticalOrderDialogState extends State<CriticalOrderDialog> {
  final PageController _pageController = PageController();
  double currentPage = 0;
  // bool isDialogVisible = true;

  // void _handleNavigation() {
  //   // Code to navigate to the next screen
  //   // ...
  //
  //
  //   // Update the value of the boolean variable
  //   setState(() {
  //     isDialogVisible = false;
  //   });
  // }
  // final List<String> items = ['Item 1', 'Item 2', 'Item 3'];
  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!;

      });
    });
  }

  Widget build(BuildContext context) {
    // if(isDialogVisible==true){
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), //this right here
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0.5),
          height: MediaQuery.of(context).size.height*0.65,
          decoration: const BoxDecoration(
            // color: ColorTheme.lightBackground,
          ),
          // child: StatefulBuilder(
          //     builder: (context, setState) {
          child: SingleChildScrollView(
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
                      TextSpan(text: widget.criticalOrder!.map((e) => e.orderid).length.toString(),style: TextStyle(color: Colors.red)),
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
                  items: widget.criticalOrder!.map((item) {
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
                          // Padding(
                          //   padding: const EdgeInsets.only(right: 137.0),
                          //   child: Text(
                          //     item.orderid!.customerName!,
                          //     style: TextStyle(
                          //       fontSize: 12,
                          //       fontWeight: FontWeight.w500,
                          //       fontFamily: 'Nunito',
                          //       color: Colors.black,
                          //       height: 1.1,
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 3),
                          //   child: Text(
                          //     item.orderid!.deliveryAddress!,
                          //     style: TextStyle(
                          //       fontSize: 12,
                          //       fontWeight: FontWeight.w500,
                          //       fontFamily: 'Nunito',
                          //       color: Colors.black54,
                          //       height: 1.1,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: 4,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(right: 65.0),
                          //   child: Text(
                          //     "Overbridge, Thampanoor...",
                          //     style: TextStyle(
                          //       fontSize: 12,
                          //       fontWeight: FontWeight.w500,
                          //       fontFamily: 'Nunito',
                          //       color: Colors.black54,
                          //       height: 1.1,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 98.0),
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
                                Text(
                                  item.orderid!.totalPriceDelivery.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Text(
                              item.orderid!.products!.map((e) => e.productid).map((e) => e!.productname).join(',').toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          // Flexible(
                          //    child: Row(
                          //      children: [
                          //        SizedBox(width: 8,),
                          //        SizedBox(
                          //          width: 100.0,
                          //          child: OutlinedButton(
                          //
                          //            style: OutlinedButton.styleFrom(
                          //              // minimumSize: Size.fromHeight(20),
                          //               shape: RoundedRectangleBorder(
                          //          borderRadius: BorderRadius.all(Radius.circular(20),
                          //
                          //          ),
                          //
                          //               ),
                          //                side: BorderSide(color: Colors.red, width: 1),
                          //              // side: MaterialStateProperty.all(BorderSide(color: Colors.red, width: 2),
                          //              ),
                          //            // ),
                          //            // onPressed: widget.onPressedReject,
                          //            onPressed: (){
                          //              widget.onSelectedReject!(item);
                          //            },
                          //            child: Text('Reject'),
                          //          ),
                          //        ),
                          //        SizedBox(width: 5,),
                          //        SizedBox(
                          //          width: 100.0,
                          //          child: OutlinedButton(
                          //
                          //
                          //            style: OutlinedButton.styleFrom(
                          //              backgroundColor:Color(0xFF89C74A),
                          //              primary: Colors.white,
                          //              shape: RoundedRectangleBorder(
                          //                borderRadius: BorderRadius.all(Radius.circular(20),
                          //
                          //                ),
                          //
                          //              ),
                          //              // side: BorderSide(color: Colors.red, width: 1),
                          //              // side: MaterialStateProperty.all(BorderSide(color: Colors.red, width: 2),
                          //            ),
                          //            // ),
                          //            onPressed:(){
                          //              // print(item.orderNumber);
                          //              widget.onSelected!(item);
                          //            },
                          //            child: Text('Accept'),
                          //          ),
                          //        ),
                          //        // Padding(
                          //        //   padding: const EdgeInsets.only(left: 4.0),
                          //        //   child: PrimaryButton(
                          //        //       title: "Accept",
                          //        //       onPressed: (){}),
                          //        //
                          //        // ),
                          //      ],
                          //    ),
                          //  ):Container(),

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
                              widget.onSelected!(item);
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
                    enlargeFactor: 0.3,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentPage = index.toDouble();
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
                      dotsCount: widget.criticalOrder!.map((e) => e.orderid).length,
                      position: currentPage,
                      decorator: DotsDecorator(
                        activeColor: Color(0xFF89C74A),
                        activeSize: const Size(18.0, 9.0),
                        activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                  ),
                   ),
                // ),




                // SizedBox(height: 14,),
                // Consumer<UpdateStoreViewModel>(
                //     builder: (context,value,child) {
                //       return Column(
                //         children: [
                //           ListBody(
                //
                //             children: value.businessList!
                //                 .map((businessListItem) => CheckboxListTile(
                //               activeColor: Colors.green,
                //               value: value.selectedbusinesstype.contains(businessListItem),
                //               selected: value.selectedbusinesstype.contains(businessListItem),
                //               title: Text(businessListItem.name!,style: Theme.of(context)
                //                   .textTheme
                //                   .subtitle2
                //                   ?.copyWith(fontWeight: FontWeight.w600)),
                //               // check box click
                //               onChanged: (isChecked) => value.updatedSelectedBusinessType(businessListItem, isChecked!),
                //               secondary: CircleAvatar(
                //                 backgroundImage: NetworkImage(businessListItem.iconImage!),
                //               ),
                //             ))
                //                 .toList(),
                //           ),
                //           Builder(
                //               builder: (context) {
                //                 if(value.activeAddButton()) {
                //                   return PrimaryButton(
                //                       title: "Confirm Department",
                //                       onPressed: () {
                //                         // value.confirmbusinesstype = [...value.selectedbusinesstype];
                //                         // value.selectedbusinesstype.map((e) => value.confirmbusinesstype.toList());
                //                         // print(value.confirmbusinesstype.map((e) => e.name).toList());
                //                         value.submitMultiBusinessType(context);
                //                         Navigator.of(context).pop();
                //
                //                       }
                //
                //                   );
                //                 }
                //                 return PrimaryButton(
                //                   title: "Confirm Department",
                //                   onPressed: null,
                //                 );
                //               }
                //           ),
                //           SizedBox(height: 10,)
                //         ],
                //       );
                //
                //
                //       //     ListView.builder(
                //       //         shrinkWrap: true,
                //       //         physics: ScrollPhysics(),
                //       //         scrollDirection: Axis.vertical,
                //       //         itemCount: businessList!.length,
                //       //         itemBuilder: (context, index) {
                //       //          // print(value.businessselectedProducts.map((e) => e.name).toList());
                //       //           return Padding(
                //       //             padding: const EdgeInsets.only(bottom: 7.0),
                //       //              child: BusinessTypeTile(
                //       //                key: UniqueKey(),
                //       //                businessdata: businessList[index],
                //       //
                //       //                value: value.checkProductIsSelected(businessList[index]),
                //       //                selected: value.checkProductIsSelected(businessList[index]),
                //       //                  onSelected:(){
                //       //                    value.updatebusinessSelectedProducts(businessList[index]);
                //       //                  }
                //       //
                //       //              ),
                //       //
                //
                //
                //
                //
                //     }
                // ),

                SizedBox(height: 8,),



              ],

            ),
          ),
          // } ),

        ),
      );
    // }
    // else {
    //   return Container();
    // }

  }
  // void showDialog() {
  //   setState(() {
  //     isDialogVisible = true;
  //   });
  // }
  //
  // void hideDialog() {
  //   setState(() {
  //     isDialogVisible = false;
  //   });
  // }
}


