// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tech/Screens/coursedetails_page.dart';
import 'package:tech/Screens/myprofile_page.dart';

import '../Helpers/encrypter.dart';
import '../Models/courselist_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
  });
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
  final duplicateItems = List<CourseList>;
  var items = <String>[];
  TextEditingController controller = TextEditingController();
  List<String> categories = ['All', 'PHP', 'JAVA', 'DBMS', 'MYSQL'];
  //List<CoursesList> filtercourses=[CoursesList(course_id: filtercourses['course_id'], name: name, description: description, price: price, duration: duration, image: image, tag_data: tag_data)];
  // Define a variable to store the selected category
  String selectedCategory = 'All';
  String successtxt = "", errtxt = "";
  final _random = Random();
  //CoursesList? courselist;
  int progress = 0;

  final ReceivePort _receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort?.send([id, status, progress]);
  }

  @override
  void initState() {
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

  // ignore: unused_element
  void _downloadFile() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      // ignore: unused_local_variable
      final id = await FlutterDownloader.enqueue(url: url, savedDir: baseStorage!.path, fileName: 'filename');
    } else {
      print('no permission');
    }
  }

  Future<List<CourseList>> getCoursesList() async {
    var url = 'https://techdemy.in/connect/api/courselist';
    var response = await http.get(
      Uri.parse(url),
      // headers: {
      //   "Accept": "application/json",
      //   "Content-Type": "application/json; charset=utf-8"
      // },
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      // String decrptedData = decryption(response.body);
      String decrptedData = decryption(response.body);
      print('Course list Body: $decrptedData');
      Map<String, dynamic> jsonData = json.decode(decrptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F ]'), ''));
      debugPrint('Result: ${jsonData['results']}', wrapWidth: 1024);
      // var jsonArray = jsonData['results'];
      // print(jsonArray);

      // debugPrint("array $jsonArray", wrapWidth: 1024);

      List<CourseList> courses = [];
      //List<TagData> tag=[];

      for (var courselist in jsonData['results']) {
        courses.add(CourseList.fromJson(courselist));
      }
      return courses;
    } else {
      return [];
    }

    //}else{
    // print('failed');
    // return [];
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        // backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
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
              onTap: () async {
                SharedPreferences sp = await SharedPreferences.getInstance();

                var url = 'https://techdemy.in/connect/api/userprofile';
                final Map<String, String> data = {
                  "user_id": sp.getInt("user_id").toString()
                };
                print("testing data" + data.toString());
                /*  setState(()
                {
                  vaue.text=json.encode({"data":encryption(json.encode(data))}).toString();
                });*/
                Map<String, String> dat = {
                  "data": encryption(json.encode(data))
                };
                print("testing data$dat");
                try {
                  final response = await http.post(Uri.parse(url),
                      body: json.encode(dat),
                      headers: {
                        "CONTENT-TYPE": "application/json"
                      }).timeout(const Duration(seconds:20)); /*setState(() {
                    vaue.text=decryption(response.body.toString().trim()).split("}")[0]+"}hai";
                    });*/
                  print("status code:" + response.statusCode.toString());
                  if (response.statusCode == 200) {
                    String a = decryption(response.body.toString().trim()).split("}").length > 2
                        ? decryption(response.body.toString().trim()).split("}")[0] +"}}"
                        : decryption(response.body.toString().trim()).split("}")[0] +"}";
                    print("profile reposnse:" + a.toString());
                    Map<String, dynamic> result = jsonDecode(a) as Map<String, dynamic>;

                    // Map<String,dynamic> result=jsonDecode(decryption(response.body.toString().trim()).split("}")[0]+"}}") as Map<String,dynamic>;
                    if (result["status"] == "success") {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyProfilePage(result["results"])));
                    }
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));
                  } else {
                    Navigator.of(context).pop();
                    setState(() {
                      successtxt = "";
                      errtxt = response.statusCode.toString() + " :Please Check your Internet Connection And data - 1";
                    });
                  }
                  // ignore: unused_catch_clause
                } on TimeoutException catch (e) {
                  Navigator.of(context).pop();
                  setState(() {
                    errtxt = "Please Check your Internet Connection And data - 2";
                    successtxt = "";
                  });
                } on Exception catch (e) {
                  print("Exception:$e");
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.menu_book_sharp,
              ),
              title: const Text('My Courses'),
              onTap: () async {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/mycourses");
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text('Logout'),
              onTap: () async {
                //Navigator.pushNamed(context, "/mycourses");
                SharedPreferences sp = await SharedPreferences.getInstance();
                //sp.setBool("stay_signed",false);
                print("before${sp.getInt("user_id")}");
                sp.setInt("user_id", 0);
                //sp.clear();
                print("after" + sp.getInt("user_id").toString());
                Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<CourseList>>(
                future: getCoursesList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<CourseList> courses = snapshot.data!;
                    return ListView.builder(
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          CourseList courselist = courses[index];
                          if (selectedCategory == 'All' ||
                              selectedCategory == courselist.name) {
                            return Card(
                              //elevation: 10.0,
                              //shadowColor: Colors.grey.withOpacity(0.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                              child: ListTile(
                                onTap: () => _onTapItem(context, courses[index]),
                                leading: Container(
                                  alignment: Alignment.center,
                                  height: 100,
                                  width: 60,
                                  child: Image.network(
                                    courselist.image,
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 12,),
                                    Text(
                                      courselist.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Text(courselist.duration),
                                    const SizedBox(height: 10,),
                                    Text(
                                      courselist.description,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    ElevatedButton(
                                      onPressed: () async {
                                        var url = 'https://techdemy.in/connect/api/userenrollment';
                                        SharedPreferences sp = await SharedPreferences.getInstance();
                                        final Map<String, String> data = {
                                          "user_id": sp.getInt("user_id").toString(),
                                          "course_id": courselist.course_id.toString(),
                                        };
                                        print("testing data$data");
                                        try {
                                          final response = await http.post(
                                            Uri.parse(url),
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
                                          print("testing data$dat");
                                          print("testing data${response.statusCode}");
                                          if (response.statusCode == 200) {
                                            Map<String, dynamic> result = jsonDecode(decryption(response.body.toString().trim()).split("}")[0] +"}") as Map<String, dynamic>;
                                            print("result$result");
                                            Navigator.pushNamed(
                                              context,
                                              "/mycourses",
                                            );
                                          } else {
                                            setState(() {
                                              print('please check data-1');
                                            });
                                          }
                                        } on TimeoutException catch (_) {
                                          setState(() {
                                            print('please check data-2');
                                          });
                                          // ignore: unused_catch_clause
                                        } on Exception catch (e) {
                                          setState(() {
                                            print('please check data-3');
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black87,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          side: const BorderSide(color: Colors.black)
                                        ),
                                        minimumSize: const Size(double.infinity, 40)
                                      ),
                                      child: const Text(
                                        'Start Now',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.yellow,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    //Text(snapshot.data![index].description.toString(),style: TextStyle(fontSize: 16),),
                                    //Text(snapshot.data![index], style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal),),
                                  ],
                                ),
                                subtitle: courselist.tag_data.isEmpty
                                ? const SizedBox()
                                : Wrap(
                                  spacing: 5.0,
                                  children: [
                                    for (var tag in courselist.tag_data.toString().trim().split("-")) 
                                      ...[
                                      /* Container(
                                          child: Text("$tag")
                                      ),*/
                                      Chip(
                                        label: Text(
                                          tag,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        shadowColor: Colors.black54,
                                        backgroundColor: Color.fromRGBO(
                                          _random.nextInt(256),
                                          _random.nextInt(256),
                                          _random.nextInt(256),
                                          _random.nextDouble()
                                        ),
                                        //elevation: 10,
                                        autofocus: true,
                                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                      )
                                    ],
                                    const SizedBox(width: 5,),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        });
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ),
          ],
        ),
      ),
    );
  }

  void _onTapItem(BuildContext context, CourseList courseList) async {
    var url = 'https://techdemy.in/connect/api/coursedetail';

    SharedPreferences sp = await SharedPreferences.getInstance();
    print(courseList.course_id);
    sp.setInt("course_id", courseList.course_id);
    final Map<String, String> data = {
      "course_id": sp.getInt("course_id").toString()
    };
    print("testing data $data");
    try {
      final response = await http.post(Uri.parse(url),
        body: json.encode({"data": encryption(json.encode(data))}),
        encoding: Encoding.getByName('utf-8'),
        headers: {
          "Accept": "application/json",
          'Content-Type': 'application/json; charset=utf-8'
        }).timeout(const Duration(seconds: 20));
      Map<String, String> dat = {"data": encryption(json.encode(data))};
      print("testing data $dat");
      print("testing data ${response.statusCode}");
      //print(response.body.toString());
      var array = jsonEncode(response.body.toString());
      var jsondata = array.toString();
      debugPrint("my course api: $jsondata", wrapWidth: 1024);
      if (response.statusCode == 200) {
        print("hi");
        String decryptedData = decryption(response.body);
        //Map<String,dynamic> result=json.decode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;
        Map<String, dynamic> result = json.decode(decryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), ''));

        debugPrint("Course Detail data $result", wrapWidth: 1024);

        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CourseDetails(courseList, widget.title)));
      } else {
        setState(() {
          print('please check data-1');
        });
      }
    } on TimeoutException catch (e) {
      print("$e");
    } on Exception catch (e) {
      debugPrint("Exception:$e", wrapWidth: 1024);
      //print("error parsing json"+response.body.toString());
    }
  }
}
