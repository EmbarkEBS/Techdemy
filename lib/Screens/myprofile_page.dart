// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Helpers/encrypter.dart';

class MyProfilePage extends StatefulWidget {
  //const MyProfilePage({Key? key}) : super(key: key);
  final Map<String, dynamic> results;
  const MyProfilePage(this.results, {super.key});
  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
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
  List<String> items4 = [
    'Select Experience Level',
    'Fresher(0-2 Years)',
    '2+ Years',
    '5+ Years',
    '10+ Years'
  ];

  bool _loading = true;
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _loading = false;
      });
    });
    name = _namecontroller.text = widget.results["name"];
    gender = widget.results["gender"];
    address = _addresscontroller.text = widget.results["address"];
    email = _emailcontroller.text = widget.results["email"];
    mobile = _mobilecontroller.text = widget.results["phone_no"];
    usercategory = widget.results["user_category"];
    collegename = _collegecontroller.text = widget.results["college_name"];
    department = _departmentcontroller.text = widget.results["department"];
    studentyear = widget.results["year"];
    experiencelevel = widget.results["exp_level"];
    print("usercategory: $usercategory");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile',),
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.home,
              size: 30,
              // color: Colors.white,
            )
          ),
        ],
      ),
      drawer: Drawer(
        width: 250,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.yellow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image.asset(
                  "assets/images/Techdemy-logo-onboarding.png",
                  width: 50,
                  height: 50,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.account_circle_rounded,
              ),
              title: const Text('My Profile'),
              onTap: () async => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(
                Icons.menu_book_sharp,
              ),
              title: const Text('My Courses'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/mycourses");
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout,),
              title: const Text('Logout'),
              onTap: () async {
                //Navigator.pushNamed(context, "/mycourses");
                SharedPreferences sp = await SharedPreferences.getInstance();
                //sp.setBool("stay_signed",false);
                print("before ${sp.getInt("user_id")}");
                sp.setInt("user_id", 0);
                //sp.clear();
                print("after ${sp.getInt("user_id")}");
                Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          enabled: isEnabled,
                          controller: _namecontroller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_rounded),
                            //labelText: 'Email',
                            hintText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => name = value,
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          enabled: isEnabled,
                          controller: _emailcontroller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.mail_outline),
                            //labelText: 'Email',
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            email = value;
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email address';
                            }
                            if (!RegExp(r'\S+@\S+\.\S+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          }
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          enabled: isEnabled,
                          controller: _mobilecontroller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone_android),
                            //labelText: 'Email',
                            hintText: 'Mobile Number',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            mobile = value;
                          },
                        ),
                        const SizedBox(height: 10,),
                        DropdownButtonFormField(
                          value: gender,
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
                          onChanged: isEnabled
                            ? (String? newValue) {
                                setState(() {
                                  gender = newValue!;
                                });
                              }
                            : null
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          enabled: isEnabled,
                          controller: _addresscontroller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.fingerprint),
                            hintText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            address = value;
                          },
                        ),
                        const SizedBox(height: 10,),
                        DropdownButtonFormField<String>(
                          hint: Text(usercategory),
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
                          onChanged:null
                        ),
                        const SizedBox(height: 10,),
                        if (usercategory == items2[1])
                          TextFormField(
                            enabled: isEnabled,
                            controller: _collegecontroller,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.short_text),
                              //labelText: 'Email',
                              hintText: 'College Name',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              collegename = value;
                            },
                          ),
                        const SizedBox(height: 10,),
                        if (usercategory == items2[1])
                          TextFormField(
                            enabled: isEnabled,
                            controller: _departmentcontroller,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.book),
                              //labelText: 'Email',
                              hintText: 'Department',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              department = value;
                            },
                          ),
                        const SizedBox(height: 10,),
                        if (usercategory == items2[1])
                          DropdownButtonFormField(
                            value: studentyear,
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
                            onChanged: isEnabled
                              ? (String? newValue) {
                                  setState(() {
                                    studentyear = newValue!;
                                  });
                                }
                              : null
                          ),
                        if (usercategory == items2[2])
                          DropdownButtonFormField(
                            hint: Text(experiencelevel),
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
                            onChanged: isEnabled
                              ? (String? newValue) {
                                  setState(() {
                                    experiencelevel = newValue!;
                                  });
                                }
                              : null
                          ),
                        const SizedBox(height: 10,),
                        // ignore: unnecessary_null_comparison
                        (errtxt != "" && errtxt != null)
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
                            if (!isEnabled) {
                              setState(() {
                                isEnabled = true;
                              });
                            } else {
                              if (_formkey.currentState!.validate()) {
                                var url = 'https://techdemy.in/connect/api/updateprofile';
                                final Map<String, String> data = {
                                  "user_id": widget.results["appuser_id"],
                                  "name": name,
                                  "gender": gender,
                                  "address": address,
                                  "email": email,
                                  "phone_no": mobile,
                                  "user_category": usercategory,
                                  "college_name": collegename,
                                  "department": department,
                                  "year": studentyear,
                                  "exp_level": experiencelevel
                                };
                                print("profile testing data $data");
                                Map<String, String> dat = {
                                  "data": encryption(json.encode(data))
                                };
                                print("testing data $dat");
                                try {
                                  final response = await http.post(
                                    Uri.parse(url),
                                    body: json.encode(dat),
                                    headers: {
                                      "CONTENT-TYPE": "application/json"
                                    }).timeout(const Duration(seconds:20)
                                  );
                                  print("${response.statusCode}bfbfb");
                                  if (response.statusCode == 200) {
                                    // ignore: prefer_interpolation_to_compose_strings
                                    Map<String, dynamic> result = jsonDecode(decryption(response.body.toString().trim()).split("}")[0] +"}") as Map<String, dynamic>;
                                    print("${result}bfbfb");
                                    if (result["status"] == "success") {
                                      SharedPreferences sp = await SharedPreferences.getInstance();
                                      sp.setInt("user_id", int.parse(widget.results["appuser_id"]));
                                      sp.setString("email", email);
                                      // if(result["message"]=="Registered Successfully"){
                                      setState(() {
                                        successtxt = result["message"];
                                        errtxt = "";
                                        isEnabled = false;
                                      });
                                    } else if (result["status"] == "not_verified") {
                                      setState(() {
                                        errtxt = result["message"];
                                        successtxt = "";
                                      });
                                    } else {
                                      setState(() {
                                        successtxt = "";
                                        errtxt == "Please Check your Internet Connection And data - 3 ${result["status"]}";
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      successtxt = "";
                                      errtxt == "Please Check your Internet Connection And data - 4 ${response.statusCode.toString()}";
                                    });
                                  }
                                } on TimeoutException catch (_) {
                                  setState(() {
                                    successtxt = "";
                                    errtxt = "Please Check your Internet Connection And data - 5";
                                  });
                                  //return false;
                                } on Exception catch (e) {
                                  setState(() {
                                    errtxt = e.toString();
                                    successtxt = "";
                                  });
                                }
                              }
                            }
                          },
                          child: Text(isEnabled ? 'UPDATE' : 'EDIT NOW'),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
