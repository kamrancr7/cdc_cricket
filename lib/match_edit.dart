import 'package:cdc_cricket/match_edit__screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatchEdit extends StatefulWidget {
  @override
  _MatchEditState createState() => _MatchEditState();
}

class _MatchEditState extends State<MatchEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Match'),
      ),
      body: homeWidget(),
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
                                    ClipRRect(
                                      child: Image.network(
                                        snapshot.data.documents[i]
                                        ['teamAShort'],
                                        height: 70,
                                        width: 70,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(30),
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
                                    ClipRRect(
                                      child: Image.network(
                                        snapshot.data.documents[i]
                                        ['teamBShort'],
                                        height: 70,
                                        width: 70,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(30),
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
                           RaisedButton(
                              onPressed: () {
                                print(snapshot
                                    .data.documents[i].documentID);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MatchEditScreen(
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
}
