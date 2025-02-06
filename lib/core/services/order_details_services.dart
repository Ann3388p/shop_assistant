import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/order_details_model.dart';
import 'package:shop_assistant/core/models/payment_status_model.dart';
import 'package:shop_assistant/core/models/travel_time_and_distance_model.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/core/services/api_handler.dart';
import 'package:shop_assistant/core/services/navigation_service.dart';
import 'package:shop_assistant/ui/viewmodel/available_orders_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/delivery_new_orders_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/delivery_pending_viewmodel.dart';
import 'package:shop_assistant/ui/viewmodel/order_details_viewmodel.dart';

import '../../ui/shared_widgets/utils.dart';
import '../models/order_ready_model.dart';

class OrderDetailsService{



  OrderDetailsModel orderDetailsData = OrderDetailsModel();

  getOrderDetails(Map<String,dynamic> body)async{
    String query =r"""query($orderid:ID!){
  viewOrder(orderid:$orderid){
   id
    orderNumber    
     storeid{
      storeName
    }
    paymentStatus
    
    products{
      id
      productPrice
      status
      quantity
      productid{
      id
        productname
        price
        promoprice
        uom
        quantity
        image {
          primary
          secondary
        }
      }
      shopAssistantQuantity
      quantity
      price
    }
    totalPrice
    deliveryAddress
    deliveryDate
    deliveryTime
    deliveryType
    mobileNumber
    customerName
    deliveryLat
    deliveryLng
    specialInstructions
    shopAssistantId{
      id
      firstName
      lastName
      phoneNumber
      
    }
    deliveryPartnerId{
      id
      firstName
      lastName
      phoneNumber
      
    }
    stats{
      status
      created
      createdTime
    }
    lastStatus
    deliveryCharge
    totalPriceDelivery
    finalBillAmount
    
    discountPrice
    travelTime{
      text
      value                   
    }
    travelDistance{
      text
      value
    }
    estimatedDeliveryTime
  }
} """;
    ApiResponse result = await ApiHandler().queryRequest(query,body:body);
    print("check response has error => ${result.haserror}");
    if(!result.haserror){
      if(result.data["viewOrder"]!=null){
        print("travel time ====> ${result.data["viewOrder"]['travelTime']['text']}");
        orderDetailsData = OrderDetailsModel.fromJson(result.data["viewOrder"]);
        return ApiResponse(haserror: false,data: orderDetailsData,errormsg: '');
      }
    }
    return result;
  }

  updateEstimatedDeliveryTime(Map<String, dynamic> body) async {
    String query = r'''mutation($orderid:ID!,$estimatedDeliveryTime:String!){
          updateEstimatedDeliveryTime(
            orderid:$orderid,
            estimatedDeliveryTime:$estimatedDeliveryTime){
            id
          }
        } ''';
    ApiResponse result = await ApiHandler().mutationRequest(query, body: body);
    return result;
  }

  acceptDeliveryOrder(BuildContext context, Map<String,dynamic> body)async{
    String query = r"""mutation($deliveryPartnerId:ID!,$orderId:ID!,$estimatedDeliveryTime:String!){
                  assignOrderToDeliveryPartner(
                    deliveryPartnerId:$deliveryPartnerId,
                    orderId:$orderId,
                  	estimatedDeliveryTime:$estimatedDeliveryTime
                  ){
                    id
                  }
                }""";
    ApiResponse result = await ApiHandler().mutationRequest(query, body: body);
    // removeOrderFromCriticalOrderList(context, body["orderid"]);
    return result;
  }

