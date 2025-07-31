import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Widgets/course_card_widget.dart';
import 'package:tech/controllers/course_controller.dart';

import '../Models/courselist_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = SearchController();
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page', style: TextStyle(fontSize: 18)),
        // backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
      ),
      // drawer: const DrawerWidget(profileCaller: "Home screen",),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: RefreshIndicator(
          onRefresh: () async {
            // We can use this value inside the Future.value(newList) instead of directly call inside the setState
            // List<CourseList> newList = await controller.getCoursesList();
            await controller.getCoursesList();
          },
          child: controller.courses.isNotEmpty
          ? _homeScreenLayout(controller.courses)
          : FutureBuilder<List<CourseList>>(
            future: controller.getCoursesList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<CourseList> courses = snapshot.data!;
                return _homeScreenLayout(courses);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      )
    );
  }

  Widget _homeScreenLayout(List<CourseList> courses) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15,),
          SearchAnchor(
            viewShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
            ),
            searchController: searchController,
            builder: (context, controller) {
              return SearchBar(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                elevation: const  WidgetStatePropertyAll(0),
                controller: controller,
                hintText: "Search course",
                onTap: () {
                  // Opens the suggestions view
                  searchController.openView();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FocusScope.of(context).unfocus();
                  });
                },
                onTapOutside: (event) {
                  // Remove focus on cancel/clear
                  FocusScope.of(context).unfocus();
                },
                onChanged: (value) {
                  // Opens suggestions when typing
                   if (value.isNotEmpty) {
                    searchController.openView();
                  } else {
                    searchController.clear();
                    searchController.closeView(null);
                    // Remove focus on cancel/clear
                    FocusScope.of(context).unfocus();
                  }
                },
                trailing: const [Icon(Icons.search)],
              );
            }, 
            suggestionsBuilder: (context, controller) {
              final query = controller.text.trim().toLowerCase();
              if (query.isEmpty) return [];

              final results = courses.where((course) =>
                course.name.toLowerCase().contains(query)).toList();
              return results.map((result) {
                return ListTile(
                  title: Text(result.name),
                  onTap: () {
                    setState(() {
                      // selectedCity = result;
                    });
                    // Close the suggestions view
                    searchController.closeView(result.name);
                  },
                );
              }).toList();
            },
          ),
          const SizedBox(height: 20,),
          _loadCoursesList(courses.sublist(0, 5), "Programming"),
          const SizedBox(height: 15,),
          _loadCoursesList(courses.sublist(5, 10), "Design"),
          const SizedBox(height: 15,),
          _loadCoursesList(courses.sublist(10, 18), "Full stack"),
          const SizedBox(height: 15,),
          _loadCoursesList(courses.sublist(18, courses.length), "SEO"),
          const SizedBox(height: 15,),
        ],
      ),
    );
  }

  Widget _loadCoursesList(List<CourseList> courses, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  CourseCardWidget(course: courses[index]),
                  const SizedBox(width: 5,)
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget _loadCourseCard(CourseList course) {
  //   return CourseCardWidget(course: course);
    // return  ListView.separated(
    //   itemCount: courses.length,
    //   itemBuilder: (context, index) {
    //     CourseList courseList = courses[index];
    //     if (controller.selectedCategory == 'All' || controller.selectedCategory == courseList.name) {
    //       return CourseCardWidget(course: courseList);
          
    //       // ListTile(
    //       //   // onTap: () async => await controller.logActivity(),
            // onTap: () async => await controller.getCoursesDetail(courselist.courseId.toString()).then((value) async {
            //   bool status = await controller.checkEnroll(courselist.courseId);
            //   Get.to(() => CourseDetailsScreen(isEnrolled: status));
            // },),
    //       //   leading: Container(
    //       //     alignment: Alignment.center,
    //       //     height: 100,
    //       //     width: 60,
    //       //     child: Image.network(
    //       //       courselist.image,
    //       //       errorBuilder: (context, error, stackTrace) {
    //       //         return const Center(
    //       //           child: Icon(Icons.error),
    //       //         );
    //       //       },
    //       //     ),
    //       //   ),
    //       //   title: Column(
    //       //     crossAxisAlignment: CrossAxisAlignment.start,
    //       //     mainAxisAlignment: MainAxisAlignment.start,
    //       //     children: [
    //       //       Text(
    //       //         courselist.name,
    //       //         style: const TextStyle(
    //       //           fontSize: 16,
    //       //           fontWeight: FontWeight.bold
    //       //         ),
    //       //       ),
    //       //       const SizedBox(height: 10,),
    //       //       Text(courselist.duration),
    //       //       const SizedBox(height: 10,),
    //       //       Text(
    //       //         courselist.description,
    //       //         maxLines: 3,
    //       //         overflow: TextOverflow.ellipsis,
    //       //         textAlign: TextAlign.justify,
    //       //         style: const TextStyle(
    //       //           fontSize: 12,
    //       //           fontWeight: FontWeight.w600,
    //       //         ),
    //       //       ),
    //       //       const SizedBox(height: 10,),
    //       //       GetBuilder<CourseController>(
    //       //         id: 'enroll_${courselist.courseId.toString()}', 
    //       //         builder: (ctr2) {
    //       //           return FutureBuilder(
    //       //             future: controller.checkEnroll(courselist.courseId), 
    //       //             builder: (context, snapshot) {
    //       //               if(snapshot.hasData && snapshot.data == true) {
    //       //                 return const SizedBox();
    //       //               } else {
    //       //                 return FilledButton(
    //       //                   onPressed: () async => await ctr2.enrollCourse(courselist.courseId.toString()),
    //       //                   style: FilledButton.styleFrom(
    //       //                     backgroundColor: Colors.black87,
    //       //                     minimumSize: const Size(double.infinity, 40)
    //       //                   ),
    //       //                   child: ctr2.isEnrolling[courselist.courseId.toString()] != null 
    //       //                     && ctr2.isEnrolling[courselist.courseId.toString()]!
    //       //                   ? const SizedBox(
    //       //                       height: 24,
    //       //                       width: 24,
    //       //                       child: Center(
    //       //                         child: CircularProgressIndicator(
    //       //                           color: Colors.yellow,
    //       //                         ),
    //       //                       ),
    //       //                     )
    //       //                   : const Text(
    //       //                     'Start Now',
    //       //                     style: TextStyle(
    //       //                       fontSize: 15,
    //       //                       color: Colors.yellow,
    //       //                       fontWeight: FontWeight.bold
    //       //                     ),
    //       //                   ),
    //       //                 );
    //       //               }
    //       //             },
    //       //           );
    //       //         }
    //       //       ),
    //       //     ],
    //       //   ),
    //       //   subtitle: courselist.tagData.isEmpty
    //       //   ? const SizedBox()
    //       //   : Wrap(
    //       //     spacing: 5.0,
    //       //     children: [
    //       //       for (var tag in courselist.tagData.toString().trim().split("-")) 
    //       //         ...[
    //       //         Chip(
    //       //           label: Text(
    //       //             tag,
    //       //             style: const TextStyle(
    //       //               fontSize: 10,
    //       //               color: Colors.black,
    //       //               fontWeight: FontWeight.bold
    //       //             ),
    //       //           ),
    //       //           shadowColor: Colors.black54,
    //       //           backgroundColor: Color.fromRGBO(
    //       //             controller.random.nextInt(256),
    //       //             controller.random.nextInt(256),
    //       //             controller.random.nextInt(256),
    //       //             controller.random.nextDouble()
    //       //           ),
    //       //           //elevation: 10,
    //       //           autofocus: true,
    //       //           visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    //       //         )
    //       //       ],
    //       //       // const SizedBox(width: 5,)s,
    //       //     ],
    //       //   ),
    //       // );
        
    //     } else {
    //       return const SizedBox();
    //     }
    //   },
    //   separatorBuilder: (context, index) {
    //     return const Divider(
    //       thickness: 1,
    //       color: Colors.black26,
    //     );
    //   },
    // );
            
  // }
}
