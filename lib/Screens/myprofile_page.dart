import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learningapp_flutter/Models/courseslist_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helpers/encrypter.dart';

class MyProfilePage extends StatefulWidget {
  //const MyProfilePage({Key? key}) : super(key: key);
  final Map<String,dynamic> results;
MyProfilePage(this.results);
  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  final _formkey=GlobalKey<FormState>();
  final TextEditingController _namecontroller=TextEditingController();
  final TextEditingController _emailcontroller=TextEditingController();
  final TextEditingController _mobilecontroller=TextEditingController();
  final TextEditingController _addresscontroller=TextEditingController();
  final TextEditingController _collegecontroller=TextEditingController();
  final TextEditingController _departmentcontroller=TextEditingController();
  String name="";
  String email="";
  String mobile="";
  String address="";
  String collegename="";
  String department="";
  String successtxt="",errtxt="";
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
  bool _loading = true;
  bool isEnabled=false;

  @override
  void initState(){
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _loading = false;
      });
    });
    name=_namecontroller.text=widget.results["name"];
    gender=widget.results["gender"];
    address= _addresscontroller.text=widget.results["address"];
    email= _emailcontroller.text=widget.results["email"];
    mobile=_mobilecontroller.text=widget.results["phone_no"];
    usercategory=widget.results["user_category"];
    collegename=_collegecontroller.text=widget.results["college_name"];
    department=_departmentcontroller.text=widget.results["department"];
    studentyear=widget.results["year"];
    experiencelevel=widget.results["exp_level"];
    print("usercategory: "+usercategory.toString());
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('My Profile'),
            backgroundColor: Colors.black,
            actions: [
              IconButton(
                  onPressed: (){
                    Navigator.pushNamed(context, "/homepage");
                  },
                  icon: Icon(
                    Icons.home, size: 30,color: Colors.white,
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
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                  ),
                  child:  ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.asset("assets/images/Techdemy-logo-onboarding.png", width: 50, height: 50,fit: BoxFit.fitHeight,),

                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.account_circle_rounded,
                  ),
                  title: const Text('My Profile'),
                  onTap: () async{
                    //Navigator.pushNamed(context, "/myprofile");
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.menu_book_sharp,
                  ),
                  title: const Text('My Courses'),
                  onTap: () async{
                    Navigator.pushNamed(context, "/mycourses");
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                  ),
                  title: const Text('Logout'),
                  onTap: () async{
                    //Navigator.pushNamed(context, "/mycourses");
                    SharedPreferences sp=await SharedPreferences.getInstance();
                    //sp.setBool("stay_signed",false);
                    print("before"+sp.getInt("user_id").toString());
                    sp.setInt("user_id",0);
                    //sp.clear();
                    print("after"+sp.getInt("user_id").toString());
                    Navigator.of(context).pushNamedAndRemoveUntil("/login",(route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
          body: _loading?Center(child: CircularProgressIndicator()):SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all( 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  /*Image(
                    //width: 180,
                    //height: 230,
                      height: size.height * 0.2,
                      image: AssetImage("assets/images/Techdemy_logo1.png",)
                  ),
                  Text(
                    'Get On Board!',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),*/
                  Text(
                    'Edit Profile',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                      key:_formkey,
                      child: Container(
                        child: Column(
                          children: [
                            TextFormField(
                              enabled:isEnabled,
                              controller:_namecontroller,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_outline_rounded),
                                //labelText: 'Email',
                                hintText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value){
                                name=value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                enabled:isEnabled,
                                controller: _emailcontroller,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.mail_outline),
                                  //labelText: 'Email',
                                  hintText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value){
                                  email=value;
                                },
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your email address';
                                  }
                                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                }),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              enabled:isEnabled,
                              controller: _mobilecontroller,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.phone_android),
                                //labelText: 'Email',
                                hintText: 'Mobile Number',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value){
                                mobile=value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField(
                                value: gender,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(),
                                ),
                                items: items1.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged:isEnabled?(String? newValue){
                                  setState(() {
                                    gender=newValue!;
                                  });
                                }:null
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              enabled:isEnabled,
                              controller: _addresscontroller,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.fingerprint),
                                //labelText: 'Email',
                                hintText: 'Address',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value){
                                address=value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField<String>(
                                value: usercategory,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(),
                                ),
                                items: items2.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: /*isEnabled?(String? newValue){
                                  setState(() {
                                    usercategory=newValue!;
                                  });
                                }:*/null
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if(usercategory==items2[1])
                              TextFormField(
                                enabled: isEnabled,
                                controller: _collegecontroller,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.short_text),
                                  //labelText: 'Email',
                                  hintText: 'College Name',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value){
                                  collegename=value;
                                },
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if(usercategory==items2[1])
                              TextFormField(
                                enabled: isEnabled,
                                controller: _departmentcontroller,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.book),
                                  //labelText: 'Email',
                                  hintText: 'Department',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value){
                                  department=value;
                                },
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if(usercategory==items2[1])
                              DropdownButtonFormField(
                                  value: studentyear,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(),
                                  ),
                                  items: items3.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged:isEnabled? (String? newValue){
                                    setState(() {
                                      studentyear=newValue!;
                                    });
                                  }:null
                              ),
                            if(usercategory==items2[2])
                              DropdownButtonFormField(
                                  value: experiencelevel,
                                  /*validator: (value) {
                                    if (value == null || value=="Select Experience Level") {
                                      return 'Please select Experience';
                                    }
                                    return null;
                                  },*/
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(),
                                  ),
                                  items: items4.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: isEnabled?(String? newValue){
                                    setState(() {
                                      experiencelevel=newValue!;
                                    });
                                  }:null
                              ),
                            SizedBox(
                              height: 10,
                            ),
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
                              child: Text(isEnabled?'UPDATE':'EDIT NOW'),
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
                                if(!isEnabled){
                                    setState(() {
                                      isEnabled=true;
                                    });
                                }else{
                                  if (_formkey.currentState!.validate()) {
                                    var url = 'https://techdemy.in/connect/api/updateprofile';
                                    final Map<String,String> data = {"user_id":widget.results["appuser_id"],
                                      "name":name,"gender":gender,"address":address,"email":email,"phone_no":mobile,"user_category":usercategory,"college_name":collegename,
                                    "department":department,"year":studentyear,"exp_level":experiencelevel
                                    };
                                    print("profile testing data"+data.toString());
                                    /*  setState(()
        {
          vaue.text=json.encode({"data":encryption(json.encode(data))}).toString();
        });*/
                                    Map<String,String> dat={"data":encryption(json.encode(data))};
                                    print("testing data"+dat.toString());
                                    try{
                                      final response = await http.post(Uri.parse(url),
                                          body: json.encode(dat),
                                          headers:{
                                            "CONTENT-TYPE":"application/json"
                                          }).timeout(const Duration(seconds: 20));/*setState(() {
    vaue.text=decryption(response.body.toString().trim()).split("}")[0]+"}hai";
    });*/
                                      print(response.statusCode.toString()+"bfbfb");
                                      if (response.statusCode == 200) {
                                        Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;
                                        print(result.toString()+"bfbfb");

                                        /* final Map<String,dynamic> result = {
    "message":"success","user_id":"1"};*/
                                        if(result["status"]=="success"){
                                          SharedPreferences sp=await SharedPreferences.getInstance();
                                          sp.setInt("user_id",int.parse(widget.results["appuser_id"]));
                                          sp.setString("email",email);
                                          // if(result["message"]=="Registered Successfully"){
                                          setState((){
                                            successtxt=result["message"];
                                            errtxt="";
                                            isEnabled=false;

                                          });

                                        } else
                                        if(result["status"]=="not_verified"){

                                          setState((){
                                            errtxt= result["message"];
                                            successtxt="";

                                          });
                                        }else{
                                          setState((){
                                            successtxt="";
                                            errtxt=="Please Check your Internet Connection And data - 3"+result["status"];
                                          });
                                        }
                                      }else{
                                        setState((){
                                          successtxt="";
                                          errtxt=="Please Check your Internet Connection And data - 4"+response.statusCode.toString();
                                        });
                                      }
                                    }on TimeoutException catch (_) {
                                      setState((){
                                        successtxt="";
                                        errtxt="Please Check your Internet Connection And data - 5";
                                      });
                                      //return false;
                                    }on Exception catch(e){
                                      setState((){
                                        errtxt=e.toString();
                                        successtxt="";

                                      });

                                    }

                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
