import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:movies/models/hive_nowplaying.dart';
import 'package:movies/modules/Now_Playing_Screen.dart';

import 'package:movies/modules/populer_screen.dart';
import 'package:movies/modules/top_rated_screen.dart';
import 'package:movies/shared/network/local/cache.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State createState() {
    return new HomeWidgetState();
  }
}

class HomeWidgetState extends State with SingleTickerProviderStateMixin {
  final List<Widget> tabs = [
    new Tab(
      text: "Now Playing",
    ),
    new Tab(
      text: "Popular",
    ),
    new Tab(
      text: "Top Rated",
    )
  ];

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  showLoadingIndecator() {
    return Center(
      child: CircularProgressIndicator(color: Colors.blue),
    );
  }

  Widget buildNoInternetWidget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Can\'t connect.. Check Internet!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Image.asset('assets/images/nointernet.png'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFf7f7f7),
      appBar: new AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Movies',
            style: TextStyle(
                fontSize: 20, fontFamily: 'Jannah', color: Colors.black)),
        bottom: new TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: new BubbleTabIndicator(
            indicatorHeight: 30,
            indicatorColor: Colors.blueAccent,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          tabs: tabs,
          controller: _tabController,
        ),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            return new TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                NowPlayingScreen(
                  connected: true,
                ),
                PopulerScreen(),
                TopRatedScreen(),
              ],
            );
          } else {
            return new TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                NowPlayingScreen(
                  connected: false,
                ),
                buildNoInternetWidget(),
                buildNoInternetWidget()
              ],
            );
          }
        },
        child: showLoadingIndecator(),
      ),
    );
  }
}
