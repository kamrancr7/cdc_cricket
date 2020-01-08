import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:auro_avatar/auro_avatar.dart';
import 'match_details.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  int currentIndex = 0;
  GoogleMapController mapController;
  static final CameraPosition _myLocation = CameraPosition(
    target: LatLng(24.9410254, 67.1103504),
  );
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addMarker();
  }

  void _addMarker() {
    final MarkerId markerId = MarkerId("Karachi");
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(24.9410254, 67.1103504),
      infoWindow: InfoWindow(title: "IBA Cricket Ground", snippet: "Karachi"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

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
        hasInk: true, //new, gives a cute ink effect
        inkColor: Colors.black12, //optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.home,
                color: Colors.red,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.table_chart,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.table_chart,
                color: Colors.deepPurple,
              ),
              title: Text("Table")),
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(
                Icons.location_on,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.location_on,
                color: Colors.indigo,
              ),
              title: Text("Map")),
        ],
      ),
      body: currentIndex == 0
          ? homeWidget()
          : currentIndex == 1
              ? SingleChildScrollView(
                  child: Column(
                    children: <Widget>[tableWidgetA(), tableWidgetB()],
                  ),
                )
              : mapWidget(),
    );
  }

  Widget homeWidget() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('schedule')
          .orderBy('matchNo', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, i) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              snapshot.data.documents[i]['matchType'],
                              style: TextStyle(fontSize: 16),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.indigo[500],
                                        radius: 25,
                                        child: Text(
                                          snapshot.data.documents[i]
                                              ['teamAShort'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                          fontSize: 18,color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(height: 4,),
                                      Text(
                                        snapshot.data.documents[i]['teamA'],
                                        style: TextStyle(
                                            fontSize: 18,
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
                                        backgroundColor: Colors.indigo[500],
                                        radius: 25,
                                        child: Text(snapshot.data.documents[i]
                                            ['teamBShort'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                            fontSize: 18,color: Colors.white)),
                                      ),
                                      SizedBox(height: 4,),
                                      Text(
                                        snapshot.data.documents[i]['teamB'],
                                        style: TextStyle(
                                            fontSize: 18,
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
                            snapshot.data.documents[i]['toss']
                                ? Text(
                                    snapshot.data.documents[i]['tossResult'],
                                    style: TextStyle(color: Colors.grey),
                                  )
                                : startDate(snapshot
                                    .data.documents[i]['startTime']
                                    .toDate()),
                            FlatButton(
                              onPressed: () {
                                print(snapshot.data.documents[i].documentID);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MatchDetails(
                                            snapshot
                                                .data.documents[i].documentID,
                                            snapshot.data.documents[i]
                                                ['teamAId'],
                                            snapshot.data.documents[i]
                                                ['teamBId'])));
                              },
                              child: Text(
                                "Match Details",
                                style: TextStyle(
                                    color: Colors.indigo[500],
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                      ),
                    ));
        }
      },
    );
  }

  Widget tableWidgetA() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('points_tableA').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                    child: Text(
                  "Points Table",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
                SizedBox(
                  height: 15,
                ),
                Text("Group A",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DataTable(
                    columnSpacing: 7,
                    columns: [
                      DataColumn(
                        label: Center(
                          child: Text("Teams",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text("MP",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text("W",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text("L",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text("T",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text("P",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                    rows: snapshot.data.documents
                        .map((itemRow) => DataRow(cells: [
                              DataCell(Text(itemRow.data['team_name'])),
                              DataCell(Text(
                                  itemRow.data['matches_played'].toString())),
                              DataCell(Text(itemRow.data['won'].toString())),
                              DataCell(Text(itemRow.data['loss'].toString())),
                              DataCell(Text(itemRow.data['tie'].toString())),
                              DataCell(Text(itemRow.data['points'].toString()))
                            ]))
                        .toList(),
                  ),
                ),
              ],
            );
        }
      },
    );
  }

  Widget tableWidgetB() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('points_tableB').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Text("Group B",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DataTable(
                    columnSpacing: 7,
                    columns: [
                      DataColumn(
                        label: Center(
                          child: Text(
                            "Teams",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text("MP",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text("W",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text("L",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text("T",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      DataColumn(
                        label: Center(
                          child: Text("P",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                    rows: snapshot.data.documents
                        .map((itemRow) => DataRow(cells: [
                              DataCell(Text(itemRow.data['team_name'])),
                              DataCell(Text(
                                  itemRow.data['matches_played'].toString())),
                              DataCell(Text(itemRow.data['won'].toString())),
                              DataCell(Text(itemRow.data['loss'].toString())),
                              DataCell(Text(itemRow.data['tie'].toString())),
                              DataCell(Text(itemRow.data['points'].toString()))
                            ]))
                        .toList(),
                  ),
                ),
              ],
            );
        }
      },
    );
  }

  Widget mapWidget() {
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          mapType: MapType.normal,
          zoomGesturesEnabled: true,
          compassEnabled: true,
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          markers: Set<Marker>.of(markers.values),
          initialCameraPosition:
              CameraPosition(target: LatLng(24.9410254, 67.1103504), zoom: 15),
        ),
        SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  elevation: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "CDC House Cricket Tournament",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo[500]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "IBA Cricket Ground",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ))
      ],
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
