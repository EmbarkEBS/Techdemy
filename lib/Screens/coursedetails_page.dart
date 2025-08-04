import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Widgets/courseDetail/chapter_detail_widget.dart';
import 'package:tech/Widgets/courseDetail/course_detail_widget.dart';
import 'package:tech/Widgets/courseDetail/tag_card_widget.dart';
import 'package:tech/controllers/course_controller.dart';
import 'package:tech/controllers/home_controller.dart';


class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final bool isEnrolled = args['isEnrolled'] ?? false;
    final String title = args['title'] ?? '';
    return GetBuilder<CourseController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(title),
            surfaceTintColor: Colors.transparent,
          ),
          body: DefaultTabController(
            length: 2,
            child: controller.courseDetail != null
              ? Column(
                children: [
                   SizedBox(
                    height: 200,
                     child: CachedNetworkImage(
                      imageUrl: controller.courseDetail!.courseDetailPart.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(image: imageProvider)
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200
                          ),
                          child: const Center(
                            child: Icon(Icons.error),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: NestedScrollView(
                      controller: controller.scrollController,
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Course title, duraion and price
                              ListTile(
                                titleAlignment: ListTileTitleAlignment.top,
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                                title: Text(
                                  controller.courseDetail!.courseDetailPart.name,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  ),
                                ),
                                subtitle: Text(
                                  controller.courseDetail!.courseDetailPart.price == "free" 
                                  ? controller.courseDetail!.courseDetailPart.price
                                  : "₹${controller.courseDetail!.courseDetailPart.price}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black38
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
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
                                ),
                              ),
                              // Course tags
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Wrap(
                                  spacing: 8.0,
                                  children: controller.courseDetail!.courseDetailPart.tagData
                                    .split("-")
                                    .map((tag) {
                                      return TagCardWidget(
                                        color: Color.fromARGB(
                                          255, 
                                          controller.random.nextInt(256), 
                                          controller.random.nextInt(256), 
                                          controller.random.nextInt(256), 
                                        ), 
                                        tag: tag
                                      );
                                    },)
                                  .toList(),
                                ),
                              ),
                              const SizedBox(height: 8.0,),
                            ],
                          ),
                        ),
                        // Tabbar headers
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: MySliverPersistentHeaderDelegate(
                            const TabBar(
                              isScrollable: true,
                              indicatorSize: TabBarIndicatorSize.label,
                              tabAlignment: TabAlignment.start,
                              unselectedLabelStyle:TextStyle(color: Colors.blue),
                              labelStyle: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold
                              ),
                              indicatorColor: Colors.yellow,
                              tabs: [
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
                        ),   
                      ],
                      // Tabbar views
                      body: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: TabBarView(
                          // controller: _tabController,
                          children: [
                            ChapterDetailWidget(isEnrolled: isEnrolled,),
                            const CourseDetailWidget(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : const Center(
                  child: CircularProgressIndicator(),
                )
              ),
          persistentFooterButtons: isEnrolled 
            ? null 
            : [ 
              GetBuilder<CourseController>(
                id: "enrollBtn",
                builder: (btnctr) {
                  String courseId = btnctr.courseDetail!.courseDetailPart.courseId.toString();
                  final isLoading = btnctr.isEnrolling[courseId] ?? false;
                  return FilledButton(
                    onPressed: () async {
                      if(!isLoading){
                        btnctr.loadEnroll(courseId, true);
                        await btnctr.enrollCourse(courseId);
                        btnctr.loadEnroll(courseId, false);
                        Navigator.pop(context);
                        Get.find<HomeController>().changeIndex(1);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black87,
                      minimumSize: const Size(double.infinity, 40)
                    ),
                    child: isLoading 
                    ? const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.yellow,
                        ),
                      ),
                    )
                    : const Text(
                      'Start now',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  );
                }
              ),
            ],
        );
      }
    );
  
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  MySliverPersistentHeaderDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: kToolbarHeight,
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
