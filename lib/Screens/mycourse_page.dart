import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'dart:math';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../Helpers/encrypter.dart';
import '../Models/mycourses_model.dart';
import 'package:path_provider/path_provider.dart'; // For getting the download directory
import 'dart:io';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({Key? key}) : super(key: key);

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  bool  _isLoading=true;
    MyCoursesList? mycourses;
  double progress = 0.0;
  ReceivePort _receivePort = ReceivePort();
  //String url='https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf';
  ProgressDialog? _progressdialog;
  late String _downloadedFilePath;
  final _random = Random();
  @override
  void initState(){
    super.initState();

    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "downloading");


    ///Listening for the data is comming other isolataes
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
      print(progress);
    });
    FlutterDownloader.registerCallback(downloadingCallback);
    getCoursesList();
    _progressdialog = ProgressDialog(context);
    _progressdialog!.style(
      message: 'Downloading...',
      progress: progress/100,
      maxProgress: 100.0,
    );
  }
  static downloadingCallback(id, status, progress) {
    ///Looking up for a send port
    SendPort? sendPort = IsolateNameServer.lookupPortByName("downloading");

    ///ssending the data
    sendPort?.send([id, status, progress]);
  }
  Future<List<MyCoursesList>> getCoursesList() async {
    var url='https://techdemy.in/connect/api/mycourse';
    SharedPreferences sp = await SharedPreferences.getInstance();
    final Map<String, String>data={"user_id":sp.getInt("user_id").toString()};
    print("Testing data"+data.toString());
    Map<String, String> dat={"data":encryption(json.encode(data))};
    print("testing data"+dat.toString());


    try {
      /*Map<String, dynamic> jsonData = json.decode(
          decryption(response.body.toString()).trim().replaceAll(
              RegExp(r'\u0010'), '')) as Map<String, dynamic>;*/
      var response=await http.post(Uri.parse(url),
        body: json.encode(dat),
        headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Charset": "utf-8",
      },);
      //var array =jsonEncode(decryption(response.body.toString()));
      //var jsondata=array.toString();
     // debugPrint("my course api:"+jsondata.toString(), wrapWidth: 1024);
      print(response.body.toString());
      // if(jsonData["results"]!=null && jsonData["results"].isNotEmpty){
      if (response.statusCode == 200) {
        //Map<String, dynamic> jsonData = json.decode(decryption(response.body.toString()).trim().replaceAll(RegExp(r'\u0004'), '')) as Map<String, dynamic>;
        Map<String, dynamic> jsonData = json.decode(response.body.toString()) as Map<String, dynamic>;

        debugPrint('results:'+jsonData.toString(), wrapWidth: 1024);
        var jsonArray = jsonData['results'];
        //var tagArray=jsonData['tag_data'];
        //print("tagarray:"+tagArray.toString());
        print("array"+jsonArray.toString());
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
          var coursestatus=courselist['course_status'];
          print("course status: "+coursestatus.toString());
          if(coursestatus=="OnGoing"){
            print("Yess"+coursestatus.toString());

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
        var jsonArray = [];
        return [];
      }
    }on TimeoutException catch(e){
        print("Timeout: $e");
    }on Exception catch(e){
      print("$e");
    }
    return [];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Courses"),
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
      body: SafeArea(
        minimum: EdgeInsets.all(15),
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ButtonsTabBar(
                unselectedBackgroundColor: Colors.transparent,
                unselectedLabelStyle: TextStyle(color: Colors.blue),
                labelStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                backgroundColor: Colors.yellow,
                contentPadding: EdgeInsets.all(10),
                tabs: [
                  Tab(
                    child: Text("OnGoing", style: TextStyle(fontSize: 16, color: Colors.black),),
                  ),
                  Tab(
                    child: Text("Completed", style: TextStyle(fontSize: 16, color: Colors.black),),
                  ),
                ],
              ),

                Expanded(
                child: TabBarView(
                  children: <Widget>[

                    Column(
                      children:[
                        Expanded(
                            child: FutureBuilder<List<MyCoursesList>>(
                            future: getCoursesList(),
                            builder: (context,snapshot){
                              if(snapshot.hasData){
                                List<MyCoursesList> courses=snapshot.data!;
                                  return ListView.builder(
                                    //scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: courses.length,
                                    itemBuilder: (BuildContext, int index) {
                                      MyCoursesList courselist = courses[index];
                                      if(courselist.course_status=="OnGoing"){
                                      return Card(
                                          child: ListTile(
                                            leading: Container(
                                                alignment: Alignment.center,
                                                //padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                height: 150,
                                                width: 70,
                                                child: Image(
                                                  image: NetworkImage(
                                                      courselist.image),
                                                  fit: BoxFit.fill,)
                                            ),
                                            title: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: [
                                                  SizedBox(height: 12,),
                                                  Text(courselist.name,
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                                  SizedBox(height: 10,),
                                                  Text(courselist.description,maxLines: 3,
                                                    style: TextStyle(fontSize: 12, overflow:TextOverflow.ellipsis, fontWeight: FontWeight.w600),),
                                                  SizedBox(height: 10,),
                                                  LinearPercentIndicator(
                                                    width: 200.0,
                                                    lineHeight: 14.0,
                                                    percent: double.parse(courselist.percentage.toString())/100,
                                                    center: Text(
                                                      "${courselist.percentage.toString()}%",
                                                      style: new TextStyle(
                                                          fontSize: 12.0),
                                                    ),
                                                    //trailing: Icon(Icons.thumb_down, color: Colors.red,),
                                                    barRadius:Radius.circular(10),
                                                    backgroundColor: Colors.grey,
                                                    progressColor: Colors.blue,
                                                  ),
                                                  SizedBox(height: 10,),
                                                ]

                                            ),
                                            subtitle: Container(
                                              child: Wrap(
                                              children: [
                                                for(var tag in courselist
                                                    .tag_data.toString()
                                                    .trim()
                                                    .split("-"))...[
                                                  /* Container(
                                                child: Text("$tag")
                                            ),*/
                                                  Chip(
                                                    label: Text("$tag",
                                                      style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),),
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

                                                SizedBox(width: 5,),

                                              ],
                                      )
                                            ),
                                          )
                                      );
                                      }
                                      return Text("");
                                    },

                                  );

                              }else if(snapshot.hasError){
                                return Text('${snapshot.error}');
                               }
                                return Center(child: CircularProgressIndicator(),);
                              }
                        )
                       )
                      ],
                    ),
                    // Expanded(
                    //   child: TabBarView(
                    //     children: <Widget>[

                          Column(
                            children:[
                              Expanded(
                                  child: FutureBuilder<List<MyCoursesList>>(
                                  future: getCoursesList(),
                                  builder: (context,snapshot){
                                    if(snapshot.hasData){
                                      List<MyCoursesList> courses=snapshot.data!;
                                      return ListView.builder(
                                        //scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: courses.length,
                                        itemBuilder: (BuildContext, int index) {
                                          MyCoursesList courselist=courses[index];
                                          if(courselist.course_status=="Completed"){
                                          return Card(
                                              child: ListTile(
                                                leading:Container(
                                                    alignment: Alignment.center,
                                                    //padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                    height: 150,
                                                    width: 70,
                                                    child:Image(image:NetworkImage(courselist.image),fit: BoxFit.fill,)
                                                ),
                                                title:Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children:[
                                                      SizedBox(height: 12,),
                                                      Text(courselist.name,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                                      SizedBox(height: 10,),
                                                      Text(courselist.description,maxLines:3,style: TextStyle(fontSize: 12, overflow:TextOverflow.ellipsis,fontWeight: FontWeight.w600),),
                                                      SizedBox(height: 10,),

                                                      ElevatedButton(
                                                          onPressed: ()async{
                                                            final status=await Permission.storage.request();
                                                            if(status.isGranted){
                                                              await _progressdialog!.show();
                                                              final baseStorage= await getApplicationDocumentsDirectory();
                                                              print(baseStorage.toString());
                                                              final taskid=await FlutterDownloader.enqueue(
                                                                  url: courselist.certificate_file,
                                                                  savedDir: baseStorage.path,
                                                                  fileName: courselist.name,
                                                                showNotification: true,
                                                                openFileFromNotification: true,
                                                                saveInPublicStorage: true
                                                              );
                                                              Future.delayed(Duration(seconds: 3)).then((value) async {
                                                                await _progressdialog!.hide().whenComplete(() {
                                                                  final snackBar =SnackBar(
                                                                      content: Text('Download Complete'),
                                                                     /* action: SnackBarAction(
                                                                        label: 'View',
                                                                        onPressed:(){
                                                                          FlutterDownloader.registerCallback((id, status, progress) async{
                                                                            if (id == taskid) {
                                                                              if (status == DownloadTaskStatus.complete) {
                                                                                // Open the downloaded file
                                                                                final appDocDir = await getApplicationDocumentsDirectory();
                                                                                final downloadedFilePath = '${appDocDir.path}/$courses.name';
                                                                                await OpenFile.open(downloadedFilePath);
                                                                              }
                                                                            }
                                                                          });
                                                                         }
                                                                      )*/
                                                                  );
                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                });
                                                              });


                                                              //await _progressdialog!.hide().whenComplete(() =>const SnackBar(content: Text('Download Complete')));

                                                            }else{
                                                              print('no permission');
                                                            }
                                                          },
                                                          child: Text('download Certificate'),
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
                                                      LinearPercentIndicator(
                                                        width: 200.0,
                                                        lineHeight: 14.0,
                                                        percent: double.parse(courselist.percentage.toString())/100,
                                                        center: Text(
                                                          "${courselist.percentage.toString()}%",
                                                          style: new TextStyle(fontSize: 12.0),
                                                        ),
                                                        //trailing: Icon(Icons.thumb_up, color: Colors.green,),
                                                        barRadius: Radius.circular(10),
                                                        backgroundColor: Colors.grey,
                                                        progressColor: Colors.green,
                                                      ),
                                                      SizedBox(height: 10,),
                                                    ]

                                                ),
                                                subtitle: Container(
                                                  child:Wrap(
                                                  children: [
                                                    for(var tag in courselist.tag_data.toString().trim().split("-"))...[
                                                      /* Container(
                                                child: Text("$tag")
                                            ),*/
                                                      Chip(
                                                        label: Text("$tag",style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.bold),),
                                                        shadowColor: Colors.black54,
                                                        backgroundColor:Color.fromRGBO(_random.nextInt(256),
                                                            _random.nextInt(256),
                                                            _random.nextInt(256),
                                                            _random.nextDouble()),
                                                        //elevation: 10,
                                                        autofocus: true,
                                                        visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                                                      )
                                                    ],

                                                    SizedBox(width: 5,),

                                                  ],
                                          )
                                                ),
                                              )
                                          );
                                          }
                                          return Text("");
                                        },

                                      );
                                    }else if(snapshot.hasError){
                                      return Text('${snapshot.error}');
                                    }
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                              )
                              )
                            ],
                          ),

                    //     ],
                    //   ),
                    // ),
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
      //color: Colors.red,
      padding: EdgeInsets.symmetric(horizontal: 10,),
      color: Colors.white,
    );
  }

  @override
  bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
