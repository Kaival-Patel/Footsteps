import 'package:flutter/material.dart';
import 'package:footsteps/config/styling.dart';
import 'package:footsteps/screens/Portrait/ManageTracker.dart';
import 'package:footsteps/screens/Portrait/Notifications.dart';

class AddTrackersPage extends StatefulWidget {
  @override
  _AddTrackersPageState createState() => _AddTrackersPageState();
}

class _AddTrackersPageState extends State<AddTrackersPage> {
  List<Widget> pages = [ManageTracker(), Notifications()];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Manage Trackers"),
          bottom: TabBar(
            indicatorColor: Colors.white,
            onTap: (index) {
              print(index);
            },
            tabs: [
              Tab(
                icon: Icon(Icons.add_circle_outlined),                
                text: "Add Trackers",
              ),
              Tab(
                icon: Icon(Icons.notifications_active_outlined),
                text: "Notifications",
              ),
            ],
          ),
          backgroundColor: AppTheme.appDarkVioletColor,
        ),
        body: TabBarView(
          children: pages,
        ),
      ),
    );
  }
}
