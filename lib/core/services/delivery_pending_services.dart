import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/order_list_model.dart';
import 'package:shop_assistant/core/services/api_handler.dart';

class DeliveryPendingServices {
  getDeliveryPendingOrderList(Map<String,dynamic> body)async{
    String query = r"""query($shopAssistantId:ID!){
  readyOrdersListOfShopAssistant(shopAssistantId:$shopAssistantId){
   id
    orderNumber
    products{
      id
      productPrice
      productid{
        productname
        price
      }
      quantity
      price
    }
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
    totalPrice
    deliveryAddress
    deliveryDate
    deliveryTime
    deliveryType
    mobileNumber
    customerName
    specialInstructions
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
  }
}""";
    ApiResponse result = await ApiHandler().queryRequest(query,body: body);
    if (!result.haserror){
      List<OrderListModel> ordersList =[];
      if(result.data!=null){
        result.data["readyOrdersListOfShopAssistant"].forEach((order)=>{
          ordersList.add(OrderListModel.fromJson(order))
        });
      }
      return ApiResponse(haserror: false,data: ordersList,errormsg: '');
    }else{
      return result;
    }
  }
}