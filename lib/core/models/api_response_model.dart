class ApiResponse<T>{
T? data;
String? errormsg;
bool haserror;
ApiResponse({this.data,this.errormsg,this.haserror=false});
}
//comments