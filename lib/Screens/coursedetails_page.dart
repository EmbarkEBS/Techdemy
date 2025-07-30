import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Widgets/courseDetail/chapter_detail_widget.dart';
import 'package:tech/Widgets/courseDetail/course_detail_widget.dart';
import 'package:tech/controllers/course_controller.dart';


class CourseDetailsScreen extends StatelessWidget {
  final bool? isEnrolled;
  const CourseDetailsScreen({super.key, required this.isEnrolled});
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Course Details"),
        surfaceTintColor: Colors.transparent,
      ),
      body: DefaultTabController(
        length: 2,
        child: controller.courseDetail != null
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course image
              Image(
                width: double.infinity,
                image: NetworkImage(controller.courseDetail!.courseDetailPart.image),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.error),
                  );
                },
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.courseDetail!.courseDetailPart.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),
                                ),
                                Text(
                                  "₹${controller.courseDetail!.courseDetailPart.price}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black38
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            spacing: 5,
                            children: [
                              const Icon(Icons.timelapse, color: Colors.black38, size: 14,),
                              Text(
                                controller.courseDetail!.courseDetailPart.duration,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Wrap(
                        spacing: 5.0, 
                        children: [
                          if(controller.courseDetail!.courseDetailPart.tagData.isNotEmpty)
                            for (var tag in controller.courseDetail!.courseDetailPart.tagData.toString().trim().split("-")) 
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
                                  controller.random.nextInt(256),
                                  controller.random.nextInt(256),
                                  controller.random.nextInt(256),
                                  controller.random.nextDouble()
                                ),
                                autofocus: true,
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                              )
                            ],
                        ]
                      ),
                      const SizedBox(height: 15,),
                      SizedBox(
                        height: kToolbarHeight - 16,
                        child: TabBar(
                          unselectedLabelStyle:const TextStyle(color: Colors.blue),
                          labelStyle: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold
                          ),
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.yellow)
                          ),
                          tabs: const [
                            Tab(
                              child: Text(
                                "Lessons",
                                style: TextStyle(
                                  fontSize: 16, 
                                  color: Colors.black
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "More",
                                style: TextStyle(
                                  fontSize: 16, 
                                  color: Colors.black
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: TabBarView(
                    children: [
                      ChapterDetailWidget(isEnrolled: isEnrolled ?? false,),
                      const CourseDetailWidget(),
                    ],
                  ),
                ),
              ),
            ],
          )
          : const Center(
              child: CircularProgressIndicator(),
            )
          ),
        persistentFooterButtons: isEnrolled ?? false 
        ? null 
        : [ 
          FilledButton(
            onPressed: () async {
              await controller.enrollCourse(controller.courseDetail!.courseDetailPart.courseId.toString());
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black87,
              minimumSize: const Size(double.infinity, 40)
            ),
            child: const Text(
              'Start now',
              style: TextStyle(
                fontSize: 15,
                color: Colors.yellow,
                fontWeight: FontWeight.bold
              )
            ),
          ),
        ],
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
