import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  int currentIndex = 0;

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CDC Cricket"),
      ),
        bottomNavigationBar: BubbleBottomBar(
            opacity: .2,
            currentIndex: currentIndex,
            onTap: changePage,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            elevation: 8,
            //fabLocation: BubbleBottomBarFabLocation.end, //new
            hasNotch: true, //new
            hasInk: true ,//new, gives a cute ink effect
            inkColor: Colors.black12 ,//optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(backgroundColor: Colors.red, icon: Icon(Icons.home, color: Colors.black,), activeIcon: Icon(Icons.home, color: Colors.red,), title: Text("Home")),
      BubbleBottomBarItem(backgroundColor: Colors.deepPurple, icon: Icon(Icons.table_chart, color: Colors.black,), activeIcon: Icon(Icons.table_chart, color: Colors.deepPurple,), title: Text("Table")),
      BubbleBottomBarItem(backgroundColor: Colors.indigo, icon: Icon(Icons.location_on, color: Colors.black,), activeIcon: Icon(Icons.location_on, color: Colors.indigo,), title: Text("Map")),
      ],
    ),
        body: currentIndex == 0
            ? homeWidget()
            : currentIndex == 1 ? tableWidget() : mapWidget(),
        );
  }

  Widget homeWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('schedule').orderBy('matchNo',descending: false).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return ListView.builder(itemCount: snapshot.data.documents.length,
                itemBuilder: (context,i) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(snapshot.data.documents[i]['matchType'],
                        style: TextStyle(fontSize: 16),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(snapshot.data.documents[i]['teamA'],
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            Text("vs",
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            Text(snapshot.data.documents[i]['teamB'],
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          ],
                        ),
                        snapshot.data.documents[i]['toss'] ? Text("test") :
                            Text("Match start soon")
                      ],
                    ),
                  ),
                ));
//              ListView(
//              children: snapshot.data.documents.map((DocumentSnapshot document) {
//                return ListTile(
//                  title: Text(document['teamA']),
//                  subtitle: Text(document['teamB']),
//                );
//              }).toList(),
//            );
        }
      },
    );
  }

  Widget tableWidget() {
    return Center(
      child: Text("Table"),
    );
  }

  Widget mapWidget() {
    return Center(
      child: Text("Map"),
    );
  }
}
