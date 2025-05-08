// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../Helpers/encrypter.dart';
import '../Helpers/validator.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String gender = 'Gender';

  var items1 = [
    'Gender',
    'Male',
    'Female',
  ];
  
  String usercategory = 'Select Type';

  var items2 = [
    'Select Type',
    'Internship',
    'Training',
  ];

  String studentyear = 'Select Year';
  var items3 = [
    'Select Year',
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  String experiencelevel = 'Select Experience Level';
  var items4 = [
    'Select Experience Level',
    'Fresher(0-2 Years)',
    '2+ Years',
    '5+ Years',
    '10+ Years'
  ];

  final _formkey = GlobalKey<FormState>();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _mobilecontroller = TextEditingController();
  final TextEditingController _addresscontroller = TextEditingController();
  final TextEditingController _collegecontroller = TextEditingController();
  final TextEditingController _departmentcontroller = TextEditingController();
  
  String name = "";
  String email = "";
  String mobile = "";
  String address = "";
  String collegename = "";
  String department = "";
  String successtxt = "", errtxt = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              Image(
                height: size.height * 0.2,
                image: const AssetImage(
                  "assets/images/Techdemy_logo1.png",
                )
              ),
              const Text(
                'Get On Board!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 10,),
              const Text(
                'Create your profile to start your journey',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15.0,
                  color: Colors.black
                ),
              ),
              const SizedBox(height: 20,),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _namecontroller,
                      validator: (value) => FieldValidator.validateFullname(value!),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_rounded),
                        //labelText: 'Email',
                        hintText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _emailcontroller,
                      validator: (value) => FieldValidator.validateEmail(value!),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.mail_outline),
                        hintText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      /*validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email address';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                      }*/
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _mobilecontroller,
                      keyboardType: TextInputType.number,
                      validator: (value) =>FieldValidator.validateMobile(value!),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone_android),
                        //labelText: 'Email',
                        hintText: 'Mobile Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(),
                    DropdownButtonFormField(
                      value: gender,
                      validator: (value) {
                        if (value == null || value == "Gender") {
                          return 'Please select gender';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      items: items1.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          gender = newValue!;
                        });
                      }
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _addresscontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Address';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.fingerprint),
                        //labelText: 'Email',
                        hintText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    DropdownButtonFormField<String>(
                      value: usercategory,
                      validator: (value) {
                        if (value == null || value == "Select Type") {
                          return 'Please Select Type';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      items: items2.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          usercategory = newValue!;
                        });
                      }
                    ),
                    const SizedBox(height: 10,),
                    if (usercategory == items2[1])
                      TextFormField(
                        controller: _collegecontroller,
                        validator: (value) => FieldValidator.validateCollegeName(value!),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.short_text),
                          //labelText: 'Email',
                          hintText: 'College Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    const SizedBox(height: 10,),
                    if (usercategory == items2[1])
                      TextFormField(
                        controller: _departmentcontroller,
                        validator: (value) => FieldValidator.validateDepartment(value!),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.book),
                          //labelText: 'Email',
                          hintText: 'Department',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    const SizedBox(height: 10,),
                    if (usercategory == items2[1])
                      DropdownButtonFormField(
                        value: studentyear,
                        validator: (value) {
                          if (value == null || value == "Select Year") {
                            return 'Please Select Year';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        items: items3.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            studentyear = newValue!;
                          });
                        }
                      ),
                    if (usercategory == items2[2])
                      DropdownButtonFormField(
                        value: experiencelevel,
                        validator: (value) {
                          if (value == null ||
                              value == "Select Experience Level") {
                            return 'Please Select Experience Level';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        items: items4.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            experiencelevel = newValue!;
                          });
                        }
                      ),
                    const SizedBox(height: 10,),
                    // ignore: unnecessary_null_comparison
                    (errtxt != "" && errtxt != null)
                      ? Text(
                          errtxt,
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
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
                          var url =
                              'https://techdemy.in/connect/api/userregister';
                          final Map<String, String> data = {
                            "name": _namecontroller.text,
                            "email": _emailcontroller.text,
                            "phone_no": _mobilecontroller.text,
                            "gender": gender,
                            "address": _addresscontroller.text,
                            "user_category": usercategory,
                            "college_name": _collegecontroller.text,
                            "department": _departmentcontroller.text,
                            "year": studentyear,
                            "exp_level": experiencelevel
                          };
                          print("Testing data $data");
                          Map<String, String> dat = {
                            "data": encryption(json.encode(data))
                          };
                          print("testing data$dat");
                          try {
                            final response = await http.post(Uri.parse(url),
                              body: json.encode(dat),
                              headers: {
                                "CONTENT-TYPE": "application/json"
                              }).timeout(const Duration(seconds: 20)
                            );
                            print(response.body.toString());
                            if (response.statusCode == 200) {
                              Map<String, dynamic> result = jsonDecode(
                                // ignore: prefer_interpolation_to_compose_strings
                                decryption(response.body.toString().trim()).split("}")[0] +"}"
                              ) as Map<String, dynamic>;
                              print(result.toString());
                              if (result["status"] == "success") {
                                SharedPreferences sp = await SharedPreferences.getInstance();
                                sp.setInt("user_id", result["user_id"]);
                                sp.setString("login_data", _emailcontroller.text);
                                sp.setString("login_data", _mobilecontroller.text);
                                //sp.setBool("resend", false);
                                setState(() {
                                  successtxt = result["message"];
                                  errtxt = "";
                                  _namecontroller.clear();
                                  _emailcontroller.clear();
                                  _mobilecontroller.clear();
                                  _addresscontroller.clear();
                                  _collegecontroller.clear();
                                  _departmentcontroller.clear();
                                  gender = 'Gender';
                                  usercategory = 'Select Type';
                                  experiencelevel = 'Select Experience Level';
                                  studentyear = 'Select Year';
                                });
                                Future.delayed(const Duration(seconds: 2), () {
                                  setState(() {
                                    Navigator.pushNamed(context, "/login");
                                  });
                                });
                                print('success');
                              } /*else if(result["status"]=="not_verified"){
                                print(result.toString());
                                SharedPreferences sp=await SharedPreferences.getInstance();
                                sp.setInt("user_id",result["user_id"]);
                                sp.setString("email",_emailcontroller.text);
                                sp.setBool("resend",false);
                                setState(() {
                                    successtxt="You Already Registered But Not Verified";
                                    errtxt="";
                                });
                                print('success');
                                Future.delayed(const Duration(milliseconds: 1000), () {
                                  setState(() {
                                    Navigator.pushNamed(context,"/verification");
                                  });
                                });
                              }*/
                              else if (result["status"] == "email_exist") {
                                setState(() {
                                  errtxt = result["message"];
                                  successtxt = "";
                                  _namecontroller.clear();
                                  _emailcontroller.clear();
                                  _mobilecontroller.clear();
                                  _addresscontroller.clear();
                                  _collegecontroller.clear();
                                  _departmentcontroller.clear();
                                  gender = 'Gender';
                                  usercategory = 'Select Type';
                                  experiencelevel = 'Select Experience Level';
                                  studentyear = 'Select Year';
                                });
                                //Navigator.pushNamed(context, '/login');
                              } /*else if(result["status"]=="expired"){
                                SharedPreferences sp=await SharedPreferences.getInstance();
                                sp.setInt("user_id", result["user_id"]);
                                sp.setString("email", _emailcontroller.text);
                                sp.setBool("resend", true);
                                try{
                                  var url='https://techdemy.in/connect/api/resendemailotp';
                                  final Map<String,String> data = {"email":email};
                                  final response = await http.post(Uri.parse(url),
                                      body: json.encode({"data":encryption(json.encode(data))}),
                                      encoding: Encoding.getByName('utf-8'),
                                      headers:{
                                        "CONTENT-TYPE":"application/json"
                                      }).timeout(Duration(seconds:20));
                                  Map<String,String> dat={"data":encryption(json.encode(data))};
                                  print("testing data"+dat.toString());
                                  print("testing data"+data.toString());
                                  if(response.statusCode==200){
                                    Map<String,dynamic> result_1=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;
                                    if(result_1["status"]=="success"){
                                      Future.delayed(const Duration(milliseconds: 1000), () {
                                        setState(() {
                                          Navigator.pushNamed(context,"/login");
                                        });
                                      });
                                    }else{
                                      setState((){
                                        errtxt=result_1["message"];
                                        successtxt="";
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
                              }*/
                            } else {
                              setState(() {
                                successtxt = "";
                                errtxt =
                                    "${response.statusCode} :Please Check your Internet Connection And data";
                              });
                            }
                            // ignore: unused_catch_clause
                          } on TimeoutException catch (e) {
                            setState(() {
                              errtxt =
                                  "Please Check your Internet Connection And data";
                              successtxt = "";
                            });
                          } on Exception catch (e) {
                            setState(() {
                              errtxt = e.toString();
                              successtxt = "";
                            });
                          }
                        }
                      },
                      child: const Text('REGISTER'),
                    ),
                    const SizedBox(height: 20,),
                    /*ElevatedButton.icon(
                      icon: Image(
                        image: AssetImage("assets/images/google.png"),
                        height: 30.0,
                        width: 30.0,
                
                      ),
                      label: Text('Sign-In with Google'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side:BorderSide(color: Colors.black)
                          ),
                          minimumSize: Size(double.infinity, 50)
                      ),
                      onPressed: (){
                
                      },
                    ),*/

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account?",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text(
                            "Login",
                            textAlign: TextAlign.start,
                          )
                        )
                      ],
                    ),
                    /*TextButton(
                      onPressed: () {},
                      child: Text.rich(TextSpan(
                        text: 'Already Have An Account? ',
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      )),
                    ),*/
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