  acceptOrder(Map<String,dynamic> body, BuildContext context)async{
    String query = r"""mutation($shopAssistantId:ID!,$orderid:ID!,$stats:StatusInput!){
  updateOrderStatus(
    shopAssistantId:$shopAssistantId,
    orderid:$orderid,
    stats:$stats){
    id
  }
} """;

    ApiResponse result = await ApiHandler().mutationRequest(query,body: body);
    if(!result.haserror){
      scheduleAlert(context, status: body["stats"]["status"]);
      removeOrderFromCriticalOrderList(context, body["orderid"]);
    }
    return result;
  }
  removeOrderFromCriticalOrderList(BuildContext context, String? orderID) async {
    await Provider.of<UserDataViewModel>(context,listen: false).removeCriticalOrderFromList(context, orderID);
  }
  removeOrderFromAvailableList(BuildContext context, String? orderID){
    Provider.of<AvailableOrdersViewModel>(context,listen: false)
        .removeOrderFromAvailableList(orderID);
  }

  removeOrderFromShoppingList(BuildContext context, String? orderId){
    Provider.of<OrderDetailsViewModel>(context,listen: false)
        .removeOrderFromAvailableList(orderId);
  }

  // removeOrderFromReadyList(BuildContext context, String? orderID){
  //   Provider.of<ReadyOrdersViewModel>(context,listen: false)
  //       .removeOrderFromReadyList(orderID);
  // }

  removeOrderFromDeliveryPendingList(BuildContext context, String? orderID){
    Provider.of<DeliveryPendingViewModel>(context,listen: false)
        .removeOrderFromDeliveryPendingList(orderID);
    //_removeDeliveryCount(context);
  }

  removeOrderFromDeliveryNewList(BuildContext context, String? orderID){
    Provider.of<DeliveryNewOrdersViewModel>(context,listen: false)
        .removeOrderFromDeliveryNewList(orderID);
  }
  _removeDeliveryCount(BuildContext context){
    Provider.of<UserDataViewModel>(context,listen: false).decrementDeliveryCount();
  }

  startShopping(Map<String,dynamic> body,BuildContext context)async{
    String query = r"""mutation($shopAssistantId:ID!,$orderid:ID!,$stats:StatusInput!){
  updateOrderStatus(
    shopAssistantId:$shopAssistantId,
    orderid:$orderid,
    stats:$stats){
    id
  }
} """;
    ApiResponse result = await ApiHandler().mutationRequest(query,body: body);
    if(!result.haserror){
      scheduleAlert(context, status: body["stats"]["status"]);
      Provider.of<UserDataViewModel>(context,listen: false).isShowDialog = false;
      // removeOrderFromCriticalOrderList(context, body["orderid"]);
    }
    print("${result.errormsg}");

    return result;
  }

  updateStatus(Map<String,dynamic> body, BuildContext context)async{
    String query = r"""mutation($shopAssistantId:ID!,$orderid:ID!,$stats:StatusInput!){
  updateOrderStatus(
    shopAssistantId:$shopAssistantId,
    orderid:$orderid,
    stats:$stats){
    id
  }
} """;
    ApiResponse result = await ApiHandler().mutationRequest(query,body: body);
    if(!result.haserror){
      scheduleAlert(context, status: body["stats"]["status"]);
      removeOrderFromCriticalOrderList(context, body["orderid"]);

    }
    return result;
  }



  scheduleAlert(BuildContext context, {required String status})async{
    final userProvider = Provider.of<UserDataViewModel>(context,listen: false);
    final orderProvider = Provider.of<OrderDetailsViewModel>(context,listen: false);
    Map<String, dynamic> body = {
      "storeid":userProvider.storeID,
      "shopassistantId":userProvider.userID,
      "orderid":orderProvider.orderID,
      "status":status,
      "deliveryDate":orderProvider.orderData.deliveryDate,
      "deliveryTime":orderProvider.orderData.deliveryTime,
      "orderNumber":orderProvider.orderData.orderNumber
    };
    String query = r"""mutation(
  $storeid:ID,
  $shopassistantId:ID,
  $orderid:ID,
  $status:String,
  $deliveryDate:String,
  $deliveryTime:String,
  $orderNumber:Int
){
  scheduleAlertOnStatus(
    storeid:$storeid,
    shopassistantId:$shopassistantId,
    orderid:$orderid,
    status:$status,
    deliveryDate:$deliveryDate,
    deliveryTime:$deliveryTime,
    orderNumber:$orderNumber)
} """;

    ApiResponse result = await ApiHandler().mutationRequest(query, body: body, scheduleAlert: true);
    print("SCHEDULE ALERT RESULT=> $result");
  }


