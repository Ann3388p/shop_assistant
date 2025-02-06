import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_assistant/core/models/user_data_viewmodel.dart';
import 'package:shop_assistant/ui/custom_package/custom_otp_field.dart';
import 'package:shop_assistant/ui/home_screen.dart';
import 'package:shop_assistant/ui/shared_widgets/common_primary_button.dart';
import 'package:shop_assistant/ui/shared_widgets/utils.dart';
import 'package:shop_assistant/ui/viewmodel/otp_validation_viewmodel.dart';

class OtpValidation extends StatefulWidget {
  String mobNo;
  OtpValidation(this.mobNo);
  @override
  _OtpValidationState createState() => _OtpValidationState();
}

class _OtpValidationState extends State<OtpValidation> {
  int _counter = 59;
  late String _pin;
  Stream<int> stopwatch()async*{
    while(_counter>0){
      await Future.delayed(Duration(seconds: 1));
      yield _counter--;
    }
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body : SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: width*.75,
             // color: Colors.blue,
              child: Column(
                children : [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 44,
                      width: 190,
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //       image: AssetImage('assets/mirchi_logo.png'),
                      //       fit: BoxFit.fill),
                      // ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:FittedBox(
                      child: Text(
                        'PHONE NUMBER VERIFICATION',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'OTP sent to +91${widget.mobNo}',
                      style: TextStyle(
                          fontSize: 15,color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'ENTER OTP',
                      style: TextStyle(fontSize: 14,color: Colors.grey[700]),
                    ),
                  ),
                  CustomOTPField(
                    length: 4,
                    width: MediaQuery.of(context).size.width * .75,
                    fieldWidth:60,
                    style: TextStyle(
                        fontSize: 17
                    ),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    //fieldStyle: FieldStyle.underline,
                    onChanged:(_val){
                      // print("on changed invoked $_val}");
                        _pin = _val;
                    },
                    onCompleted: (_val){
                      //print('on completed');
                      _pin = _val;
                    },


                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive OTP ? ",
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      SizedBox(width: 5,),

                      StreamBuilder<int>(
                          stream: stopwatch(),
                          initialData: 59,
                          builder: (context, stream){
                            int? timer = stream.data;
                            if(timer!<=1){
                              return InkWell(
                                onTap: () {
                                  Provider.of<OtpValidationViewModel>(context,listen: false)
                                      .resendOtp(widget.mobNo);

                                  //////////////////////

                                  ////////////////
                                  setState(() {
                                    _counter=59;
                                  });
                                },
                                child: Text(
                                  'Resend Code',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor),
                                ),
                              );
                            }

                            return Text("00:${stream.data.toString().padLeft(2,'0')}",style: TextStyle(fontSize: 12, color: Colors.grey[700]),);
                          }
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),

                  Consumer<OtpValidationViewModel>(
                    builder: (context, value, child) {
                      if(value.isLoading){
                        return CircularProgressIndicator();
                      }
                      return CommonPrimaryButton(
                        title: 'Verify OTP',
                        onPressed: ()async{
                          if(_pin.length==4){
                            await value.doLogin(mobileNumber: widget.mobNo,otp:_pin, context: context);
                            if(!value.loginResponse.haserror ){
                              await Provider.of<UserDataViewModel>(context,listen: false).setUserData(data:value.userData);
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen(isShowDialog: true,)), (route) => false);
                            }
                            // else{
                            //   Utils.errorDialog(context, value.loginResponse.errormsg);
                            // }
                          }
                         // Navigator.of(context).push(MaterialPageRoute(builder:(context)=>HomeScreen()));
                        },
                      );
                    }
                  ),

                ]

              )
            ),
          ),
        ),
      )
    );
  }
}

