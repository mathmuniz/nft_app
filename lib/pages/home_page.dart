import 'package:flutter/material.dart';
import 'package:nft_app/components/my_appbar.dart';
import 'package:nft_app/components/my_bottombar.dart';
import 'package:nft_app/components/my_tabbar.dart';
import 'package:nft_app/tabs/recent_tab.dart';
import 'package:nft_app/tabs/top_tab.dart';
import 'package:nft_app/tabs/trending_tab.dart';
import 'package:nft_app/theme/glass_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // search button tapped
  void _searchButtonTapped() {}

  // our 3 tab options
  List tabOptions = const [
    ['Recent', RecentTab()],
    ['Trending', TrendingTab()],
    ['Top', TopTab()],
  ];

  //bottom bar navigation
  int _currentBottomIndex = 0;
  void _handleBottomIndexChange(int? index) {
    setState(() {
      _currentBottomIndex = index!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabOptions.length,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        extendBody: true,
        bottomNavigationBar: GlassBox(
          child: MyBottomBar(
            index: _currentBottomIndex,
            onTap: _handleBottomIndexChange,
          ),
        ),
        body: ListView(
          children: [
            // app bar + search button
            MyAppBar(
              title: 'Explore Collections',
              onTap: _searchButtonTapped,
            ),

            // tab bar
            SizedBox(
              height: 600,
              child: MyTabBar(
                tabOptions: tabOptions,
              ),
            )
          ],
        ),
      ),
    );
  }
}
