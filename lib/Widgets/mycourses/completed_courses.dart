import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tech/Models/mycourses_model.dart';
import 'package:tech/controllers/profile_controller.dart';

class CompletedCourses extends StatelessWidget {
  const CompletedCourses({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    return FutureBuilder<List<MyCoursesList>>(
      future: controller.getMyCourses(),
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
                        FilledButton(
                          onPressed: () async {
                            controller.downloadFile(courselist.certificate_file, courselist.name,);
                          },
                          style: FilledButton.styleFrom(
                              backgroundColor:Colors.black87,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(color: Colors.black)
                              ),
                              minimumSize: const Size(double.infinity,40)
                            ),
                          child: const Text('Download Certificate'),
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
                                  controller.random.nextInt(256),
                                  controller.random.nextInt(256),
                                  controller.random.nextInt(256),
                                  controller.random.nextDouble()
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
    );
  }
}