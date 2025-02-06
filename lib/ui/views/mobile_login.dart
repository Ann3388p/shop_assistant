import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';
import 'package:shop_assistant/ui/shared_widgets/utils.dart';
import 'package:shop_assistant/ui/viewmodel/mobile_login_viewmodel.dart';
import 'package:shop_assistant/ui/views/otp_validation.dart';

class MobileLogin extends StatefulWidget {
  @override
  _MobileLoginState createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobileController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
        //  color: Colors.red,
          width: MediaQuery.of(context).size.width*.8,
          height: MediaQuery.of(context).size.height,

          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20,),

                  Center(
                    child: Container(
                      height: 44,
                      width:190,

                      // decoration: BoxDecoration(
                      //   image:DecorationImage(
                      //       image :AssetImage('assets/mirchi_logo.png'),
                      //       fit: BoxFit.fill
                      //   ),
                      // ),
                    ),
                  ),
                 // SizedBox(height: ScreenUtil().setHeight(5),),
                 //  Padding(
                 //    padding: EdgeInsets.symmetric(horizontal: 8,vertical:8),
                 //    child: Text('Welcome back !',style: TextStyle(fontSize:22,color: Colors.black54),),
                 //  ),
                  //SizedBox(height: .0,),
                  Container(
                    //color: Colors.blue,
                      child: Text('Log in with your mobile number',textAlign:TextAlign.center,style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold),)
                  ),
                  SizedBox(height: 28),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical:15),
                    child: TextFormField(
                      controller: _mobileController,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                     // controller: _mobile,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value){
                        if(value!.length!=10){
                          return 'Please enter a valid mobile number';
                        }
                        return null;
                      },
                      // onTap: (){
                      //   _formKey.currentState.validate();
                      // },
                      decoration: InputDecoration(
                          prefixIcon: Container(
                            margin: EdgeInsets.only(left: 10,bottom: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                               // Image.asset('assets/indiaflag.png',height: 15,),
                                SizedBox(width: 6,),
                                Text('+91',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                SizedBox(width: 3,),
                              ],
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color:Colors.red),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color:Colors.red),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ) ,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          hintText: 'Enter your mobile number',
                          hintStyle: TextStyle(color: Colors.grey)
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<MobileLoginViewModel>(
                      builder: (context,value,child) {
                        if(value.isLoading){
                          return Center(child: CircularProgressIndicator());
                        }
                        return CommonPrimaryButton(
                          title: "Log In",
                          onPressed: ()async{
                            if(_formKey.currentState!.validate()){
                              await value.sendOtp(_mobileController.text);
                              if(!value.sendOtpResponse.haserror){
                                Navigator.of(context).push(MaterialPageRoute(builder:(context)=>OtpValidation(_mobileController.text)));
                              }else{
                                Utils.errorDialog(context, value.sendOtpResponse.errormsg);
                              }
                            }
                          },
                        );
                      }
                    ),
                  )


                  //    value.showerrortext ? Text('${value.responseval.errormsg}',style: TextStyle(color: Colors.red,fontSize: ScreenUtil().setSp(14)),) : Text(''),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
