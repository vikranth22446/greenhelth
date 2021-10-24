import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_helth/Screens/badge_detection_screen.dart';
import 'package:green_helth/Screens/data_screen.dart';
import 'package:green_helth/Screens/home_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            child: TabBar(
                unselectedLabelColor:
                    Theme.of(context).colorScheme.primaryVariant,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).colorScheme.primaryVariant),
                tabs: [
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primaryVariant,
                            width: 1),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.home,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 50,
                          )),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color:
                                  Theme.of(context).colorScheme.primaryVariant,
                              width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.bar_chart,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
          body: TabBarView(
            children: [
              HomeScreen(),
              BadgeDetectionScreen(),
              DataScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
