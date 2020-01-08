import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatchDetails extends StatefulWidget {
  final matchId;
  final teamAId;
  final teamBId;

  MatchDetails(this.matchId, this.teamAId, this.teamBId);

  @override
  _MatchDetailsState createState() =>
      _MatchDetailsState(matchId, teamAId, teamBId);
}

class _MatchDetailsState extends State<MatchDetails> {
  final _matchId;
  final _teamAId;
  final _teamBId;
  _MatchDetailsState(this._matchId, this._teamAId, this._teamBId);
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
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        snapshot.data.documents[0]["teamA"],
                        style: TextStyle(fontSize: 22),
                      ),
                      //runsOver(snapshot.data.documents[0]["teamARuns"].toString(),snapshot.data.documents[0]["teamBOvers"].toString()),
                      Text(
                        snapshot.data.documents[0]["teamARuns"],
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        snapshot.data.documents[0]["teamB"],
                        style: TextStyle(fontSize: 22),
                      ),
                      //runsOver(snapshot.data.documents[0]["teamBRuns"].toString(),snapshot.data.documents[0]["teamAOvers"].toString()),
                      Text(
                        snapshot.data.documents[0]["teamBRuns"],
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18,
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
                            //makeTeamDetailTab(),
                            teamPlayersTab(_teamAId, _teamBId),
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
                          Text(
                            snapshot.data.documents[i]['cmnt'],
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ));
        }
      },
    );
  }

  Widget teamPlayersTab(teamAId, teamBId) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[teamList(teamAId), teamList(teamBId)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget teamList(teamId) {
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
              child: ListView.builder(
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
                                            child:
                                                Image.asset("assets/ball.png"),
                                          )
                                        : snapshot.data.documents[i]
                                                ['allrounder']
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
                                SizedBox(width: 4,),
                                Text(snapshot.data.documents[i]['name'],style: TextStyle(fontSize: 10),),
                              ],
                            ),
                          )
                        ],
                      )),
            );
        }
      },
    );
  }

  Widget playerRole(batsman, bowler, allrounder, keeper) {}
}
