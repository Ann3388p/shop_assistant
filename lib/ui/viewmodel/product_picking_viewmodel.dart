import 'package:flutter/cupertino.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/order_details_model.dart';
import 'package:shop_assistant/core/services/product_picking_services.dart';
import 'package:shop_assistant/ui/shared_widgets/utils.dart';
class ProductPickingViewModel with ChangeNotifier{

  late ApiResponse productResponse;
  Products? _productData;
  bool isLoading = false;
  ProductPickingServices _services = ProductPickingServices();
  Products? get productData => _productData;
  setProductData(Products data){
    _productData = data;
  }
  updateProductStatus(BuildContext context, var orderID, var quantity)async{
    isLoading = true;
    notifyListeners();
    var status = setStatus(quantity);
    Map<String, dynamic> body = {
        "orderid": "$orderID",
        "products": {
          "id": "${_productData!.id}",
          "status": status,
          "shopAssistantQuantity": quantity,
          "price": "${calculateProductPrice(quantity)}"
        },
        "productname": "${_productData!.productid!.productname}"
    };
    productResponse = await _services.updateProductStatus(context,body);
    isLoading = false;
    notifyListeners();
    if(productResponse.haserror){
      Utils.errorDialog(context,'${productResponse.errormsg}',heading: 'Error');
    }else{
      Navigator.of(context)..pop()..pop();
    }
  }

  calculateProductPrice(var shopAssistantQuantity){
    //double.parse(_productData.productPrice)*shopAssistantQuantity;
    return double.parse((_productData!.productPrice*shopAssistantQuantity).toStringAsFixed(2));
  }

  setStatus(var shopQty){
    int status = 2;
    if(_productData!.quantity != shopQty){
      if(shopQty == 0){
        status = 3;
      }else{
        status = 1;
      }
    }
    return status;
  }

}