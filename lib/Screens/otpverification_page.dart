// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sms_autofill/sms_autofill.dart';

import '../Helpers/encrypter.dart';

class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  TextEditingController contrller1 = TextEditingController();
  TextEditingController contrller2 = TextEditingController();
  TextEditingController contrller3 = TextEditingController();
  TextEditingController contrller4 = TextEditingController();
  TextEditingController contrller5 = TextEditingController();
  TextEditingController contrller6 = TextEditingController();

  String successtxt = "", errtxt = "";
  final _formkey_2 = GlobalKey<FormState>();
  String email = "";  
  String _code = "";

  @override
  void dispose() {
    super.dispose();
    SmsAutoFill().unregisterListener();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formkey_2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20,),
                  Image(
                    //width: 180,
                    //height: 230,
                    height: size.height * 0.2,
                    image: const AssetImage("assets/images/Techdemy_logo1.png",)
                  ),
                  //Text("CO\nDE", style: TextStyle(fontSize:100.0,fontWeight: FontWeight.bold, ),),
                  //Text("VERIFICATION",style: TextStyle(fontSize: 15.0,letterSpacing: 2,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 30,),
                  const Text(
                    "Enter the verification code sent to your mail-id",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0,),
                  ),
                  const SizedBox(height: 10,),
                  //Text("example@gmail.com",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 20,),
                  PinFieldAutoFill(
                    codeLength: 4,
                    decoration: UnderlineDecoration(
                      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
                      colorBuilder: FixedColorBuilder(Colors.black.withValues(alpha: 0.3)),
                    ),
                    currentCode: _code,
                    onCodeChanged: (code) async {
                      if (code!.length == 4) {
                        setState(() {
                          _code = code;
                        });
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                      try {
                       
                      } catch (e) {
                        print("Error occured: $e");
                      }
                    },
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     _textFieldOTP(first: true, last: false, controllerr: contrller1),
                  //     _textFieldOTP(first: false, last: false, controllerr: contrller2),
                  //     _textFieldOTP(first: false, last: false, controllerr: contrller3),
                  //     _textFieldOTP(first: false, last: false, controllerr: contrller4),
                  //     /* _textFieldOTP(first: false, last: false, controllerr:
                  //   contrller5),
                  //   _textFieldOTP(first: false, last: true, controllerr:
                  //   contrller6)*/
                  //   ]
                  // ),
                  const SizedBox(height: 15,),
                  (errtxt != "")
                    ? Text(
                        errtxt,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      )
                    : (successtxt != "")
                      ? Text(
                          successtxt,
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )
                      : const Text(
                          "",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                        ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: Colors.black)
                      ),
                      minimumSize: const Size(double.infinity, 50)
                    ),
                    onPressed: () async {
                      Navigator.pushReplacementNamed(context, '/homepage');
                      // if (_formkey_2.currentState!.validate()) {
                      //   SharedPreferences sp =
                      //       await SharedPreferences.getInstance();
                      //   var userId = sp.containsKey("user_id")
                      //       ? sp.getInt("user_id")
                      //       : 0;
                      //   var url = 'https://techdemy.in/connect/api/verifyotp';
                      //   var loginData = sp.getString("login_data");
                      //   // var email = sp.getString("email");
                      //   final Map<String, String> data = {
                      //     "login_data": loginData.toString(),
                      //     "otp": contrller1.text +
                      //         contrller2.text +
                      //         contrller3.text +
                      //         contrller4.text,
                      //     "user_id": userId!.toString()
                      //   };
                      //   print("testing data $data");
                      //   try {
                      //     final response = await http.post(Uri.parse(url),
                      //         body: json.encode(
                      //             {"data": encryption(json.encode(data))}),
                      //         encoding: Encoding.getByName('utf-8'),
                      //         headers: {
                      //           "CONTENT-TYPE": "application/json"
                      //         }).timeout(const Duration(seconds: 20));
                      //     Map<String, String> dat = {
                      //       "data": encryption(json.encode(data))
                      //     };
                      //     print("testing data $dat");
                      //     if (response.statusCode == 200) {
                      //       Map<String, dynamic> result = jsonDecode(
                      //           decryption(response.body.toString().trim())
                      //                   .split("}")[0] +
                      //               "}") as Map<String, dynamic>;
                      //       if (result["status"] == "success") {
                      //         Navigator.pushReplacementNamed(
                      //             context, '/homepage');
                      //         contrller1.clear();
                      //         contrller2.clear();
                      //         contrller3.clear();
                      //         contrller4.clear();
                      //         print('success');
                      //       } else if (result["status"] == "expired") {
                      //         setState(() {
                      //           errtxt = "OTP Expired click resend OTP";
                      //           successtxt = "";
                      //           contrller1.clear();
                      //           contrller2.clear();
                      //           contrller3.clear();
                      //           contrller4.clear();
                      //         });
                      //       } else {
                      //         setState(() {
                      //           errtxt = result["message"];
                      //           successtxt = "";
                      //           contrller1.clear();
                      //           contrller2.clear();
                      //           contrller3.clear();
                      //           contrller4.clear();
                      //         });
                      //       }
                      //     } else {
                      //       setState(() {
                      //         successtxt = "";
                      //         errtxt =
                      //             "Please Check your Internet Connection And data statusCode - 3 ${response.statusCode.toString()}";
                      //       });
                      //     }
                      //   } on TimeoutException catch (_) {
                      //     setState(() {
                      //       successtxt = "";
                      //       errtxt =
                      //           "Please Check your Internet Connection And data - 4";
                      //     });
                      //   } on Exception catch (e) {
                      //     setState(() {
                      //       errtxt = e.toString();
                      //       successtxt = "";
                      //     });
                      //   }
                      // }
                    },
                    child: const Text('Verify OTP'),
                  ),
                  const SizedBox(height: 10,),
                  TextButton(
                    onPressed: () async {
                      SharedPreferences sp = await SharedPreferences.getInstance();
                      sp.containsKey("user_id")
                        ? sp.getInt("user_id")
                        : 0; //print(formatted);
                      var loginData = sp.getString("login_data");
                      try {
                        var url = 'https://techdemy.in/connect/api/resendotp';
                        final Map<String, String> data = {
                          "login_data": loginData.toString()
                        };
                        print(data.toString());
                        final response = await http.post(Uri.parse(url),
                          body: json.encode({"data": encryption(json.encode(data))}),
                          encoding: Encoding.getByName('utf-8'),
                          headers: {
                            "CONTENT-TYPE": "application/json"
                          }).timeout(const Duration(seconds: 20)
                        );
                        Map<String, String> dat = {
                          "data": encryption(json.encode(data))
                        };
                        print("testing data $dat");
                        if (response.statusCode == 200) {
                          Map<String, dynamic> result_1 = jsonDecode(decryption(response.body.toString().trim()).split("}")[0] +"}") as Map<String, dynamic>;
                          print(result_1.toString());
                          if (result_1["status"] == "success") {
                            setState(() {
                              successtxt = result_1["message"];
                              errtxt = "";
                              contrller1.clear();
                              contrller2.clear();
                              contrller3.clear();
                              contrller4.clear();
                            });
                          } else {
                            setState(() {
                              errtxt = result_1["message"];
                              successtxt = "";
                              contrller1.clear();
                              contrller2.clear();
                              contrller3.clear();
                              contrller4.clear();
                            });
                          }
                        } else {
                          setState(() {
                            successtxt = "";
                            errtxt == "Please Check your Internet Connection And data - 1";
                          });
                        }
                      } on TimeoutException catch (_) {
                        setState(() {
                          successtxt = "";
                          errtxt = "Please Check your Internet Connection And data - 2";
                        });
                        //return false;
                      } on Exception catch (e) {
                        setState(() {
                          errtxt = e.toString();
                          successtxt = "";
                        });
                      }
                    },
                    child: const Text("Resend OTP"),
                  )
                ],
              ),
            )
          ),
        ),
      )
    );
  }

  Widget _textFieldOTP({bool? first, last, TextEditingController? controllerr}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: width > 600 ? 55 : height / 12,
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
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.black54),
              borderRadius: BorderRadius.circular(5)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.blue),
              borderRadius: BorderRadius.circular(5)
            ),
          ),
        ),
      ),
    );
  }
}
