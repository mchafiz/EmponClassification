import 'package:flutter/material.dart';
import 'package:skripsi/tabview/lengkuas/Kandungan.dart';
import 'package:skripsi/tabview/lengkuas/Tentang.dart';


class Info4 extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<Info4>
    with AutomaticKeepAliveClientMixin<Info4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 250.0,
                  backgroundColor: Colors.yellowAccent,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text("Empon-empon Lengkuas".toUpperCase(),
                      
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize: 16.0,
                          )),
                      background: Image.asset(
                        'assets/images/lengkuas.jpg',
                        fit: BoxFit.cover,
                      )),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: Colors.black87,
                      indicatorColor: Colors.deepOrange,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          text: "Tentang Lengkuas",
                        ),
                        Tab(text: "Kandungan Lengkuas"),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: new Container(
                padding: new EdgeInsets.all(10.0),
                child: new TabBarView(children: <Widget>[
                  new Tentang(),
                  new Kandungan(),
                ]))),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
