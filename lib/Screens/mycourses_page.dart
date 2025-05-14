// ignore_for_file: avoid_print, use_build_context_synchronously, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech/Helpers/encrypter.dart';
import 'package:tech/Screens/myprofile_page.dart';

import '../Models/mycourses_model.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  MyCoursesList? mycourses;
  double progress = 0.0;
  final ReceivePort _receivePort = ReceivePort();
  //String url='https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf';
  // ProgressDialog? _progressdialog;
  // late String _downloadedFilePath;
  final _random = Random();
  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "downloading");

    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
      print(progress);
    });
    FlutterDownloader.registerCallback(downloadingCallback);
    getCoursesList();
    // _progressdialog = ProgressDialog(context);
    // _progressdialog!.style(
    //   message: 'Downloading...',
    //   progress: progress/100,
    //   maxProgress: 100.0,
    // );
  }

  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort?.send([id, status, progress]);
  }

  Future<List<MyCoursesList>> getCoursesList() async {
    var url = 'https://techdemy.in/connect/api/mycourse';
    SharedPreferences sp = await SharedPreferences.getInstance();
    final Map<String, String> data = {
      "user_id": sp.getInt("user_id").toString()
    };
    print("Testing data$data");

    Map<String, String> dat = {"data": encryption(json.encode(data))};
    print("testing data$dat");

    try {
      var response = await http.post(
        Uri.parse(url),
        body: json.encode(dat),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          "Charset": "utf-8",
        },
      );
      print('Response: ${response.body}');
      //var array =jsonEncode(decryption(response.body.toString()));
      //var jsondata=array.toString();
      // debugPrint("my course api:"+jsondata.toString(), wrapWidth: 1024);
      print(response.body.toString());
      // Map<String, dynamic> jsonData = json.decode(decryption(response.body.toString()).trim().replaceAll(RegExp(r'\u0004'), '')) as Map<String, dynamic>;
      
      String decrptedData = decryption(response.body);
      print('Course list Body: $decrptedData');
      Map<String, dynamic> jsonData = json.decode(decrptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F ]'), ''));
      debugPrint('results:$jsonData', wrapWidth: 1024);
      var jsonArray = jsonData['results'];
      //var tagArray=jsonData['tag_data'];
      //print("tagarray:"+tagArray.toString());
      print("array$jsonArray");
      // if(jsonData["results"]!=null && jsonData["results"].isNotEmpty){
      if (response.statusCode == 200) {
        List<MyCoursesList> courses = [];
        //List<TagData> tag=[];
        for (var courselist in jsonArray) {
          MyCoursesList cList = MyCoursesList(
            course_id: courselist['course_id'],
            name: courselist['name'],
            description: courselist['description'],
            price: courselist['price'],
            duration: courselist['duration'],
            image: courselist['image'],
            tag_data: courselist['tag_data'],
            enroll_id: courselist['enroll_id'],
            percentage: courselist['percentage'],
            course_status: courselist['course_status'],
            certificate_file: courselist['certificate_file']
          );
          var coursestatus = courselist['course_status'];
          print("course status: $coursestatus");
          if (coursestatus == "OnGoing") {
            print("Yess$coursestatus");
          }
          /*for(var tags in courselist['tag_data']){
          TagData taglist=TagData(tag_name:tags['tag_name']);
          tag.add(taglist);
          print("Tag Array"+tags.toString());
        }*/
          courses.add(cList);
        }
        return courses;
      } else {
        // var jsonArray = [];
        return [];
      }
    } on TimeoutException catch (e) {
      print("Timeout: $e");
    } on Exception catch (e) {
      print("$e");
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    String successtxt = "", errtxt = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Courses",),
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/homepage");
            },
            icon: const Icon(
              Icons.home,
              size: 30,
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
              onTap: () async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                print(sp.getInt("user_id").toString());
                var url = 'https://techdemy.in/connect/api/userprofile';
                final Map<String, String> data = {
                  "user_id": sp.getInt("user_id").toString()
                };
                print("testing data $data");
                Map<String, String> dat = {
                  "data": encryption(json.encode(data))
                };
                print("testing data $dat");
                try {
                  final response = await http.post(Uri.parse(url),
                    body: json.encode(dat),
                    headers: {
                      "CONTENT-TYPE": "application/json"
                    }).timeout(const Duration(seconds: 20)
                  );
                  print("status code: ${response.statusCode}");
                  if (response.statusCode == 200) {
                    String decrptedData = decryption(response.body);
                    Map<String, dynamic> jsonData = json.decode(decrptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F ]'), ''));
                    if (jsonData["status"] == "success") {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyProfilePage(jsonData["results"])));
                    }
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));
                  } else {
                    Navigator.of(context).pop();
                    setState(() {
                      successtxt = "";
                      errtxt = "${response.statusCode} :Please Check your Internet Connection And data - 1";
                    });
                  }
                } on TimeoutException catch (e) {
                  Navigator.of(context).pop();
                  setState(() {
                    errtxt = "Please Check your Internet Connection And data - 2 $e";
                    successtxt = "";
                  });
                } on Exception catch (e) {
                  print("Exception: $e");
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
                // Navigator.pushNamed(context, "/mycourses");
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
                print("after${sp.getInt("user_id")}");
                Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(15),
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ButtonsTabBar(
                unselectedBackgroundColor: Colors.transparent,
                unselectedLabelStyle: const TextStyle(color: Colors.blue),
                labelStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                backgroundColor: Colors.yellow,
                contentPadding: const EdgeInsets.all(10),
                tabs: const [
                  Tab(
                    child: Text(
                      "OnGoing",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Completed",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    Column(
                      children: [
                        Expanded(
                          child: FutureBuilder<List<MyCoursesList>>(
                            future: getCoursesList(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<MyCoursesList> courses = snapshot.data!;
                                bool haveCompletedCourses = courses.any((course) => course.course_status == "OnGoing");
                                return !haveCompletedCourses
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(child: Text("No on-going courses found")),
                                    ],
                                  )
                                : ListView.builder(
                                    //scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: courses.length,
                                    itemBuilder:(BuildContext context, int index) {
                                      MyCoursesList courselist = courses[index];
                                      if (courselist.course_status == "OnGoing") {
                                        return Card(
                                            child: ListTile(
                                              // onTap: () => Navigator.pushNamed(context, "/"),
                                              leading: Container(
                                                alignment: Alignment.center,
                                                //padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                height: 150,
                                                width: 70,
                                                child: Image(
                                                  image: NetworkImage(courselist.image),
                                                  fit: BoxFit.fill,
                                                )
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
                                                  Text(
                                                    courselist.description,
                                                    maxLines: 3,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      overflow: TextOverflow.ellipsis,
                                                      fontWeight:FontWeight.w600
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  LinearPercentIndicator(
                                                    width: 195.0,
                                                    lineHeight: 14.0,
                                                    percent: double.parse(courselist.percentage.toString()) / 100,
                                                    center: Text(
                                                      "${courselist.percentage.toString()}%",
                                                      style: const TextStyle(fontSize: 12.0),
                                                    ),
                                                    //trailing: Icon(Icons.thumb_down, color: Colors.red,),
                                                    barRadius: const Radius.circular(10),
                                                    backgroundColor:Colors.grey,
                                                    progressColor: Colors.blue,
                                                  ),
                                                  const SizedBox(height: 10,),
                                                ]
                                              ),
                                              subtitle: Wrap(
                                                spacing: 5.0,
                                                children: [
                                                  for (var tag in courselist.tag_data.toString().trim().split("-")) ...[
                                                    Chip(
                                                      label: Text(
                                                        tag,
                                                        style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                          fontWeight:FontWeight.bold
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
                                                      visualDensity: const VisualDensity(horizontal: -4,vertical: -4),
                                                    )
                                                  ],
                                                  const SizedBox(width: 5,),
                                                ],
                                              ),
                                            )
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  );
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          )
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: FutureBuilder<List<MyCoursesList>>(
                            future: getCoursesList(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<MyCoursesList> courses = snapshot.data!;
                                bool haveCompletedCourses = courses.any((course) => course.course_status == "Completed");
                                return !haveCompletedCourses
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(child: Text("No Course Completed Yet")),
                                    ],
                                  )
                                : ListView.builder(
                                  //scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: courses.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    MyCoursesList courselist = courses[index];
                                    if (courselist.course_status == "Completed") {
                                      return Card(
                                        child: ListTile(
                                          leading: Container(
                                            alignment: Alignment.center,
                                            //padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                            height: 150,
                                            width: 70,
                                            child: Image(
                                              image: NetworkImage(courselist.image),
                                              fit: BoxFit.fill,
                                            )
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
                                              Text(
                                                courselist.description,
                                                maxLines: 3,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  overflow: TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              const SizedBox(height: 10,),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  downloadFile(courselist.certificate_file, courselist.name, context);
                                                  final status = await Permission.storage.request();
                                                  if (status.isGranted) {
                                                    final baseStorage = await getApplicationDocumentsDirectory();
                                                    print(baseStorage.toString());
                                                    final taskid = await FlutterDownloader.enqueue(
                                                      url: courselist.certificate_file,
                                                      savedDir: baseStorage.path,
                                                      fileName: courselist.name,
                                                      showNotification: true,
                                                      openFileFromNotification: true,
                                                      saveInPublicStorage: true
                                                    );
                                                    Future.delayed(const Duration(seconds: 3)).then((value) async {
                                                      // await _progressdialog!.hide().whenComplete(() {
                                                      //   final snackBar =
                                                      SnackBar(content: const Text('Download Complete'),
                                                        action: SnackBarAction(
                                                          label:'View',
                                                          onPressed: () {
                                                            FlutterDownloader.registerCallback((id, status, progress) async {
                                                              if (id == taskid) {
                                                                // ignore: unrelated_type_equality_checks
                                                                if (status ==
                                                                    DownloadTaskStatus.complete) {
                                                                  // Open the downloaded file
                                                                  final appDocDir = await getApplicationDocumentsDirectory();
                                                                  final downloadedFilePath = '${appDocDir.path}/$courses.name';
                                                                  await OpenFile.open(downloadedFilePath);
                                                                }
                                                              }
                                                            });
                                                          }
                                                        )
                                                      );
                                                    }
                                                  );
                                                  } else {
                                                    print('no permission');
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.black87,
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    5),
                                                        side: const BorderSide(
                                                            color: Colors
                                                                .black)),
                                                    minimumSize: const Size(
                                                        double.infinity,
                                                        40)),
                                                child: const Text(
                                                    'Download Certificate'),
                                              ),
                                              const SizedBox(height: 10,),
                                              LinearPercentIndicator(
                                                width: 195.0,
                                                lineHeight: 14.0,
                                                percent: double.parse(courselist.percentage.toString()) / 100,
                                                center: Text(
                                                  "${courselist.percentage.toString()}%",
                                                  style: const TextStyle(fontSize: 12.0),
                                                ),
                                                //trailing: Icon(Icons.thumb_up, color: Colors.green,),
                                                barRadius:const Radius.circular(10),
                                                backgroundColor: Colors.grey,
                                                progressColor: Colors.green,
                                              ),
                                              const SizedBox(height: 10,),
                                            ]
                                          ),
                                          subtitle: Wrap(
                                            spacing: 5.0,
                                            children: [
                                              for (var tag in courselist.tag_data.toString().trim().split("-")) 
                                              ...[
                                                Chip(
                                                  label: Text(
                                                    tag,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight:FontWeight.bold
                                                    ),
                                                  ),
                                                  shadowColor: Colors.black54,
                                                  backgroundColor:
                                                      Color.fromRGBO(
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
                                        )
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                );
                              }  else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          )
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  MySliverPersistentHeaderDelegate(this._tabBar);

  final ButtonsTabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,),
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

Future<void> downloadFile(String url, String fileName, BuildContext context) async {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.height;
  try {
    Directory? downloadDirectory = await getExternalStorageDirectory();
    if (downloadDirectory == null) {
      throw 'there is no downloads direcotry found';
    }
    String filePath = '${downloadDirectory.path}/$fileName.docx';
    File file = File(filePath);

    if (await file.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Center(
          child: Text(
            'File already exists',
            style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: screenHeight * 0.85,
          left: screenWidth * 0.1,
          right: screenWidth * 0.1
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF60B47B),
      ));
    }

    http.Response response = await http.get(Uri.parse(url));

    await file.writeAsBytes(response.bodyBytes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File downloaded and saved to: ${file.path}'),
        action: SnackBarAction(
          label: 'Open',
          onPressed: () {
            OpenFile.open(file.path);
          },
        ),
      ),
    );
    print('File downloaded and saved to: ${file.path}');
  } catch (e) {
    print('Error downloading file: $e');
  }
}