  getPaymentStatus(Map<String,dynamic> body)async{
    String query = r"""query($orderid:ID!){
            viewOrder(orderid:$orderid){
             paymentStatus
            }
          } """;
    ApiResponse result = await ApiHandler().queryRequest(query,body: body);
    if(!result.haserror){
      final data = PaymentStatusModel.fromJson(result.data["viewOrder"]);
      return ApiResponse(haserror: false,data: data,errormsg: '');
    }
    return result;
  }

  changePaymentToCash(Map<String,dynamic> body)async{
    String query = r"""mutation($orderid:ID){
              updatePaymentStatus(orderid:$orderid)
            } """;
    ApiResponse result = await ApiHandler().mutationRequest(query,body: body);
    return result;
  }

  updateOrderStatusWithComment(Map<String, dynamic> body)async{
    String query = r'''mutation($shopAssistantId:ID!,$commentsSeller: String, $orderid: ID!, $stats: StatusInput!) {
        updateOrderStatus(
            shopAssistantId:$shopAssistantId,
            commentsSeller: $commentsSeller
            orderid: $orderid
            stats: $stats
        ) {
            id
            orderNumber
            lastStatus
       }
    } ''';
    ApiResponse response = await ApiHandler().mutationRequest(query, body: body);
    if(!response.haserror){
      scheduleAlert( NavigationService.navigatorKey.currentContext!,status: body['stats']['status']);
      removeOrderFromCriticalOrderList(NavigationService.navigatorKey.currentContext!, body["orderid"]);
    }
    return response;
  }

  getTravelTimeAndDistance(Map<String, dynamic> body) async {
    String query = r'''mutation($orderid:ID!){
        findDeliveryTimeAndDistance(orderid:$orderid){
          id
          travelTime{
            text
            value
          }
          travelDistance{
            text
            value
          }
        }
      } ''';
    ApiResponse result = await ApiHandler().mutationRequest(query, body: body);
    if(!result.haserror){
      final data = TravelTimeAndDistanceModel.fromJson(result.data['findDeliveryTimeAndDistance']);
      return ApiResponse(data: data, haserror: false);
    }
    return result;
  }

