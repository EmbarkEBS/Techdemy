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
  final FocusNode _foucsNode = FocusNode();
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
          ? GetBuilder<CourseController>(
              builder: (ctr) {
                return _homeScreenLayout(ctr.courses, context);
              }
            )
          : FutureBuilder<List<CourseList>>(
            future: controller.getCoursesList(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                List<CourseList> courses = snapshot.data!;
                return _homeScreenLayout(courses, context);
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

  Widget _homeScreenLayout(List<CourseList> courses, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15,),
          SearchAnchor(
            viewShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
            ),
            searchController: searchController,
            viewOnClose: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _foucsNode.unfocus();
                FocusScope.of(context).unfocus();
              });
            },
            builder: (context, controller) {
              return SearchBar(
                focusNode: _foucsNode,
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                elevation: const  WidgetStatePropertyAll(0),
                controller: controller,
                hintText: "Search course",
                onTap: () {
                  // Opens the suggestions view
                  searchController.openView();
                  
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
                return CourseTileWidget(course: result);
              }).toList();
            },
          ),
          const SizedBox(height: 20,),
          _loadCoursesList(courses.where((course) => course.tagData.contains("Beginner"),).toList(), "Beginners"),
          const SizedBox(height: 15,),
          _loadCoursesList(courses.where((course) => course.tagData.contains("Frameworks"),).toList(), "Frameworks"),
          const SizedBox(height: 15,),
          _loadCoursesList(courses.where((course) => course.tagData.contains("Databases"),).toList(), "Database"),
          const SizedBox(height: 15,),
          _loadCoursesList(courses.where((course) => course.tagData.contains("Advanced"),).toList(), "Advanced courses"),
          const SizedBox(height: 15,),
          _loadCoursesList(courses.where((course) => course.tagData.contains("CMS"),).toList(), "Content Management System (CMS)"),
          const SizedBox(height: 15,),
          _loadCoursesList(courses.where((course) => course.tagData.contains("Productivity"),).toList(), "Productivity Tools"),
          const SizedBox(height: 15,),
        ],
      ),
    );
  }

  Widget _loadCoursesList(List<CourseList> courses, String title) {
    return courses.isEmpty
    ? const SizedBox()
    : Column(
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
          height: 225,
          child: ListView.builder(
            shrinkWrap: true,
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
}
