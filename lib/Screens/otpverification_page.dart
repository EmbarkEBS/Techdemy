import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learningapp_flutter/Helpers/encrypter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({Key? key}) : super(key: key);

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {

  TextEditingController contrller1 = new TextEditingController();
  TextEditingController contrller2 = new TextEditingController();
  TextEditingController contrller3 = new TextEditingController();
  TextEditingController contrller4 = new TextEditingController();
  TextEditingController contrller5 = new TextEditingController();
  TextEditingController contrller6 = new TextEditingController();

  String successtxt = "", errtxt = "";
  final _formkey_2 = GlobalKey<FormState>();
  String email = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child:Scaffold(
          body:SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all( 30.0),
              child:Form(
                key: _formkey_2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
               // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Image(
                    //width: 180,
                    //height: 230,
                      height: size.height * 0.2,
                      image: AssetImage("assets/images/Techdemy_logo1.png",)
                  ),
                  //Text("CO\nDE", style: TextStyle(fontSize:100.0,fontWeight: FontWeight.bold, ),),
                  //Text("VERIFICATION",style: TextStyle(fontSize: 15.0,letterSpacing: 2,fontWeight: FontWeight.bold),),
                  SizedBox(height: 30,),
                  Text("Enter the verification code sent to your mail-id",textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0,),),
                  SizedBox(height: 10,),
                  //Text("example@gmail.com",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _textFieldOTP(first: true, last: false, controllerr:
                        contrller1),
                        _textFieldOTP(first: false, last: false, controllerr:
                        contrller2),
                        _textFieldOTP(first: false, last: false, controllerr:
                        contrller3),
                        _textFieldOTP(first: false, last: false, controllerr:
                        contrller4),
                        /* _textFieldOTP(first: false, last: false, controllerr:
                        contrller5),
                        _textFieldOTP(first: false, last: true, controllerr:
                        contrller6)*/
                      ]),
                  SizedBox(
                    height: 15,
                  ),
                  (errtxt != "") ? Text(errtxt,
                    style: TextStyle(color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ) : (successtxt != "") ? Text(successtxt,
                    style: TextStyle(color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ) : Text("",
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    child: Text('Verify OTP'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side:BorderSide(color: Colors.black)
                        ),
                        minimumSize: Size(double.infinity, 50)
                    ),
                    onPressed: ()async{
                      if(_formkey_2.currentState!.validate()){
                      SharedPreferences sp=await SharedPreferences.getInstance();
                      var user_id=sp.containsKey("user_id")?sp.getInt("user_id"):0;
                      var url='https://techdemy.in/connect/api/verifyotp';
                      var login_data=sp.getString("login_data");
                      //var email=sp.getString("email");
                      final Map<String, String> data={
                        "login_data":login_data.toString(),"otp":contrller1.text+contrller2.text+contrller3.text+contrller4.text,
                        "user_id":user_id!.toString()};
                      print("testing data"+data.toString());
                      try{
                        final response=await http.post(Uri.parse(url),
                        body:json.encode({"data":encryption(json.encode(data))}),
                        encoding:Encoding.getByName('utf-8'),
                        headers:{
                         "CONTENT-TYPE":"application/json"
                        }).timeout(Duration(seconds: 20));
                        Map<String, String> dat={"data":encryption(json.encode(data))};
                        print("testing data"+dat.toString());
                        if(response.statusCode==200){
                          Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;
                          if(result["status"]=="success"){

                            Navigator.pushNamed(context, '/homepage');
                            contrller1.clear();
                            contrller2.clear();
                            contrller3.clear();
                            contrller4.clear();
                            print('success');
                          }else if(result["status"]=="expired"){
                            setState(() {
                              errtxt="OTP Expired click resend OTP";
                              successtxt="";
                              contrller1.clear();
                              contrller2.clear();
                              contrller3.clear();
                              contrller4.clear();
                            });
                          }else{
                            setState(() {
                              errtxt=result["message"];
                              successtxt="";
                              contrller1.clear();
                              contrller2.clear();
                              contrller3.clear();
                              contrller4.clear();
                            });
                          }
                        }else{
                          setState((){
                            successtxt="";
                            errtxt="Please Check your Internet Connection And data statusCode - 3" +response.statusCode.toString();
                          });
                        }
                      }on TimeoutException catch(_){
                        setState(() {
                          successtxt="";
                          errtxt="Please Check your Internet Connection And data - 4";
                        });
                      } on Exception catch(e) {
                        setState(() {
                          errtxt = e.toString();
                          successtxt = "";
                        });
                      }
                      }
                    },
                  ),
                  SizedBox(height: 10,),
                  TextButton(
                      child: Text("Resend OTP"),
                      onPressed: ()async{
                        SharedPreferences sp=await SharedPreferences.getInstance();
                        var user_id=sp.containsKey("user_id")?sp.getInt("user_id"):0;                      //print(formatted);
                        var url = 'https://techdemy.in/connect/api/resendotp';
                        var login_data=sp.getString("login_data");
                        try{
                          var url = 'https://techdemy.in/connect/api/resendotp';
                          final Map<String,String> data = {"login_data":login_data.toString()};
                          print(data.toString());
                          final response = await http.post(Uri.parse(url),
                              body: json.encode({"data":encryption(json.encode(data))}),
                              encoding: Encoding.getByName('utf-8'),
                              headers:{
                                "CONTENT-TYPE":"application/json"
                              }).timeout(Duration(seconds:20));
                          Map<String,String> dat={"data":encryption(json.encode(data))};
                          print("testing data"+dat.toString());
                          if(response.statusCode==200){
                            Map<String,dynamic> result_1=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;
                            print(result_1.toString());
                            if(result_1["status"]=="success"){
                              setState(() {
                                successtxt = result_1["message"];
                                errtxt = "";
                                contrller1.clear();
                                contrller2.clear();
                                contrller3.clear();
                                contrller4.clear();
                              });
                            }else{
                              setState((){
                                errtxt=result_1["message"];
                                successtxt="";
                                contrller1.clear();
                                contrller2.clear();
                                contrller3.clear();
                                contrller4.clear();
                              });
                            }
                          }else{
                            setState((){
                              successtxt="";
                              errtxt=="Please Check your Internet Connection And data - 1";
                            });
                          }
                        }on TimeoutException catch (_) {
                          setState((){
                            successtxt="";
                            errtxt="Please Check your Internet Connection And data - 2";
                          });
                          //return false;
                        }on Exception catch(e){
                          setState((){
                            errtxt=e.toString();
                            successtxt="";

                          });

                        }
                      },
                    )
                ],
              ),
              )
            ),
           )
        )
    );
  }
  Widget _textFieldOTP({bool ? first, last, TextEditingController ?controllerr}) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height!/12,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextFormField(
          controller: controllerr,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter Valid OTP';
            }
            return null;
          },
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black54),
                borderRadius: BorderRadius.circular(5)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.blue),
                borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ),
    );
  }
}
