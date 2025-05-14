// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../Helpers/encrypter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String successtxt = "", errtxt = "";
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _logincontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  Image(
                    //width: 180,
                    //height: 230,
                    height: size.height * 0.2,
                    image: const AssetImage(
                      "assets/images/Techdemy_logo1.png",
                    )
                  ),
                  const Text(
                    'Welcome Back,',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text(
                    'Make it work, make it right, make it last',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                      color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 50,),
                  Form(
                    child: Column(
                    children: [
                      TextFormField(
                        controller: _logincontroller,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_rounded),
                          //labelText: 'Email',
                          hintText: 'Email or Phone Number',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        }
                      ),
                      const SizedBox(height: 20,),
                      /* Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Forgot Password?'),
                        ),
                      ),*/

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
                                    fontSize: 15
                                  ),
                                )
                              : const Text(
                                  "",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18
                                  ),
                                ),
                      const SizedBox(height: 10,),
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
                          if (_formkey.currentState!.validate()) {
                            var url = 'https://techdemy.in/connect/api/userlogin';
                            final Map<String, String> data = {
                              "login_data": _logincontroller.text
                            };
                            print("testing data $data");
                            try {
                              final response = await http.post(Uri.parse(url),
                                body: json.encode({
                                  "data": encryption(json.encode(data))
                                }),
                                encoding: Encoding.getByName('utf-8'),
                                headers: {
                                  "CONTENT-TYPE": "application/json"
                                }).timeout(const Duration(seconds: 20)
                              );
                              Map<String, String> dat = {
                                "data": encryption(json.encode(data))
                              };
                              print("testing data ${response.body}");
                              print("testing data $dat");
                              print("testing data ${response.statusCode}");
                              if (response.statusCode == 200) {
                                Map<String, dynamic> result = jsonDecode("${decryption(response.body.toString().trim()).split("}")[0]}}") as Map<String, dynamic>;
                                print(result.toString());
                                if (result["status"] == "success") {
                                  SharedPreferences sp = await SharedPreferences.getInstance();
                                  sp.setInt("user_id", result["user_id"]);
                                  sp.setString("login_data", _logincontroller.text);
                                  //sp.setString("login_data", _logincontroller.text);
                                  setState(() {
                                    successtxt = "LoggedIn Successfully";
                                    errtxt = "";
                                    _logincontroller.clear();
                                  });
                                  Future.delayed(const Duration(milliseconds: 1000), () {
                                    setState(() {
                                      Navigator.pushReplacementNamed(context, "/verification");
                                    });
                                  });
                                } else if (result["status"] == "failure") {
                                  SharedPreferences sp = await SharedPreferences.getInstance();
                                  sp.setInt("user_id", result["user_id"]);
                                  sp.setString("login", _logincontroller.text);
                                  setState(() {
                                    successtxt = "Phone No / Email not Exist";
                                    errtxt = "";
                                    _logincontroller.clear();
                                  });
                                  Future.delayed(const Duration(milliseconds: 1000), () {
                                    setState(() {
                                      Navigator.pushNamed(context, "/login");
                                    });
                                  });
                                } else {
                                  setState(() {
                                    successtxt = "";
                                    errtxt = result["message"];
                                  });
                                  //Navigator.pushNamed(context, "/scanner");
                                }
                              } else {
                                setState(() {
                                  successtxt = "";
                                  errtxt == "Please Check your Internet Connection And data -  1";
                                });
                              }
                            } on TimeoutException catch (_) {
                              setState(() {
                                successtxt = "";
                                errtxt = "Please Check your Internet Connection And data - 2";
                              });
                            } on Exception catch (e) {
                              setState(() {
                                errtxt = e.toString();
                                successtxt = "";
                              });
                            }
                          }
                        },
                        child: const Text('LOGIN'),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an account?",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              notificationPermission();
                              Navigator.pushReplacementNamed(context, '/signup');
                            },
                            child: const Text(
                              "Signup",
                              textAlign: TextAlign.start,
                            )
                          )
                        ],
                      ),
                      /* TextButton(
                        onPressed: () {},
                        child: Text.rich(TextSpan(
                          text: 'Dont have an Account? ',
                          style: Theme.of(context).textTheme.bodyText1,
                          children: [
                            TextSpan(
                              text: 'Signup',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        )),
                      ),*/
                    ],
                  ))
                ],
              ),
            )
          ),
        ),
      ),
    );
  }

  Future<void> notificationPermission() async {
    await Permission.notification.request();
    await Permission.sms.request();
  }

  Future<void> listenForSms() async {
    await SmsAutoFill().listenForCode();
  }

  Future<String> apphash() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("app_hash") == null){
      String? hash = await SmsAutoFill().getAppSignature;
      await prefs.setString("app_hash", hash);
      return hash;
    } else {
      return prefs.getString("app_hash")!;
    }
  }
 
  Future<int> generateOTP() async {
    int otp = 1000 + (9999 - 1000) * (DateTime.now().millisecondsSinceEpoch % 1000) ~/ 1000;
    // await storeOtp(otp.toString());
    return otp;
  }

  Future<void> storeOtp(String otp) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setString("last_otp", otp);
  }

  Future<void> clearOTP() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("last_otp");
  }

  Future<String?> getLastOtp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("last_otp");
  }

  // TODO: Check the code API once credits are restored and call this in login button
  Future<void> twilioOTPSender(String mobile) async {
    try {
      await SmsAutoFill().listenForCode();
      int? lastOtp = await generateOTP();
      String hashId = await apphash();
      String key = "f665fb10246333b640a6f6bd929e2af3";
      String receiver = _logincontroller.text;
      String templateId= "1407168862906996721";
      String sms = "Your otp for Maduraimarket is $lastOtp. Please do not share this OTP. $hashId";
      String url = "http://instantalerts.in/api/smsapi?key=$key&route=2&sender=INSTNE&number=$receiver&templateid=$templateId&sms=$sms";
      final response = await http.post(Uri.parse(url),);
      if (response.statusCode == 200) {
        print("OTP sent successfully from $receiver");
      } else {
        print("Failed to send OTP: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }
}
