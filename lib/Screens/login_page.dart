import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learningapp_flutter/Helpers/encrypter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String successtxt="",errtxt="";
  final _formkey=GlobalKey<FormState>();
  TextEditingController _logincontroller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all( 30.0),
              child:Form(
                key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Image(
                      //width: 180,
                      //height: 230,
                      height: size.height * 0.2,
                      image: AssetImage("assets/images/Techdemy_logo1.png",)
                  ),
                  Text(
                    'Welcome Back,',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Make it work, make it right, make it last',
                    style: new TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Form(
                      child: Container(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _logincontroller,
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
                                }),
                              SizedBox(
                                height: 20,
                              ),
                           /* Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text('Forgot Password?'),
                              ),
                            ),*/

                            (errtxt!="" && errtxt!=null)?Text(errtxt,
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
                            ):(successtxt!="")?Text(successtxt,
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
                            ):Text("",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                child: Text('LOGIN'),
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
                                  if(_formkey.currentState!.validate()){
                                    var url = 'https://techdemy.in/connect/api/userlogin';
                                    final Map<String,String> data = {"login_data":_logincontroller.text};
                                    print("testing data"+data.toString());
                                    try{
                                        final response=await http.post(Uri.parse(url),
                                        body:json.encode({"data":encryption(json.encode(data))}),
                                          encoding:Encoding.getByName('utf-8'),
                                          headers:{
                                            "CONTENT-TYPE":"application/json"
                                          }).timeout(Duration(seconds: 20));
                                        Map<String,String> dat={"data":encryption(json.encode(data))};
                                        print("testing data"+dat.toString());
                                        print("testing data"+response.statusCode.toString());
                                        if(response.statusCode==200){
                                          Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;
                                          print(result.toString());
                                          if(result["status"]=="success"){
                                            SharedPreferences sp=await SharedPreferences.getInstance();
                                            sp.setInt("user_id", result["user_id"]);
                                            sp.setString("login_data", _logincontroller.text);
                                            //sp.setString("login_data", _logincontroller.text);
                                            setState((){
                                              successtxt="LoggedIn Successfully";
                                              errtxt="";
                                              _logincontroller.clear();
                                            });
                                            Future.delayed(const Duration(milliseconds: 1000), () {
                                              setState(() {
                                                Navigator.pushNamed(context, "/verification");
                                              });
                                            });
                                          } else if(result["status"]=="failure"){
                                            SharedPreferences sp=await SharedPreferences.getInstance();
                                            sp.setInt("user_id", result["user_id"]);
                                            sp.setString("login", _logincontroller.text);
                                            setState((){
                                              successtxt="Phone No / Email not Exist";
                                              errtxt="";
                                              _logincontroller.clear();

                                            });
                                            Future.delayed(const Duration(milliseconds: 1000), () {
                                              setState(() {
                                                Navigator.pushNamed(context, "/login");
                                              });
                                            });
                                          }else{
                                            setState((){
                                              successtxt="";
                                              errtxt=result["message"];
                                            });
                                            //Navigator.pushNamed(context, "/scanner");
                                          }
                                        }else{
                                          setState((){
                                            successtxt="";
                                            errtxt=="Please Check your Internet Connection And data -  1";
                                          });
                                        }
                                    }on TimeoutException catch (_) {
                                      setState((){
                                        successtxt="";
                                        errtxt="Please Check your Internet Connection And data - 2";
                                      });

                                    }on Exception catch(e){
                                      setState((){
                                        errtxt=e.toString();
                                        successtxt="";
                                      });
                                    }
                                  }
                                },
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:<Widget> [
                                Text(
                                  "Don't have an account?",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                TextButton(
                                    onPressed: (){
                                      Navigator.pushNamed(context, '/signup');
                                    },
                                    child: Text("Signup",textAlign: TextAlign.start,)
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
                        ),
                      )
                  )
                ],
              ),
              )
            ),
          ),
        )
    );
  }
}
