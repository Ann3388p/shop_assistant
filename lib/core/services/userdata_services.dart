import 'package:firebase_database/firebase_database.dart';
import 'package:shop_assistant/core/models/api_response_model.dart';
import 'package:shop_assistant/core/models/shopping_count_model.dart';
import 'package:shop_assistant/core/services/api_handler.dart';

class UserDataServices{

  getShoppingCount(Map<String, dynamic> body)async{
    String query = r"""query($storeid:ID, $shopAssistantId:ID){
  shoppingCount(
    storeid:$storeid,
    shopAssistantId: $shopAssistantId){
    availableOrdersList
    assignedOrdersList
    totalCountShopping
    readyOrdersList
    readyOrdersListOfShopAssistant
    totalCountDelivery
  }
} """;
    ApiResponse result = await ApiHandler().queryRequest(query,body: body);
    if(!result.haserror){
      final data = ShoppingCountModel.fromJson(result.data["shoppingCount"]);
      return ApiResponse(data: data, haserror: false,errormsg: '');
    }
    return result;
  }

   getAppVersions() async {
    print('get app versions is invoked');
    DatabaseReference _ref = FirebaseDatabase.instance.ref().child("appversions").child("shopAssistant");
    final _url = "https://nearshopz-default-rtdb.asia-southeast1.firebasedatabase.app/";
    // FirebaseApp secondaryApp = Firebase.app('NearShopz');
    // FirebaseDatabase database = FirebaseDatabase.instanceFor(app: secondaryApp);
    // DatabaseReference _ref2 = database.refFromURL(_url);
    // final snap = await _ref2.child("appversions").get();
    // print(snap.toString());
    try{
      final DataSnapshot snapshot = await _ref.get();
      print(snapshot.value);
      return ApiResponse(haserror: false, data: snapshot, errormsg: '');
    }catch(e){
      print("error ==> ${e.toString()}");
    }
    return ApiResponse(haserror: true, errormsg: "Failed to fetch app versions");
  }
}