import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'team_model.dart';

class Teams extends StatefulWidget {
  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Details'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: teamData.length,
        itemBuilder: (context, i) => Card(
          elevation: 2,
          child: ExpansionTile(
            leading: Icon(
              Icons.people_alt,
              color: Colors.blue[900],
            ),
            title: Text(
              teamData[i].name,
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[
              teamsList(teamData[i].id),
            ],
          ),
        ),
      ),
    );
  }

  Widget teamsList(teamId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('/cdc_teams/$teamId/players')
          .orderBy('id', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, i) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: <Widget>[
                        snapshot.data.docs[i]['keeper']
                            ? Container(
                                height: 20,
                                width: 20,
                                child: Image.asset("assets/keeper.png"),
                              )
                            : snapshot.data.docs[i]['bowler']
                                ? Container(
                                    height: 20,
                                    width: 20,
                                    child: Image.asset("assets/ball.png"),
                                  )
                                : snapshot.data.docs[i]['allrounder']
                                    ? Container(
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            "assets/allrounder.png"),
                                      )
                                    : snapshot.data.docs[i]['batsman']
                                        ? Container(
                                            height: 20,
                                            width: 20,
                                            child:
                                                Image.asset("assets/bat.png"),
                                          )
                                        : Container(),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          snapshot.data.docs[i]['name'],
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 10.0,
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
