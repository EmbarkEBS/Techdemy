
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Helpers/encrypter.dart';
import '../Models/coursedetail_model.dart';
import '../Models/courseslist_model.dart';

class CourseDetails extends StatefulWidget {

  final CourseList coursedetail;
  final String title;
  CourseDetails(this.coursedetail, this.title);
  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
 // double fixedHeight = 50;
  bool descTextShowFlag = true;
 // late Future<CourseDetail> coursedetail;
   //CourseList? coursedetail;
  final _random = Random();
  @override
  void initState(){
    super.initState();
    //fetchAndParseJson();
    getCoursesDetail();
    getCoursesList();
  }
  /*Future<void> fetchAndParseJson() async {
    var url='https://techdemy.in/connect/api/coursedetail';
    //print("course id :"+coursedetail.course_id.toString());
    SharedPreferences sp=await SharedPreferences.getInstance();
    var data = {"course_id": sp.getInt("course_id")};
    print("course id :"+data.toString());

    var response=await http.post(Uri.parse(url),
      body:json.encode({"data":encryption(json.encode(data))}),
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=utf-8'},
    );
    debugPrint("coursedetails:"+response.body.toString(), wrapWidth: 1024);
    print("status code"+response.statusCode.toString()); // Replace with your JSON data
    final jsonData = json.decode(response.body.toString());
    print("datajson"+jsonData.toString());
    setState(() {
      coursedetail = CourseDetail.fromJson(jsonData['results']);
    });
  }*/
  CourseDetail? coursedetail;
  Future <void> getCoursesDetail() async{
    //List<CourseDetail> list=[];
    var url='https://techdemy.in/connect/api/coursedetail';
    SharedPreferences sp=await SharedPreferences.getInstance();
    var data = {"course_id": sp.getInt("course_id")};
    print("course id :"+data.toString());

    var response=await http.post(Uri.parse(url),
      body:json.encode({"data":encryption(json.encode(data))}),
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=utf-8'},
    );
    debugPrint("coursedetails:"+response.body.toString(), wrapWidth: 1024);
    print("status codesfhskjfhs"+response.statusCode.toString());
    if(response.statusCode==200){
      final jsondata = json.decode(response.body) ;
      final resultsData = jsondata['results'];
      setState(() {
        coursedetail=CourseDetail.fromJson(resultsData);
      });
    }
  }
  Future<List<ChapterData>> getCoursesList()async{
    //List<CourseDetail> list=[];
    var url='https://techdemy.in/connect/api/coursedetail';
    //print("course id :"+coursedetail.course_id.toString());
    SharedPreferences sp=await SharedPreferences.getInstance();
   var data = {"course_id": sp.getInt("course_id")};
    print("course id :"+data.toString());

    var response=await http.post(Uri.parse(url),
      body:json.encode({"data":encryption(json.encode(data))}),
      headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json; charset=utf-8'},
    );
    //debugPrint("coursedetails:"+response.body.toString(), wrapWidth: 1024);
    //print("status code"+response.statusCode.toString());
    Map<String,dynamic> jsondata = json.decode(response.body) as Map<String,dynamic>;
    if (response.statusCode == 200) {

    // var course=CourseDetail.fromJson(data);
      //var coursedata=jsondata['results'];
     // print("coursedata: "+coursedata['name']);
      var cData=jsondata['chapter_data'] ;
      print("sample "+cData.toString());
     // print("chapterdata "+chapterdata.chapter_name);
      List<ChapterData> chapter=[];
      for(var item in cData){
        ChapterData cdata=ChapterData(
            chapter_id: item['chapter_id'],
            chapter_name: item['chapter_name'],
            topic_data: item['topic_data']
        );
        chapter.add(cdata);
      }
      return chapter;
      /*var rest = data["results"] as List;
      print(rest);
      for(var item in rest){

        ChapterData cdata=ChapterData(
            chapter_id: item['chapter_id'],
            chapter_name: item['chapter_name'],
            topic_data: item['topic_data'],
        );
        rest.add(cdata);
      }*/
     // list = rest.map<CourseDetail>((json) => CourseDetail.fromJson(json)).toList();
    }
   /* print("List Size: ${list.length}");
    return list;
    if(response.statusCode==200){
      print("hi from course detail");
      Map<String, dynamic> data=json.decode(response.body) as Map<String, dynamic>;
        var jsondata=data["results"];
        print("ckgakgsfg"+jsondata.toString());
        List<CourseDetail> coursedetail=[];
        for(var item in jsondata){
              CourseDetail clist=CourseDetail(
                  course_id: int.parse(item['course_id']),
                  name: item['name'],
                  description: item['description'],
                  price: item['price'],
                  duration: item['duration'],
                  image: item['image'],
                  tag_data: item['tag_data'],
                  //chapter_data: item['chapter_data']
              );
              coursedetail.add(clist);
        }
     /* var rest=data["results"] as List;
      //print(sdata[0]["chapter_name"]);
      print(data.toString());
      //var rest= data["chapter_data"] as List;
      print(rest);
      list=rest.map<CourseDetail>((json)=>CourseDetail.fromJson(json)).toList();*/
    }*/
   // print("Course detail List Size: ${list.length}");
    return [];
  }
  /*Future<List<CourseDetail>> getCoursesList()async{
    var url='https://techdemy.in/connect/api/coursedetail';
    var response=await http.get(Uri.parse(url),headers: {
      "Accept": "application/json",
      'Content-Type': 'application/json; charset=utf-8'
    },);
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
   //// Map<String, dynamic> jsonData = json.decode(decryption(response.body.toString()).trim().replaceAll(RegExp(r'\u0010'), '')) as Map<String, dynamic>;
    //     //Map<String, dynamic> jsonData = json.decode(decryption(response.body.toString())) as Map<String, dynamic>;
    //debugPrint("datahkjdf"+jsondata.toString(), wrapWidth: 1024);
    //var jsondecode =jsonDecode(jsonData);
    Map<String,dynamic> jsonData=jsonDecode(response.body.toString()) as Map<String,dynamic>;
    // print("jsondata" + jsonData.toString());

    // Iterable jsonResponse = jsonDecode(response.body);
    // List<CoursesList> listHashtagTop =
    // jsonResponse.map((model) => CoursesList.fromJson(model)).toList();
    //
    // return listHashtagTop;

    if(response.statusCode==200){
      var jsonArray = jsonData['results'];
      //var tagArray=jsonData['tag_data'];
      //print("tagarray:"+tagArray.toString());
      print("array"+jsonArray.toString());

      List<CourseDetail> courses = [];
      //List<TagData> tag=[];
      for (var courselist in jsonArray) {
        CourseDetail cList = CourseDetail(
          course_id: courselist['course_id'] ,
          name: courselist['name'],
          description: courselist['description'],
          price: courselist['price'],
          duration: courselist['duration'],
          image: courselist['image'],
          tag_data: courselist['tag_data'],
          chapter_data: courselist['chapter_data'],
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
  }*/
  @override
  Widget build(BuildContext context) {
    return SafeArea(

      /*body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
             SliverAppBar(
              expandedHeight: 350,
              pinned: true,
              title: Text(
                'MySliverAppBar',
              ),backgroundColor: Colors.black,
              flexibleSpace: FlexibleSpaceBar(
                background: Image(
                    height: 100,
                    width: 100,
                    image:AssetImage("assets/images/coursedetail.jpg",),fit: BoxFit.fitHeight,
                ),
              ),
            ),

          ];
        },
        body: Container(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Basics Of Java", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  SizedBox(width: 50,),
                  Text("4 Months",style: TextStyle(fontSize: 16),)
                ],
              ),
                SizedBox(height: 15,),
              SafeArea(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: <Widget>[
                      ButtonsTabBar(
                        backgroundColor: Colors.red,
                        unselectedBackgroundColor: Colors.grey[300],
                        unselectedLabelStyle: TextStyle(color: Colors.black),
                        labelStyle:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        tabs: [
                          Tab(
                            text: "Overview",
                          ),
                          Tab(
                            text: "Lessons",
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ),*/
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Course Details"),
          backgroundColor: Colors.black,
        ),
        body: DefaultTabController(
          length: 2,
          child: coursedetail!=null?NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 250.0,
                  floating: false,
                  pinned: true,
                  snap: false,
                  toolbarHeight: 0,
                  flexibleSpace: FlexibleSpaceBar(
                  background: Image(
                  height: 100,
                  width: 100,
                  image:NetworkImage(coursedetail!.image),fit: BoxFit.fill,
                  ),
                  ),
                  /*shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                  ),*/

                  ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20,10,20,10),
                    color: Colors.white,
                    //alignment: Alignment.center,
                    height: 130,
                     child:Column(
                       //padding: EdgeInsets.all(2),
                       //shrinkWrap: true,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         SizedBox(height: 5,),
                         Text('${coursedetail!.name}', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                         SizedBox(height: 10,),
                         Text('${coursedetail!.duration}',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                         SizedBox(height: 5,),
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
                               "course_id": sp.getInt("course_id").toString(),
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
                           child: Text('start now',style: TextStyle(
                               fontSize: 15,
                               color: Colors.yellow,
                               fontWeight: FontWeight.bold)),
                           style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.black87,
                             elevation: 0,
                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(5),
                                 side:BorderSide(color: Colors.black)
                             ),
                             minimumSize: Size(double.infinity, 40)
                         ),)
                       ],
                     )
                    /*FutureBuilder(
                         future: getCoursesDetail(),
                         builder:(context,snapshot){
                         if(snapshot.hasData) {
                             //final courses = snapshot.data!.length;
                            Column(
                              //padding: EdgeInsets.all(2),
                              //shrinkWrap: true,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5,),
                                Text(coursedetail!.name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                SizedBox(height: 10,),
                                Text(widget.coursedetail.duration.toString(),style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),)
                              ],
                            );
                          }else if(snapshot.hasError){
                            return Text('${snapshot.error}',style: TextStyle(color: Colors.black),);
                          }
                          return Text('${snapshot.error}',style: TextStyle(color: Colors.black),);
                        }
                    ),*/
                  ),
                ),
                /*SliverToBoxAdapter(
                  child: Stack(
                      children: [
                        SizedBox(height: 10,),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:[
                            SizedBox(width: 20,),
                            FutureBuilder<List<CoursesList>>(
                                future: getCoursesList(),
                                builder:(context,snapshot){
                                  if(snapshot.hasData) {
                                    final courses = snapshot.data!;
                                    return ListView.builder(
                                      //padding: EdgeInsets.all(2),
                                      //shrinkWrap: true,
                                      itemCount: courses.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        CoursesList courselist=courses[index];
                                        return Wrap(
                                            children:[
                                            Text(courselist.name, style: TextStyle(color: Colors.black),)
                                            ]
                                        );
                                      },

                                    );
                                  }else if(snapshot.hasError){
                                    return Text('${snapshot.error}',style: TextStyle(color: Colors.black),);
                                  }
                                  return Center(child: CircularProgressIndicator(),);
                                }
                            ),
                            SizedBox(width: 70,),
                            Expanded(child:Text("4 Months",style: TextStyle(fontSize: 16),)),
                            //Text("4 Months",style: TextStyle(fontSize: 16),)
                           ]
                        ),

                      ],
                    ),
                ),*/
                SliverPersistentHeader(
                  delegate: MySliverPersistentHeaderDelegate(
                    ButtonsTabBar(
                      unselectedBackgroundColor: Colors.transparent,
                      unselectedLabelStyle: TextStyle(color: Colors.blue),
                      labelStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      backgroundColor: Colors.yellow,
                      contentPadding: EdgeInsets.fromLTRB(10,0,10,0),
                      tabs: [
                        Tab(
                          child: Text("Overview", style: TextStyle(fontSize: 16, color: Colors.black),),
                        ),
                        Tab(
                          child: Text("Lessons", style: TextStyle(fontSize: 16, color: Colors.black),),
                        ),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                SingleChildScrollView(
               // child: Container(
               //    color: Colors.white,
               //
               //    padding: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        children:[
                          for(var tag in coursedetail!.tag_data.toString().trim().split("-"))...[
                            /* Container(
                                                child: Text("$tag")
                                            ),*/
                            Chip(
                              label: Text("$tag",style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.bold),),
                              shadowColor: Colors.black54,
                              backgroundColor: Color.fromRGBO(_random.nextInt(256),
                                  _random.nextInt(256),
                                  _random.nextInt(256),
                                  _random.nextDouble()),
                              //elevation: 10,
                              autofocus: true,
                              visualDensity: VisualDensity(horizontal: -4,vertical: -4),
                            )
                          ],
                        ]
                      ),

                      Text(coursedetail!.description.toString(),
                        maxLines:descTextShowFlag?2:15,
                      ),
                      InkWell(
                        onTap: (){ setState(() {
                          descTextShowFlag = !descTextShowFlag;
                        }); },
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            descTextShowFlag ? Text("Show More",style: TextStyle(color: Colors.blue),) :  Text("Show Less",style: TextStyle(color: Colors.blue))
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Icon(Icons.menu_book_sharp),
                          SizedBox(width: 10,),
                          Text("Lessons")
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.timelapse),
                          SizedBox(width: 10,),
                          Text("Duration")
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.translate),
                          SizedBox(width: 10,),
                          Text("English")
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.badge),
                          SizedBox(width: 10,),
                          Text("Certification")
                        ],
                      ),
                    ],
                  ),
                //),
        ),
               /* Padding(
                    padding: EdgeInsets.all(10),
                    child:Column(
                      children: [
                        if(coursedetail!=null)...[
                          Image.network(coursedetail!.image),
                          Text('Course Name: ${coursedetail!.name}'),
                          Text('Description: ${coursedetail!.description}'),
                          Text('Price: \$${coursedetail!.price}'),
                          Text('Duration: ${coursedetail!.duration}'),
                          //Text('Tags: ${coursedetail!.tag_data}'),
                          //Text('Chapter Count: ${coursedetail!.chapterCount}'),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: coursedetail!.chapter_data.length,
                            itemBuilder: (context, index) {
                              final chapter = coursedetail!.chapter_data[index];
                              return ExpansionTile(
                                title: Text(chapter.chapter_name),
                                children: [
                                  ListTile(
                                    title: Text(chapter.topic_data),
                                  ),
                                ],
                              );
                            },
                          ),
                        ]else ...[
                          CircularProgressIndicator(),
                        ],
                      ],
                    )
                )*/
                Container(
                  color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child:FutureBuilder<List<ChapterData>>(
                      future: getCoursesList(),
                      builder: (context,snapshot){
                        if(snapshot.hasData) {
                          List<ChapterData> chapterdata=snapshot.data!;
                          return ListView.builder(
                            itemCount: chapterdata.length,
                            itemBuilder: (BuildContext context, int index) {
                              ChapterData chapterlist=chapterdata[index];
                              //print(chapterlist.chapter_data[index].chapter_name);
                              return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)
                                  ),
                                  color: Colors.yellow.shade100,
                                  child: ExpansionTile(
                                    leading: Container(
                                        child: Icon(
                                          Icons.check, color: Colors.blue,)
                                    ),
                                    title: Text(chapterlist.chapter_name,
                                      style: TextStyle(color: Colors.black),),
                                    children: [
                                      for(var topics in chapterlist.topic_data.toString().trim().split("-"))...[
                                        GestureDetector(
                                          onTap: () {
                                            print("clicked");
                                          },
                                          child: Container(
                                            //color: Colors.white70,
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                color: Colors.white70,
                                                borderRadius: BorderRadius
                                                    .circular(4)
                                            ),
                                            width: double.infinity,
                                            child: Text('$topics',
                                              style: TextStyle(
                                                  color: Colors.blue),),
                                          ),
                                        ),
                                      ]

                                     /* GestureDetector(
                                        onTap: () {
                                          print("clicked");
                                        },
                                        child: Container(
                                          color: Colors.white70,
                                          padding: EdgeInsets.all(20),
                                          width: double.infinity,
                                          child: Text("Topic 2",
                                            style: TextStyle(
                                                color: Colors.blue),),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          print("clicked");
                                        },
                                        child: Container(
                                          color: Colors.white70,
                                          padding: EdgeInsets.all(20),
                                          width: double.infinity,
                                          child: Text("Topic 3",
                                            style: TextStyle(
                                                color: Colors.blue),),
                                        ),
                                      ),*/
                                    ],
                                  )
                              );
                            },
                          );
                        }else if(snapshot.hasError){
                          return Text('${snapshot.error}');
                        }
                        return Center(child: CircularProgressIndicator(),);
                      },
                    )
                )
              ],
            ),
          ):Center(child: CircularProgressIndicator(),)

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
