import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/completed_order_list_model.dart';
import 'package:shop_assistant/core/models/order_list_model.dart';
import 'api_handler.dart';

class CompletedOrderServices{
  getCompletedOrderList(Map<String,dynamic> body)async{
    String query = r"""query($pagination:PaginationArg,$shopAssistantId:ID!){
  paginatedCompletedOrdersList(pagination:$pagination,shopAssistantId:$shopAssistantId){
   count
   items{
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
    discountPrice
    finalBillAmount
  }
  }
}""";
    ApiResponse result = await ApiHandler().queryRequest(query,body: body);
    if (!result.haserror){
        CompletedOrderListModel data = CompletedOrderListModel.fromJson(result.data["paginatedCompletedOrdersList"]);
      return ApiResponse(haserror: false,data: data,errormsg: '');
    }else{
      return result;
    }
  }
}