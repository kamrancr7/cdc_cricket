import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatchDetails extends StatefulWidget {
  final matchId;
  final teamAId;
  final teamBId;
  final matchResult;

  MatchDetails(this.matchId, this.teamAId, this.teamBId, this.matchResult);

  @override
  _MatchDetailsState createState() =>
      _MatchDetailsState(matchId, teamAId, teamBId, matchResult);
}

class _MatchDetailsState extends State<MatchDetails> {
  final _matchId;
  final _teamAId;
  final _teamBId;
  final _matchResult;
  _MatchDetailsState(
      this._matchId, this._teamAId, this._teamBId, this._matchResult);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Match Details"),
      ),
      body: header(),
    );
  }

  Widget header() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('/schedule/$_matchId/match_details')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                teamName(
                                  snapshot.data.documents[0]["teamA"],
                                ),
                                teamRunsOvers(
                                  snapshot.data.documents[0]["teamARuns"],
                                  snapshot.data.documents[0]["teamBOvers"],
                                  snapshot.data.documents[0]["totalOvers"],
                                ),
                                // Text(
                                //   snapshot.data.documents[0]["teamARuns"],
                                //   style: TextStyle(fontSize: 18),
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                teamName(snapshot.data.documents[0]["teamB"]),
                                teamRunsOvers(
                                  snapshot.data.documents[0]["teamBRuns"],
                                  snapshot.data.documents[0]["teamAOvers"],
                                  snapshot.data.documents[0]["totalOvers"],
                                ),
                                // Text(
                                //   snapshot.data.documents[0]["teamBRuns"],
                                //   style: TextStyle(fontSize: 20),
                                // ),
                              ],
                            ),
                          ),
                          Text(
                            _matchResult,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        appBar: TabBar(
                          labelColor: Color(0xff2c2840),
                          tabs: [
                            Tab(text: "Live"),
                            Tab(text: "Team Details"),
                          ],
                        ),
                        body: TabBarView(
                          children: [
                            matchCommentaryTab(
                                snapshot.data.documents[0].documentID),
                            teamPlayersTab(
                                _teamAId,
                                snapshot.data.documents[0]["teamA"],
                                _teamBId,
                                snapshot.data.documents[0]["teamB"]),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
        }
      },
    );
  }

  Widget matchCommentaryTab(id) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('/schedule/$_matchId/match_details/$id/commentary')
          .orderBy('id', descending: true)
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          commentaryText(
                              snapshot.data.documents[i]['boundary'],
                              snapshot.data.documents[i]['wicket'],
                              snapshot.data.documents[i]['cmnt']),
                        ],
                      ),
                    ));
        }
      },
    );
  }

  Widget commentaryText(bool boundary, bool wicket, cmnt) {
    return boundary
        ? Text(
            cmnt,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )
        : wicket
            ? Text(
                cmnt,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              )
            : Text(
                cmnt,
                style: TextStyle(fontSize: 15),
              );
  }

  Widget teamPlayersTab(teamAId, teamAName, teamBId, teamBName) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    teamList(teamAId, teamAName),
                    teamList(teamBId, teamBName)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget teamList(teamId, teamName) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('/cdc_teams/$teamId/players')
          .orderBy('id', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container();
          default:
            return Expanded(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      teamName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, i) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: <Widget>[
                              snapshot.data.documents[i]['keeper']
                                  ? Container(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset("assets/keeper.png"),
                                    )
                                  : snapshot.data.documents[i]['bowler']
                                      ? Container(
                                          height: 20,
                                          width: 20,
                                          child: Image.asset("assets/ball.png"),
                                        )
                                      : snapshot.data.documents[i]['allrounder']
                                          ? Container(
                                              height: 20,
                                              width: 20,
                                              child: Image.asset(
                                                  "assets/allrounder.png"),
                                            )
                                          : snapshot.data.documents[i]
                                                  ['batsman']
                                              ? Container(
                                                  height: 20,
                                                  width: 20,
                                                  child: Image.asset(
                                                      "assets/bat.png"),
                                                )
                                              : Container(),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                snapshot.data.documents[i]['name'],
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
        }
      },
    );
  }

  Widget teamName(name) {
    return Text(
      name,
      style: TextStyle(fontSize: 18),
    );
  }

  Widget teamRunsOvers(runs, overs, totalOvers) {
    return Column(
      children: [
        Text(
          runs,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          '(' + overs + '/' + totalOvers + ' overs)',
          style: TextStyle(fontSize: 12),
        )
      ],
    );
  }
}