  changeOrderStatusToReady(BuildContext context,var orderId,var finalBillAmount) async{

    List<Map> productDataJson = [];
    print("FINAL BILL AMOUNT HERE==>${Provider.of<OrderDetailsViewModel>(context,listen: false).amountController.text}");

    for(int i = 0; i< orderDetailsData.products!.length;i++) {
      print("quantity --->${orderDetailsData.products![i].quantity}");
      print("shop assistant quantity --->${orderDetailsData.products![i].shopAssistantQuantity}");
      productDataJson.add(
          {
            "id": orderDetailsData.products![i].id,
            "productid": orderDetailsData.products![i].productid!.id,
            "productPrice":orderDetailsData.products![i].productPrice,
            "quantity":orderDetailsData.products![i].quantity,
            "status": orderDetailsData.products![i].shopAssistantQuantity == null ? 2 : orderDetailsData.products![i].shopAssistantQuantity == 0 ? 3 : orderDetailsData.products![i].quantity == orderDetailsData.products![i].shopAssistantQuantity ? 2 : 1,
            // "status": orderDetailsData.products![i].quantity == orderDetailsData.products![i].shopAssistantQuantity? 2:1,
            //"status":orderDetailsData.products![i].status,
            // "status": orderDetailsData.products![i].quantity != orderDetailsData.products![i].shopAssistantQuantity ? orderDetailsData.products![i].shopAssistantQuantity == 0 ? 3 : 1 : 2,
            // "shopAssistantQuantity":orderDetailsData.products![i].shopAssistantQuantity== null ? 0 : orderDetailsData.products![i].shopAssistantQuantity,

            "shopAssistantQuantity": orderDetailsData.products![i].shopAssistantQuantity??orderDetailsData.products![i].quantity,
            // "status": orderDetailsData.products![i].shopAssistantQuantity == null? 2   :orderDetailsData.products![i].quantity == orderDetailsData.products![i].shopAssistantQuantity ? 2:1 ,
            "price": orderDetailsData.products![i].price.toString()

          });
    }

    Map<String,dynamic> body = {
      
      "orderid":orderId,
      "finalBillAmount":Provider.of<OrderDetailsViewModel>(context,listen: false).amountController.text == "" ? finalBillAmount :
      double.parse(Provider.of<OrderDetailsViewModel>(context,listen: false).amountController.text),

     // finalBillAmount,
      "products":productDataJson
    };

    String query = r'''mutation($orderid: ID!,$products:[ProductsInput], $finalBillAmount: Float!){
  truncatedOrderStatusToReady(
  orderid: $orderid,
  finalBillAmount : $finalBillAmount
  products:$products)
  {
    id
    orderNumber
    products{
      id
      productid{
        productname
      }
      productPrice
      quantity
      shopAssistantQuantity
      price
      status
    }
    totalPrice
    totalPriceDelivery
  }
}''';

    print(body);
    ApiResponse result = await ApiHandler().mutationRequest(query, body: body);
    if(!result.haserror) {
      // Utils.errorDialog(context, result.errormsg);
      scheduleAlert(NavigationService.navigatorKey.currentContext!,
          status: 'Order-Ready');
    }
      if(result.errormsg =='Error: ValidationError: "finalBillAmount" must be a positive number')
      {
        print("test");


         Utils.errorDialog(context, "Sorry! cant proceed this order",heading:"Error");

      return result;
    }

    if (result.data != null)
    {
      TruncatedOrderStatusToReadyModel productsData =
      TruncatedOrderStatusToReadyModel.fromJson(result.data["truncatedOrderStatusToReady"]);

      if(result.data!["truncatedOrderStatusToReady"]["status"] == 3){
        return Utils.errorDialog(context, "Please Enter Shop Assistant qty",heading:"Error");
      }

    /*  if(double.parse(finalBillAmount) == 0.0){
        print("FINALBILLAMOUNTISZERO");
        return Utils.errorDialog(context, "Please Enter Final Bill Amount",heading:"Error");
      }*/
      return ApiResponse(haserror: false,data: productsData,errormsg: '');
    }

    /*if(result.data !=null){
      print(result.data!["truncatedOrderStatusToReady"].length);
      result.data!['truncatedOrderStatusToReady'].forEach((v){
        result.data.add(TruncatedOrderStatusToReadyModel.fromJson(v));
      });


    }*/




  }




/* changeOrderStatusToOrderReady(
      {String? orderid,
        String? productid,
        required int productPrice,
        required int quantity,
      required int status,
        required int shopAssistantQuantity,
        required String price}) async{



    String query = '''mutation{
  truncatedOrderStatusToReady(
  orderid: "$orderid",
  products:
  {productid:"$productid",
      productPrice:$productPrice,
      quantity:$quantity,
      status:$status,
      shopAssistantQuantity:$shopAssistantQuantity,
      price:"$price"})
  {
    id
    orderNumber
    products{
      id
      productid{
        productname
      }
      productPrice
      quantity
      shopAssistantQuantity
      price
      status
    }
    totalPrice
    totalPriceDelivery
  }
}''';




    ApiResponse result = await ApiHandler().mutationRequestWithoutBody(query);
    *//*if(!result.haserror)
    {
      final data = TravelTimeAndDistanceModel.fromJson(result.data['findDeliveryTimeAndDistance']);
      return ApiResponse(data: data, haserror: false);
    }*//*


    return result;

  }
*/


}