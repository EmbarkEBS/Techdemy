import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tech/Widgets/courseDetail/chapter_detail_widget.dart';
import 'package:tech/Widgets/courseDetail/course_detail_widget.dart';
import 'package:tech/Widgets/courseDetail/tag_card_widget.dart';
import 'package:tech/controllers/course_controller.dart';
import 'package:tech/controllers/home_controller.dart';


class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({super.key,});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  
  String _paymentType = "full"; // default

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final bool isEnrolled = args['isEnrolled'] ?? false;
    final String title = args['title'] ?? '';
    final bool fromMyCourses = args["myCourse"] ?? false;
    final String? enrollId = args["enrollId"];

    return GetBuilder<CourseController>(
      builder: (controller) {
        String courseId = controller.courseDetail!.courseDetailPart.courseId.toString();
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(title),
            surfaceTintColor: Colors.transparent,
            actions: fromMyCourses && controller.courseDetail!.courseDetailPart.balance.isNotEmpty && controller.courseDetail!.courseDetailPart.balance != "0"
            ? [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(46, 34),
                    backgroundColor: Colors.blue.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(45)
                    ),
                  ),
                  onPressed: (){
                    _showPaymentOptions(
                      context: context, 
                      amount: int.tryParse(controller.courseDetail!.courseDetailPart.balance) ?? 0, 
                      courseId: courseId,
                      forFull: true,
                      amountPaid: int.tryParse(controller.courseDetail!.courseDetailPart.amountPaid) ?? 0,
                      enrollId: enrollId
                    );
                  }, 
                  child: Text("Pay ₹${controller.courseDetail!.courseDetailPart.balance}")
                ),
              )
            ]
            : null,
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
                              const SizedBox(height: 8.0,),
                              // Course title, duraion and price
                              ListTile(
                                titleAlignment: ListTileTitleAlignment.center,
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
                                subtitle: fromMyCourses
                                ? Row(
                                  children: [
                                    Text(
                                      controller.courseDetail!.courseDetailPart.paymentType.substring(0, 1).toUpperCase() + controller.courseDetail!.courseDetailPart.paymentType.substring(1),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black38
                                      ),
                                    ),
                                    Text(
                                      " (₹${controller.courseDetail!.courseDetailPart.amountPaid})",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black
                                      ),
                                    ),
                                  ],
                                )
                                : Text(
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
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
                                      fromMyCourses &&  controller.courseDetail!.courseDetailPart.status.isNotEmpty 
                                      ? Text(
                                          controller.courseDetail!.courseDetailPart.paymentType == "parital" ? "Partially Paid": "Paid",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: controller.courseDetail!.courseDetailPart.paymentType == "parital" ? Colors.orange : Colors.green,
                                            fontWeight: FontWeight.w600
                                          ),
                                        )
                                      : const SizedBox()
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
                          children: [
                            ChapterDetailWidget(isEnrolled: isEnrolled, enrollId: enrollId,),
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
                  return FilledButton(
                    onPressed: ()  {
                      _showPaymentOptions(context: context, amount: int.tryParse(controller.courseDetail!.courseDetailPart.price) ?? 1800, courseId: courseId);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black87,
                      minimumSize: const Size(double.infinity, 40)
                    ),
                    child: const Text(
                      'Pay now',
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


  void _showPaymentOptions({
    required BuildContext context, 
    required int amount, 
    required String courseId,
    bool? forFull,
    int? amountPaid,
    String? enrollId,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder( // lets us update radio inside dialog
          builder: (stactx, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8.0)
              ),
              title: const Text("Choose Payment Option", style: TextStyle(fontSize: 18),),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    activeColor: Colors.yellow,
                    fillColor: const WidgetStatePropertyAll(Colors.black),
                    title: const Text("Full Payment", style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                    subtitle: Text("₹$amount", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    value: "full",
                    groupValue: _paymentType,
                    onChanged: (val) {
                      setState(() {
                        _paymentType = val!;
                      });
                    },
                  ),
                  forFull == null
                  ? RadioListTile<String>(
                      title: const Text("Partial Payment",style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                      subtitle: Text("₹${(amount ~/ 2)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      value: "partial",
                      activeColor: Colors.yellow,
                      fillColor: const WidgetStatePropertyAll(Colors.black),
                      groupValue: _paymentType,
                      onChanged: (val) {
                        setState(() {
                          _paymentType = val!;
                        });
                      },
                    )
                  : const SizedBox(),
                ],
              ),
              actions: [
                GetBuilder<CourseController>(
                  id: "enrollBtn",
                  builder: (btnctr) {
                    final isLoading = btnctr.isEnrolling[courseId] ?? false;
                    return FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black87,
                        minimumSize: const Size(double.infinity, 40)
                      ),
                      onPressed: () async {
                        if(!isLoading){
                          btnctr.loadEnroll(courseId, true);
                          if(forFull == null) {
                            await btnctr.enrollCourse(
                              courseId: courseId, 
                              paymentType: _paymentType, 
                              paymentStatus: 'Success', 
                              amountPaid: _paymentType == "full" ? amount.toString() : (amount ~/ 2).toString(), 
                              balance: _paymentType == "full" ? "0" : (amount - (amount ~/ 2)).toString()
                            );
                          } else {
                            await btnctr.updateEnrollCourse(
                              enrollId: enrollId ?? "", 
                              paymentType: _paymentType, 
                              paymentStatus: 'Success', 
                              amountPaid: (amount + amountPaid!).toString(), 
                              balance:  "0"
                            );

                          }
                          btnctr.loadEnroll(courseId, false);
                          Navigator.pop(ctx);
                          Navigator.pop(context);
                          Get.find<HomeController>().changeIndex(1);
                        }
                      },
                      child: isLoading
                      ? const Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator()
                        ),
                      )
                      : const Text(
                        "Pay",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    );
                  }
                )
              ],
            );
          },
        );
      },
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
