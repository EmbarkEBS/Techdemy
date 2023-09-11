

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:learningapp_flutter/Screens/coursedetails_page.dart';
import 'package:learningapp_flutter/Screens/myprofile_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../Helpers/encrypter.dart';
import '../Models/courseslist_model.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title,  }) : super(key: key);
  // final CourseListResponse rresponse;
  //final List<CoursesList> course;
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  String url = "https://fluttercampus.com/sample.pdf";
   List<CourseList> searchedData = <CourseList>[];
   List<CourseList> coursedata = <CourseList>[];
   final duplicateItems=List<CourseList>;
   var items=<String>[];
   TextEditingController controller = new TextEditingController();
  List<String> categories = ['All', 'PHP', 'JAVA', 'DBMS', 'MYSQL'];
  //List<CoursesList> filtercourses=[CoursesList(course_id: filtercourses['course_id'], name: name, description: description, price: price, duration: duration, image: image, tag_data: tag_data)];
  // Define a variable to store the selected category
  String selectedCategory = 'All';
  String successtxt="",errtxt="";
  final _random = Random();
  bool  _isLoading=true;
  //CoursesList? courselist;
  int progress = 0;


  ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort?.send([id, status, progress]);
  }
  @override
  void initState(){
    super.initState();
    getCoursesList();
    //fetchFilterOptions();
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "downloading");


    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });

      print(progress);
    });


    FlutterDownloader.registerCallback(downloadingCallback);
  }
  void _downloadFile()async{
    final status=await Permission.storage.request();
    if(status.isGranted){
      final baseStorage= await getExternalStorageDirectory();
      final id=await FlutterDownloader.enqueue(
          url: url,
          savedDir: baseStorage!.path,
        fileName: 'filename'
      );
    }else{
      print('no permission');
    }
  }

  /*Future<List<CourseList>> getCoursesList() async {
    List<CourseList> list=[];
    //list=[];
    String link =
        "https://techdemy.in/connect/api/courselist";
    var res = await http
        .get(Uri.parse(link), headers: {"Accept": "application/json"});
    debugPrint(res.body.toString(), wrapWidth: 1024);

    /* var encryptedData=res.body.toString();
    var decryptedData=decryption(encryptedData);
    debugPrint("decrypted"+decryptedData.toString(),wrapWidth: 1024);
    var encodedData=jsonEncode(decryptedData);
    debugPrint("encodeddata"+encodedData.toString(),wrapWidth: 1024);
    var decodedData=encodedData.replaceAll(RegExp(r'\\u([0-9A-Fa-f]{4})'), '') ;

    var sampleData=jsonEncode(decryption(res.body.toString())).trim().replaceAll(RegExp(r'\\u([0-9A-Fa-f]{4})'), '');
    debugPrint("decodedData"+jsonDecode(sampleData.toString()),wrapWidth: 1024);
    var sData = jsonDecode(sampleData.replaceAll(RegExp(r'"'), '').toString());
    Map<String, dynamic> jsonresponse= sData  as Map<String, dynamic>;
    debugPrint("decodedData"+jsonresponse.toString(),wrapWidth: 1024);*/
    print(res.statusCode);
    if (res.statusCode == 200) {
      var data = json.decode(res.body.toString());
      var rest = data["results"] as List;
      print(rest);
      list = rest.map<CourseList>((json) => CourseList.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }*/
  Future<List<CourseList>> getCoursesList()async{
    var url='https://techdemy.in/connect/api/courselist';
    var response=await http.get(Uri.parse(url),headers: {
      "Accept": "application/json",
      "Content-Type": "application/json; charset=utf-8"
    },);

    /*var decData =response.body.toString();
    var sample= decryption(decData);
    var jsondata = jsonEncode(sample.toString());
    var decodeData = jsondata.replaceAll(RegExp(r'\\u([0-9A-Fa-f]{4})'), '');
    debugPrint("debugprint: "+jsondata.toString(), wrapWidth: 1024);
    debugPrint("sample string: "+jsonDecode(decodeData.toString()),wrapWidth: 1024);*/
    // Map<String,dynamic> result=jsonDecode(decryption(response.body.toString()).trim().split("}")[0]+"}") as Map<String,dynamic>;
    //Map<String,dynamic> decrypt=decryption(response.body.toString()) as Map<String,dynamic> ;
    //debugPrint("decryption:"+decrypt.toString(),wrapWidth: 1024);<

    /* var decrypt = decryption(response.body.toString());
    Uint8List bytes = utf8.encode(decrypt) as Uint8List;
    debugPrint("Bytes:"+bytes.toString(),wrapWidth: 1024);
    String s = utf8.decode(decrypt.toList());
    debugPrint("s:"+s.toString(),wrapWidth: 1024);
    final jsonData = jsonDecode(s);
    debugPrint("sampleresponse"+jsonData.toString(),wrapWidth: 1024);
    */

    // var jsondecodes=json.decode(decryption(utfDecode.toString()));
    // debugPrint("jsondecode:"+jsondecodes.toString(), wrapWidth: 1024);


    /*var array =jsonEncode(decryption(response.body.toString()));
    var jsondata=array.toString();
    debugPrint("test string"+array.toString(), wrapWidth: 1024);*/

    // String a=decryption(response.body.toString().trim()).split("}").length>2?decryption(response.body.toString().trim()).split("}")[0]+"}}":decryption(response.body.toString().trim()).split("}")[0]+"}";
    //Map<String,dynamic> result=jsonDecode(a) as Map<String,dynamic>;
    //var jsonData=json.decode('{"status":"success","results":[{"course_id":1,"name":"PHP","description":"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since a type setting","price":"1500","duration":"3 Months","image":"https:\/\/techdemy.in\/connect\/public\/images\/course\/1690206125.png","tag_data":[{"tag_name":"HTML"},{"tag_name":"CSS"}]},{"course_id":2,"name":"JAVA","description":"JAVA","price":"1200","duration":"4 Months","image":"https:\/\/techdemy.in\/connect\/public\/images\/course\/1690206187.png","tag_data":[{"tag_name":"OOPS Concept"}]}]}');
    //print("result"+result.toString());
    //if(response.statusCode==200) {
    //var jsonData=jsonDecode('{"results": [{"course_id": 1,"name": "PHP","description": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry","price": "1500","duration": "3 Months","image": "https://techdemy.in/connect/public/images/course/1690206125.png","tag_data": "HTML-CSS"},{"course_id": 2,"name": "JAVA","description": "Embark on your programming journey with our comprehensive Free Java Course for Beginners. Master the fundamentals of Java and gain the skills needed for advanced Java development","price": "1200","duration": "4 Months","image": "https://techdemy.in/connect/public/images/course/1690206187.png","tag_data": "OOPS Concept"}]}');
    //print("decryption:"+decryption(response.body.toString().trim().split("}")[0]+"}]}"));
    /*var encryptedData=response.body.toString();
    var decryptedData=decryption(encryptedData);
    var encodedData=jsonEncode(decryptedData);
    var decodedData=encodedData.replaceAll(RegExp(r'\\u([0-9A-Fa-f]{4})'), '') ;
   var sampleData=jsonEncode(decryption(response.body.toString())).trim().replaceAll(RegExp(r'\\u([0-9A-Fa-f]{4})'), '');
    debugPrint("decodedData"+jsonDecode(sampleData.toString()),wrapWidth: 1024);
    var sData = jsonDecode(sampleData.replaceAll(RegExp(r'"'), '').toString());
    Map<String, dynamic> jsonresponse= sData  as Map<String, dynamic>;
    debugPrint("decodedData"+jsonresponse.toString(),wrapWidth: 1024);*/
    // Map<String, dynamic> coursedata=jsonDecode(jsonEncode(decryption(response.body.toString())).trim().replaceAll(RegExp(r'\u0010'), '')) as Map<String, dynamic>;
    // debugPrint("hellooee"+jsonEncode(coursedata));
    // debugPrint("jsondata"+coursedata.toString(),wrapWidth: 1024);

    //var dataaa={'x9ukd8vmtK+8wfbOaXv2GkKX0lOFHE3IvD2+Mh3fcGRoz7/VgQ35Hlb+KF6irP15900ltRq0oz78Aq3kUDQBLibygvAu1zdLYEPxUBiygWihSCqon49Hm4ouqhEGEuMyDJXek7IUVMKE9XSRC1SM85izbx119SPPbcFeDOI9h4kZNn5+Bv7D5haAJirrRjSCX9GZgTZ8zHJ3b3+A9va1vWGGgO42iokSEYMPpH6YE+neu5ljj1oEm7YRDgMt4Ryn3oHdHVE7fZv3MtGQGTjszSWLucpU5V98MWqHwdKt5YyxJpdwiuiKBz5puzAuUc9pggh7Ym5sW5YKqe2clGcxyuexlOUDFehmKgLJ3eyJParTPsI4c80RpoI3eP8Jz3JEvbnH12x2PhiWgbLY2QZMr3I4eVjzpgYD7VblLTGpFFWldkTo3dWFnlZSn+5Dwxy67miD+ahqPBftTbMUyiMFgOQY8RlReZD7o3UZjRFo6lHB4osN4ZVkVnNqf+GeCXCbGLtHwQepupa3nJ0FO0/xduwLJAQ+Vvu7NBhweBlGap8GHwDRxqmdOYyfhZaGNO4Wq4gi05srF4QYnKDKGiEo6flwGYkaUXvcbVPyQdaKyMzkBP+rtvkOr8VGVFWacRPckeXgU+vyqgx1HdajtU5tLKahpnFvDfR8a9Fgp30QIPqWLs0I25s6FQWbuuvfsRHmBzvbUJUblA63iYSomwANbG742rOik+drvL9L/3PliRhsl7utMrYz0oEqkVsK2T8btpwvOiJTM+nshFPM1O3Qf+xv2ERgr6HQd9LuviAKlJ4O2L6bPEtA7eKi7tq5mAiXkg5mC7QFKY9h9YZd8wOvefFE0fLA7tsWFnOk4rPYmHolIYLf9ijCZMt+WEa73VnHVgro3weTPYVqCyTU0r1S611Q68xOQCkcMHYCySonxR+JiJyw+eIccMZUlmUk+T2OUwz4WZblv4c6D7pXCGyULK6kb5dD44uiYr4fDOMJYikGLYDNcEnaE4LsRS'};

    //Map<String, dynamic> jsonData = json.decode(decryption(response.body.toString()).trim().replaceAll(RegExp(r'\u0010'), '')) as Map<String, dynamic>;
    // debugPrint("jsondataaaaa:"+jsonData.toString(),wrapWidth: 1024);
    // Map<String, dynamic> jsonData = json.decode(decodedData.toString()) as Map<String, dynamic>;
    //debugPrint("datahkjdf"+jsondata.toString(), wrapWidth: 1024);
    //var jsondecode =jsonDecode(jsonData);
    Map<String,dynamic> jsonData=jsonDecode(response.body.toString()) as Map<String,dynamic>;
    debugPrint("jsondata" + jsonData.toString(),wrapWidth: 1024);

    // Iterable jsonResponse = jsonDecode(response.body);
    // List<CoursesList> listHashtagTop =
    // jsonResponse.map((model) => CoursesList.fromJson(model)).toList();
    //
    // return listHashtagTop;

    if(response.statusCode==200){
      var jsonArray = jsonData['results'];
      //var tagArray=jsonData['tag_data'];
      //print("tagarray:"+tagArray.toString());
      debugPrint("array"+jsonArray.toString(), wrapWidth: 1024);

      List<CourseList> courses = [];
      //List<TagData> tag=[];

      for (var courselist in jsonArray) {
        CourseList cList = CourseList(
          course_id: courselist['course_id'] ,
          name: courselist['name'],
          description: courselist['description'],
          price: courselist['price'],
          duration: courselist['duration'],
          image: courselist['image'],
          tag_data: courselist['tag_data'],
        );
        /*for(var tags in courselist['tag_data']){
          TagData taglist=TagData(tag_name:tags['tag_name']);
          tag.add(taglist);
          print("Tag Array"+tags.toString());
        }*/
        courses.add(cList);

      }
      return courses;
    }else{
      var jsonArray = [];
      return [];
    }



    //}else{
    print('failed');
    return [];
    //}
  }
  /*Future<void> downloadFile(String url, String filename) async {
    //final directory=await getExternalStorageDirectory();
    //print('${directory?.path}/Download');
    //final savedDir = '${directory?.path}/Download';
    //print('${directory?.path}/Download');
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: '/storage/emulated/0/Download', // Set the directory where the file will be saved
      fileName: filename,
      showNotification: true, // Show a download notification
      openFileFromNotification: true, // Open the downloaded file after downloading
    );
  }*/

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    /*List<Product> filteredProducts =
   products.where((product) => product.category == selectedCategory).toList();*/
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text('Home Page'),backgroundColor: Colors.black,),
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
                    SharedPreferences sp=await SharedPreferences.getInstance();

                    var url = 'https://techdemy.in/connect/api/userprofile';
                    final Map<String,String> data = {"user_id":sp.getInt("user_id").toString()};
                    print("testing data"+data.toString());
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
                      print("status code:"+response.statusCode.toString());
                      if (response.statusCode == 200) {

                        String a=decryption(response.body.toString().trim()).split("}").length>2?decryption(response.body.toString().trim()).split("}")[0]+"}}":decryption(response.body.toString().trim()).split("}")[0]+"}";
                        print("profile reposnse:"+a.toString());
                        Map<String,dynamic> result=jsonDecode(a) as Map<String,dynamic>;

                        // Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}}") as Map<String,dynamic>;
                        if(result["status"]=="success")

                          Navigator.push(context, MaterialPageRoute( builder: (BuildContext context)=>MyProfilePage(result["results"])));
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));
                      }else{
                        Navigator.of(context).pop();
                        setState((){
                          successtxt="";
                          errtxt=response.statusCode.toString()+" :Please Check your Internet Connection And data - 1";
                        });
                      }
                    }on TimeoutException catch(e) {
                      Navigator.of(context).pop();
                      setState((){
                        errtxt="Please Check your Internet Connection And data - 2";
                        successtxt="";

                      });

                    }on Exception catch(e){
                      print("Exception:"+e.toString());
                    }
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
          body: Container(
            // child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
               /* Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          //labelText: 'Email',
                          hintText: 'Search',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),

                ),*/
                //SizedBox(height: 20,),
                /*SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:Row(
                    /*children: [
                      for(String name in Set.from(allCourses.map((course) =>course.name )))
                        FilterChip(
                            label: Text(name),
                             selected: selectedCourseNames.contains(name),
                            onSelected: (isSelected) {
                              toggleCourseName(name);
                            },
                        )
                    ],*/
                    children: categories.map((category) {
                      SizedBox(width: 10,);
                      return FilterChip(
                        label: Text(category),
                        labelPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        selectedColor: Colors.yellow,
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        selected: selectedCategory == category,
                        onSelected: (isSelected) {
                          setState(() {
                            selectedCategory = isSelected ? category : 'All';
                          });
                        },
                        visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                      );
                    }).toList(),
                  ),
                ),*/
                /*ElevatedButton(
                  onPressed: () async{
                    // final url = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'; // Replace with your file URL
                    // final filename = 'certificate'; // Provide a suitable file name
                    // await download(url, filename);
                    final status=await Permission.storage.request();
                    if(status.isGranted){
                      final baseStorage= await getApplicationDocumentsDirectory();
                      final id=await FlutterDownloader.enqueue(
                        url: url,
                        savedDir: baseStorage.path,
                        fileName: 'filename',
                        showNotification: true,
                        openFileFromNotification: true,
                      );
                    }else{
                      print('no permission');
                    }
                  },
                  child: Text('Download File'),
                ),
                SizedBox(height: 20,),*/

                Expanded(
                    child: FutureBuilder<List<CourseList>>(
                      future: getCoursesList(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          List<CourseList> courses=snapshot.data!;

                          return ListView.builder(
                              itemCount: courses.length,
                              itemBuilder: (context, index){
                                CourseList courselist=courses[index];
                              if(selectedCategory=='All'||selectedCategory==courselist.name) {
                                return Card(
                                  //elevation: 10.0,
                                  //shadowColor: Colors.grey.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  child: ListTile(
                                    onTap: () =>
                                        _onTapItem(context, courses[index]),
                                    /*onTap: ()async{
                                      // Navigator.pushNamed(context, '/coursedetails');
                                      var url='https://techdemy.in/connect/api/coursedetail';
                                      // var response=await http.get(Uri.parse(url),headers: {
                                      //   "Accept": "application/json",
                                      //   'Content-Type': 'application/json; charset=utf-8'
                                      // },);
                                      // var array =jsonEncode(decryption(response.body.toString()));
                                      // var jsondata=array.toString();
                                      // print("my course api:"+jsondata.toString(), );
                                      final Map<String,String> data = {"course_id": courselist.course_id.toString(),};
                                      print("testing data"+data.toString());
                                      try{
                                        final response=await http.post(Uri.parse(url),
                                            body:json.encode({"data":encryption(json.encode(data))}),
                                            encoding:Encoding.getByName('utf-8'),
                                            headers:{
                                              "Accept": "application/json",
                                              'Content-Type': 'application/json; charset=utf-8'
                                            }).timeout(Duration(seconds: 20));
                                        Map<String,String> dat={"data":encryption(json.encode(data))};
                                        print("testing data"+dat.toString());
                                        print("testing data"+response.statusCode.toString());
                                        //print(response.body.toString());
                                        var array =jsonEncode(response.body.toString());
                                        var jsondata=array.toString();
                                        debugPrint("my course api:"+jsondata.toString(), wrapWidth: 1024);
                                        if (response.statusCode == 200) {
                                          print("hi");

                                          //Map<String,dynamic> result=json.decode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;
                                          Map<String,dynamic> result=json.decode(response.body.toString()) as Map<String,dynamic>;

                                          debugPrint("result"+result.toString(),wrapWidth: 1024);

                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CourseDetails(coursedetail[index], title)));
                                          Navigator.pushNamed(context, "/coursedetails",);
                                        } else {
                                          setState((){
                                            print('please check data-1');
                                          });
                                        }
                                      }on TimeoutException catch (e) {
                                        print("$e");

                                      }on Exception catch(e){
                                        debugPrint("Exception:"+e.toString(),wrapWidth: 1024);
                                        //print("error parsing json"+response.body.toString());
                                      }
                                    },*/
                                    leading: Container(
                                      alignment: Alignment.center,
                                      height: 100,
                                      width: 60,
                                      // child: Image.asset("assets/images/Techdemy_logo1.png"),
                                      child: Image.network(
                                        '${courselist.image}',),
                                    ),
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        SizedBox(height: 12,),
                                        Text(courselist.name, style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),),
                                        SizedBox(height: 10,),
                                        Text(courselist.duration),
                                        SizedBox(height: 10,),
                                        Text(
                                          courselist.description, maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(fontSize: 12,
                                            fontWeight: FontWeight.w600,),),
                                        SizedBox(height: 10,),
                                        ElevatedButton(
                                          onPressed: () async {
                                            var url = 'https://techdemy.in/connect/api/userenrollment';
                                            /*var response=await http.get(Uri.parse(url),headers: {
                                                  "Accept": "application/json",
                                                  'Content-Type': 'application/json; charset=utf-8'
                                                },);*/
                                            SharedPreferences sp = await SharedPreferences
                                                .getInstance();
                                            final Map<String, String> data = {
                                              "user_id": sp.getInt("user_id")
                                                  .toString(),
                                              "course_id": courselist.course_id
                                                  .toString(),
                                            };
                                            print("testing data" +
                                                data.toString());
                                            try {
                                              final response = await http.post(
                                                  Uri.parse(url),
                                                  body: json.encode({
                                                    "data": encryption(
                                                        json.encode(data))
                                                  }),
                                                  encoding: Encoding.getByName(
                                                      'utf-8'),
                                                  headers: {
                                                    "CONTENT-TYPE": "application/json"
                                                  }).timeout(
                                                  Duration(seconds: 20));
                                              Map<String, String> dat = {
                                                "data": encryption(
                                                    json.encode(data))
                                              };
                                              print("testing data" +
                                                  dat.toString());
                                              print("testing data" +
                                                  response.statusCode
                                                      .toString());
                                              if (response.statusCode == 200) {
                                                Map<String,
                                                    dynamic> result = jsonDecode(
                                                    decryption(
                                                        response.body.toString()
                                                            .trim()).split(
                                                        "}")[0] + "}") as Map<
                                                    String,
                                                    dynamic>;
                                                print("result" +
                                                    result.toString());
                                                Navigator.pushNamed(
                                                  context, "/mycourses",);
                                              } else {
                                                setState(() {
                                                  print('please check data-1');
                                                });
                                              }
                                            } on TimeoutException catch (_) {
                                              setState(() {
                                                print('please check data-2');
                                              });
                                            } on Exception catch (e) {
                                              setState(() {
                                                print('please check data-3');
                                              });
                                            }
                                          },
                                          child: Text(
                                            'Start Now', style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.yellow,
                                              fontWeight: FontWeight.bold),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black87,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(5),
                                                  side: BorderSide(
                                                      color: Colors.black)
                                              ),
                                              minimumSize: Size(
                                                  double.infinity, 40)
                                          ),
                                        ),
                                        SizedBox(height: 10,),
                                        //Text(snapshot.data![index].description.toString(),style: TextStyle(fontSize: 16),),
                                        //Text(snapshot.data![index], style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal),),
                                      ],
                                    ),
                                    subtitle: Container(
                                        child: Wrap(
                                          children: [
                                            for(var tag in courselist.tag_data
                                                .toString().trim().split(
                                                "-"))...[
                                              /* Container(
                                                child: Text("$tag")
                                            ),*/
                                              Chip(
                                                label: Text("$tag",
                                                  style: TextStyle(fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight
                                                          .bold),),
                                                shadowColor: Colors.black54,
                                                backgroundColor: Color.fromRGBO(_random.nextInt(256),
                                                    _random.nextInt(256),
                                                    _random.nextInt(256),
                                                    _random.nextDouble()),
                                                //elevation: 10,
                                                autofocus: true,
                                                visualDensity: VisualDensity(
                                                    horizontal: -4,
                                                    vertical: -4),
                                              )
                                            ],
                                            /* Chip(
                                            label: Text(courselist.tag_data[0]['tag_name'],style: TextStyle(fontSize: 10,color: Colors.blueGrey,fontWeight: FontWeight.bold),),
                                            shadowColor: Colors.black54,
                                            backgroundColor: Colors.grey[100],
                                              //elevation: 10,
                                              autofocus: true,
                                            visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                                          ),*/
                                            SizedBox(width: 5,),
                                            /*Chip(
                                            label: Text("CSS",style: TextStyle(fontSize: 10,color: Colors.orange[900],fontWeight: FontWeight.bold),),
                                            shadowColor: Colors.black54,
                                            backgroundColor: Colors.greenAccent[100],
                                            //elevation: 10,
                                            autofocus: true,
                                            visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                                          )*/

                                          ],
                                        )
                                    ),
                                    /* trailing: Column(
                                      children: [
                                        Text(courselist.duration.toString()),

                                      ],
                                    ),*/
                                  ),
                                );
                              }else{
                                return SizedBox.shrink();
                              }
                              }
                          );
                        }else if(snapshot.hasError){
                          return Text('${snapshot.error}');
                        }
                        return Center(child: CircularProgressIndicator(),);
                      },
                    )
                ),
                /*Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (selectedCategory == 'All' || selectedCategory == products[index].category) {
                          return Card(
                            elevation: 10.0,
                            shadowColor: Colors.grey.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height: height/4,
                              //width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: Container(
                                  alignment: Alignment.center,
                                  height: 100,
                                  width: 50,
                                  child: Image.asset("assets/images/Techdemy_logo1.png"),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(products[index].category,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                    Text(products[index].name,style: TextStyle(fontSize: 16),),
                                    Text(products[index].description, style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal),),
                                  ],
                                ),
                                /*subtitle:Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(products[index].description),
                                  ],
                                ),*/
                               trailing: Column(
                                 children: [
                                   Text("17 courses")
                                 ],
                               ),
                               // subtitle: Text(products[index].description),

                              )
                            )
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),*/
                /*SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(12),
                    child:Row(
                     // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: courses.map((category) => ChoiceChip(
                        label: Text(category),
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        selected: selectedCategory == category,
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              selectedCategory = category;
                            } else {
                              selectedCategory = '';
                            }
                          });
                        },
                      )
                      )
                          .toList(),
                    ),
                  ),*/
                /* Expanded(
                    child: ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        Product product = filteredProducts[index];
                        return ListTile(
                          title: Text(product.name),
                          subtitle: Text('${product.category} - \$${product.price}'),
                        );
                      },
                    ),
                  ),*/
              ],
            ),
            //  ),
          ),
        )
    );
  }
  void _onTapItem(BuildContext context, CourseList courseList) async{
    // Navigator.pushNamed(context, '/coursedetails');
    var url='https://techdemy.in/connect/api/coursedetail';
    // var response=await http.get(Uri.parse(url),headers: {
    //   "Accept": "application/json",
    //   'Content-Type': 'application/json; charset=utf-8'
    // },);
    // var array =jsonEncode(decryption(response.body.toString()));
    // var jsondata=array.toString();
    // print("my course api:"+jsondata.toString(), );
    SharedPreferences sp=await SharedPreferences.getInstance();
    sp.setInt("course_id", courseList.course_id);
    final Map<String,String> data = {"course_id": sp.getInt("course_id").toString()};
    print("testing data"+data.toString());
    try{
      final response=await http.post(Uri.parse(url),
          body:json.encode({"data":encryption(json.encode(data))}),
          encoding:Encoding.getByName('utf-8'),
          headers:{
            "Accept": "application/json",
            'Content-Type': 'application/json; charset=utf-8'
          }).timeout(Duration(seconds: 20));
      Map<String,String> dat={"data":encryption(json.encode(data))};
      print("testing data"+dat.toString());
      print("testing data"+response.statusCode.toString());
      //print(response.body.toString());
      var array =jsonEncode(response.body.toString());
      var jsondata=array.toString();
      debugPrint("my course api:"+jsondata.toString(), wrapWidth: 1024);
      if (response.statusCode == 200) {
        print("hi");

        //Map<String,dynamic> result=json.decode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;
        Map<String,dynamic> result=json.decode(response.body.toString()) as Map<String,dynamic>;

        debugPrint("result"+result.toString(),wrapWidth: 1024);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => CourseDetails(courseList, widget.title)));
      } else {
        setState((){
          print('please check data-1');
        });
      }
    }on TimeoutException catch (e) {
      print("$e");

    }on Exception catch(e){
      debugPrint("Exception:"+e.toString(),wrapWidth: 1024);
      //print("error parsing json"+response.body.toString());
    }
    
  }
}
