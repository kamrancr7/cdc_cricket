import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatchEditScreen extends StatefulWidget {
  final matchId;
  final teamAId;
  final teamBId;
  final matchResult;

  MatchEditScreen(this.matchId, this.teamAId, this.teamBId, this.matchResult);

  @override
  _MatchEditScreenState createState() =>
      _MatchEditScreenState(matchId, teamAId, teamBId, matchResult);
}

class _MatchEditScreenState extends State<MatchEditScreen> {
  final _matchId;
  final _teamAId;
  final _teamBId;
  final _matchResult;
  int id = 0;

  final teamARunsCtr = TextEditingController();
  final teamBOversCtr = TextEditingController();

  final teamBRunsCtr = TextEditingController();
  final teamAOversCtr = TextEditingController();

  final matchResultCtr = TextEditingController();
  final matchStartedCtr = TextEditingController();

  final matchCommentaryCtr = TextEditingController();

  bool isBoundary = false;
  bool isWicket = false;
  bool isResult = false;


  _MatchEditScreenState(
      this._matchId, this._teamAId, this._teamBId, this._matchResult);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Edit Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              headingText('Match Commentary'),
              textFieldWidget('Commentary', matchCommentaryCtr),
              Row(
                children: [
                  Text('Boundary'),
                  Switch(
                    value: isBoundary,
                    onChanged: (value) {
                      isBoundary = value;
                      print(isBoundary);
                      setState(
                        () {},
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Wicket'),
                  Switch(
                    value: isWicket,
                    onChanged: (value) {
                      isWicket = value;
                      print(isWicket);
                      setState(
                        () {},
                      );
                    },
                  ),
                ],
              ),
              headingText('$_teamAId Data'),
              textFieldWidget('Team A Runs', teamARunsCtr),
              textFieldWidget('Team B Overs', teamBOversCtr),
              RaisedButton(
                child: Text('Update Team A'),
                onPressed: () {
                  updateScore('teamARuns',teamARunsCtr.text,'teamBOvers',teamBOversCtr.text);
                  if(matchCommentaryCtr.text.isNotEmpty){
                    addCommentary(id++,isBoundary,matchCommentaryCtr.text,isWicket);
                  }
                  setState(() {});
                },
              ),
              headingText('$_teamBId Data'),
              textFieldWidget('Team B Runs', teamBRunsCtr),
              textFieldWidget('Team A Overs', teamAOversCtr),
              RaisedButton(
                child: Text('Update Team B'),
                onPressed: () {
                  updateScore('teamBRuns',teamBRunsCtr.text,'teamAOvers',teamAOversCtr.text);
                  if(matchCommentaryCtr.text.isNotEmpty){
                    addCommentary(id++,isBoundary,matchCommentaryCtr.text,isWicket);
                  }
                  setState(() {});
                },
              ),
              headingText('Match Result'),
              textFieldWidget('Match Started', matchStartedCtr),
              Row(
                children: [
                  Text('Result'),
                  Switch(
                    value: isResult,
                    onChanged: (value) {
                      isResult = value;
                      print(isResult);
                      setState(
                            () {},
                      );
                    },
                  ),
                ],
              ),
              textFieldWidget('Result', matchResultCtr),
              RaisedButton(
                child: Text('Update Result'),
                onPressed: () {
                  updateResult(matchResultCtr.text,isResult,matchStartedCtr.text);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFieldWidget(hintTextValue, controllerValue) {
    return TextField(
      decoration:
          InputDecoration(border: InputBorder.none, hintText: hintTextValue),
      controller: controllerValue,
    );
  }

  Widget headingText(headingText) {
    return Text(
      headingText,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }

  Future<void> updateScore(teamBatting, runs, teamBowling, overs) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('/schedule/$_matchId/match_details');
    return users
        .doc('matchDoc')
        .update({
          teamBatting: runs,
          teamBowling: overs,
        })
        .then((value) => print("Data Updated"))
        .catchError((error) => print("Failed to update data: $error"));
  }

  Future<void> addCommentary(id,boundary,cmnt,wicket) {
    DocumentReference users = FirebaseFirestore.instance
        .collection('/schedule/$_matchId/match_details/matchDoc/commentary')
        .doc();
    return users
        .set({
          'boundary': boundary,
          'cmnt': cmnt,
          'id': id,
          'wicket': wicket
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateResult(result,boolResult,matchStarted) {
    CollectionReference users =
    FirebaseFirestore.instance.collection('/schedule');
    return users
        .doc(_matchId)
        .update({
      'matchResult': result,
      'result':boolResult,
      'matchStarted':matchStarted
    })
        .then((value) => print("Data Updated"))
        .catchError((error) => print("Failed to update data: $error"));
  }
}
