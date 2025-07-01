import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:tech/Widgets/drawer_widget.dart';
import 'package:tech/Widgets/mycourses/completed_courses.dart';
import 'package:tech/Widgets/mycourses/on_going_courses.dart';

class MyCoursesPage extends StatelessWidget {
  const MyCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      drawer: const DrawerWidget(isMyCourse: true,),
      body: DefaultTabController(
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
            const Expanded(
              child: TabBarView(
                children: <Widget>[
                  OnGoingCourses(),
                  CompletedCourses()
                ],
              ),
            ),
          ],
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
