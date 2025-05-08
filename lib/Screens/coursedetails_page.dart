// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tech/Models/quiz_question_model.dart';
import 'package:tech/Screens/code_editor.dart';

import '../Helpers/encrypter.dart';
import '../Models/coursedetail_model.dart';
import '../Models/courselist_model.dart';

class CourseDetails extends StatefulWidget {
  final CourseList coursedetail;
  final String title;
  const CourseDetails(this.coursedetail, this.title, {super.key});
  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  bool descTextShowFlag = true;
  final _random = Random();
  List<QuizQuestions> quizQuestions = [];
  @override
  void initState() {
    super.initState();
    getCoursesDetail();
    getCoursesList();
  }

  CourseDetail? coursedetail;
  Future<void> getCoursesDetail() async {
    //List<CourseDetail> list=[];
    var url = 'https://techdemy.in/connect/api/coursedetail';
    // SharedPreferences sp = await SharedPreferences.getInstance();
    var data = {"course_id": widget.coursedetail.course_id};
    print("course id :$data");
    var response = await http.post(
      Uri.parse(url),
      body: json.encode({"data": encryption(json.encode(data))}),
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=utf-8'
      },
    );
    debugPrint("coursedetails: ${response.body}", wrapWidth: 1024);
    print("status codesfhskjfhs ${response.statusCode}");
    if (response.statusCode == 200) {
      String decryptedData = decryption(response.body);
      //Map<String,dynamic> result=json.decode(decryption(response.body.toString().trim()).split("}")[0]+"}") as Map<String,dynamic>;
      Map<String, dynamic> result = json.decode(decryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), ''));

      // final jsondata = json.decode(response.body) ;
      final resultsData = result['results'];
      setState(() {
        coursedetail = CourseDetail.fromJson(resultsData);
      });
    }
  }

  Future<List<ChapterData>> getCoursesList() async {
    //List<CourseDetail> list=[];
    var url = 'https://techdemy.in/connect/api/coursedetail';
    //print("course id :"+coursedetail.course_id.toString());
    SharedPreferences sp = await SharedPreferences.getInstance();
    var data = {"course_id": sp.getInt("course_id")};
    print("course id :$data");

    var response = await http.post(
      Uri.parse(url),
      body: json.encode({"data": encryption(json.encode(data))}),
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=utf-8'
      },
    );

    if (response.statusCode == 200) {
      String decryptedData = decryption(response.body);

      Map<String, dynamic> result = json.decode(decryptedData.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), ''));
      var cData = result['chapter_data'];
      print("sample $cData");
      List<ChapterData> chapter = [];
      for (var item in cData) {
        ChapterData cdata = ChapterData(
          chapter_id: item['chapter_id'],
          chapter_name: item['chapter_name'],
          topic_data: item['topic_data']
        );
        chapter.add(cdata);
      }
      print('Chapters: ${chapter.length} null');
      return chapter;
    }
    return [];
  }

  Future<void> downloadFile(String url, String fileName, BuildContext context) async {
    try {
      Directory? downloadDirectory = await getExternalStorageDirectory();
      if (downloadDirectory == null) {
        throw 'there is no downloads direcotry found';
      }
      String filePath = '${downloadDirectory.path}/$fileName.docx';
      File file = File(filePath);

      if (await file.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(
            child: Text(
              'File already exists',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFF60B47B),
        ));
      }

      http.Response response = await http.get(Uri.parse(url));

      await file.writeAsBytes(response.bodyBytes);
      AlertDialog(
        title: Text('File downloaded and saved to: ${file.path}'),
        actions: [
          SnackBarAction(
            label: 'Open',
            onPressed: () {
              OpenFile.open(file.path);
            },
          ),
        ],
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Course Details"),
        surfaceTintColor: Colors.transparent,
      ),
      body: DefaultTabController(
        length: 2,
        child: coursedetail != null
          ? NestedScrollView(
              headerSliverBuilder:(BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 250.0,
                    floating: false,
                    pinned: true,
                    surfaceTintColor: Colors.transparent,
                    snap: false,
                    toolbarHeight: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image(
                        height: 100,
                        width: 100,
                        image: NetworkImage(coursedetail!.image),
                        fit: BoxFit.fill,
                      ),
                    ),
                    /*shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                ),*/
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      color: Colors.white,
                      //alignment: Alignment.center,
                      height: 130,
                      child: Column(
                        //padding: EdgeInsets.all(2),
                        //shrinkWrap: true,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5,),
                          Text(
                            coursedetail!.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text(
                            coursedetail!.duration,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(height: 5,),
                          ElevatedButton(
                            onPressed: () async {
                              var url = 'https://techdemy.in/connect/api/userenrollment';
                              /*var response=await http.get(Uri.parse(url),headers: {
                                    "Accept": "application/json",
                                    'Content-Type': 'application/json; charset=utf-8'
                                  },);*/
                              SharedPreferences sp = await SharedPreferences.getInstance();
                              final Map<String, String> data = {
                                "user_id": sp.getInt("user_id").toString(),
                                "course_id": sp.getInt("course_id").toString(),
                              };
                              print("testing data $data");
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
                                  Navigator.pushNamed(context,"/mycourses",);
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
                                  print('please check data-3 $e');
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
                            child: const Text('Start now',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: MySliverPersistentHeaderDelegate(
                      ButtonsTabBar(
                        unselectedBackgroundColor: Colors.transparent,
                        unselectedLabelStyle:const TextStyle(color: Colors.blue),
                        labelStyle: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                        ),
                        backgroundColor: Colors.yellow,
                        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        tabs: const [
                          Tab(
                            child: Text(
                              "Overview",
                              style: TextStyle(
                                fontSize: 16, 
                                color: Colors.black
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Lessons",
                              style: TextStyle(
                                fontSize: 16, 
                                color: Colors.black
                              ),
                            ),
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
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 5.0, 
                          children: [
                            for (var tag in coursedetail!.tag_data.toString().trim().split("-")) 
                            ...[
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
                                autofocus: true,
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              )
                            ],
                          ]
                        ),
                        Text(
                          coursedetail!.description.toString(),
                          maxLines: descTextShowFlag ? 2 : 15,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              descTextShowFlag = !descTextShowFlag;
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              descTextShowFlag
                                ? const Text("Show More",style: TextStyle(color: Colors.blue),)
                                : const Text("Show Less",style: TextStyle(color: Colors.blue))
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        const Row(
                          children: [
                            Icon(Icons.menu_book_sharp),
                            SizedBox(width: 10,),
                            Text("Lessons")
                          ],
                        ),
                        const Row(
                          children: [
                            Icon(Icons.timelapse),
                            SizedBox(width: 10,),
                            Text("Duration")
                          ],
                        ),
                        const Row(
                          children: [
                            Icon(Icons.translate),
                            SizedBox(width: 10,),
                            Text("English")
                          ],
                        ),
                        const Row(
                          children: [
                            Icon(Icons.badge),
                            SizedBox(width: 10,),
                            Text("Certification")
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.picture_as_pdf),
                            const SizedBox(width: 10,),
                            const Text("Course Material"),
                            const Spacer(),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                surfaceTintColor: Colors.transparent,
                                disabledBackgroundColor: Colors.transparent,
                                disabledForegroundColor:Colors.transparent
                              ),
                              onPressed: () {
                                downloadFile(coursedetail!.courseMaterial,coursedetail!.name, context);
                              },
                              child: const Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.download,
                                    size: 16,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 3,),
                                  Text(
                                    'Download',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                ],
                              )
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.comment_sharp),
                            const SizedBox(width: 10,),
                            const Text("Try code"),
                            const Spacer(),
                            IconButton(
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CodeEditorPage(),)),
                              icon: const Icon(
                                Icons.code,
                                size: 16,
                                color: Colors.blue,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    //),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    child: FutureBuilder<List<ChapterData>>(
                      future: getCoursesList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<ChapterData> chapterdata = snapshot.data!;
                          return ListView.builder(
                            itemCount: chapterdata.length,
                            itemBuilder:(BuildContext context, int index) {
                              ChapterData chapterlist = chapterdata[index];
                              print('Chapters: ${chapterlist.topic_data}');
                              return Card(
                                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10.0)),
                                color: Colors.yellow.shade100,
                                child: ExpansionTile(
                                  leading: const Icon(
                                    Icons.check,
                                    color: Colors.blue,
                                  ),
                                  title: Text(
                                    chapterlist.chapter_name,
                                    style: const TextStyle(
                                      color: Colors.black
                                    ),
                                  ),
                                  trailing: TextButton(
                                    style: TextButton.styleFrom(),
                                    onPressed: () async {
                                      Map<String, dynamic> userData = {
                                        'chapter_id':chapterlist.chapter_id
                                      };
                                      final jsonData = json.encode(userData);
                                      String url = 'https://techdemy.in/connect/api/quizlist';
                                      // var response = await http.post(
                                      //   Uri.parse(url),
                                      //   body: {
                                      //     "data": encryption(jsonData).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'),'')
                                      //   },
                                      // );
                                      // if (response.statusCode == 200) {
                                        // var decryptedData = decryption(response.body).replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'),'');
                                        // Map<String, dynamic> results =json.decode(decryptedData);
                                        for (int i = 0; i < 10; i++) {
                                          // if (result['quiz_type'] =='assessment') {
                                            List<Options> options = [
                                              Options(option: 'option_$i'),
                                              Options(option: 'option_${i+1}'),
                                              Options(option: 'option_${i+2}'),
                                              Options(option: 'option_${i+3}'),
                                            ];
                                            setState(() {
                                              quizQuestions.add(QuizQuestions(
                                                quizId: i,
                                                chapterId: i,
                                                quizType: 'quiz_type',
                                                question: 'question $i',
                                                options: options,
                                                correctAnswer: 'correct_answer'
                                                )
                                              );
                                            });
                                            debugPrint('Okay: $options',wrapWidth: 1064);
                                          // }
                                        }
                                        if (quizQuestions.isNotEmpty) {
                                          Navigator.pushNamed(context, '/quiz',arguments: {
                                              'chapterName': chapterlist.chapter_name,
                                              'description': coursedetail!.description.toString(),
                                              'questions':quizQuestions,
                                            }
                                          );
                                        }
                                        print("Questions ${quizQuestions.length}");
                                        // debugPrint('Okay: $results', wrapWidth: 1064);
                                      // } else {
                                      //   print('Not okay: ${response.body}');
                                      // }
                                    },
                                    child: const Text(
                                      'Quiz',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                  ),
                                  children:  chapterlist.topic_data.isEmpty
                                  ? [
                                    const ListTile(
                                        title: Text(
                                          'No topics for this chapter',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      )
                                    ]
                                  : [
                                    for (var topics in chapterlist.topic_data.toString().trim().split("-")) 
                                    ...[
                                      GestureDetector(
                                        onTap: () {
                                          print('Clicked');
                                          print('Chapter topics $topics');
                                        },
                                        child: ListTile(
                                          dense: true,
                                          tileColor: Colors.white,
                                          contentPadding: const EdgeInsets.all(20),
                                          title: Text(
                                            topics,
                                            style: const TextStyle(color: Colors.blue),
                                          ),
                                          trailing: IconButton(
                                            onPressed: () {
                                              print('Clicked');
                                              print('Chapter topics $topics');
                                            },
                                            icon: const Icon(
                                              Icons.download,
                                              size: 16,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ) 
                                      ),
                                    ]
                                  ],
                                )
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    )
                  )
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            )
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
      //color: Colors.red,
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
