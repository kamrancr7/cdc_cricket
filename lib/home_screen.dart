import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'match_details.dart';
import 'package:intl/intl.dart';
import 'points_table.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: Container(
            width: 270,
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    height: 150,
                    child: DrawerHeader(
                      child: Image.asset(
                        'assets/cdc_logo.jpg',
                      ),
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.people),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Teams'),
                      ],
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, "/team_screen");
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.table_chart),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Points Table'),
                      ],
                    ),
                    onTap: () {
                      // Update the state of the app
                      Navigator.popAndPushNamed(context, "/points_table");
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) => PointsTable()
                      //     )
                      // );
                      // Then close the drawer
                      //Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Map'),
                      ],
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, "/map_screen");
                    },
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text('All'),
                ),
                Tab(
                  child: Text('Live'),
                ),
                Tab(
                  child: Text('Results'),
                ),
              ],
            ),
            title: Row(
              children: [
                // Image.asset(
                //   'assets/cdc_logo.jpg',
                //   height: 30,
                //   width: 30,
                // ),

                Text('CDC Cricket Tournament'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TabBarView(
              children: [
                homeWidget('N'),
                homeWidget('Y'),
                homeWidget('C'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget homeWidget(matchStarted) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('schedule')
          .where('matchStarted', isEqualTo: matchStarted)
          //.orderBy('matchNo', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 17,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            children: <Widget>[
                              Text(
                                snapshot.data.documents[i]['matchType'],
                                style: TextStyle(fontSize: 16),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.blue[900],
                                          radius: 22,
                                          child: Text(
                                            snapshot.data.documents[i]
                                                ['teamAShort'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          snapshot.data.documents[i]['teamA'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        "vs",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.blue[900],
                                          radius: 22,
                                          child: Text(
                                              snapshot.data.documents[i]
                                                  ['teamBShort'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: Colors.white)),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          snapshot.data.documents[i]['teamB'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // snapshot.data.documents[i]['toss']
                              //     ? Text(
                              //         snapshot.data.documents[i]['tossResult'],
                              //         style: TextStyle(color: Colors.grey),
                              //       )
                              //     : snapshot.data.documents[i]['result']
                              //         ? Text(
                              //             snapshot.data.documents[i]
                              //                 ['matchResult'],
                              //             style: TextStyle(color: Colors.grey),
                              //           )
                              //         : startDate(snapshot
                              //             .data.documents[i]['startTime']
                              //             .toDate()),
                              matchStarted == 'N'
                                  ? Text('Match Starts Soon')
                                  : RaisedButton(
                                      onPressed: () {
                                        print(snapshot
                                            .data.documents[i].documentID);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MatchDetails(
                                              snapshot
                                                  .data.documents[i].documentID,
                                              snapshot.data.documents[i]
                                                  ['teamAId'],
                                              snapshot.data.documents[i]
                                                  ['teamBId'],
                                              snapshot.data.documents[i]
                                                  ['matchResult'],
                                            ),
                                          ),
                                        );
                                      },
                                      color: Colors.blue[900],
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.0),
                                      ),
                                      child: Text('Match Details')
                                      // Text(
                                      //   "Match Details",
                                      //   style: TextStyle(
                                      //       color: Colors.indigo[500],
                                      //       decoration: TextDecoration.underline),
                                      // ),
                                      )
                            ],
                          ),
                        ),
                      ),
                    ));
        }
      },
    );
  }

  Widget startDate(startDate) {
    var formatter = new DateFormat('dd/MM/yyyy hh:mm');
    String formatted = formatter.format(startDate);
    return Text(
      formatted,
      style: TextStyle(color: Colors.grey),
    );
  }
}
