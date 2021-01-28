import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PointsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Points Table"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[tableWidgetA(), tableWidgetB()],
        ),
      ),
    );
  }

  Widget tableWidgetA() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('points_tableA')
          .orderBy('points', descending: true)
          .snapshots(),
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
                    "",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text("Group A",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DataTable(
                    columnSpacing: 30,
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
                    rows: snapshot.data.docs
                        .map((itemRow) => DataRow(cells: [
                              DataCell(Text(itemRow.get('team_name'))),
                              DataCell(Text(
                                  itemRow.get('matches_played').toString())),
                              DataCell(Text(itemRow.get('won').toString())),
                              DataCell(Text(itemRow.get('loss').toString())),
                              DataCell(Text(itemRow.get('tie').toString())),
                              DataCell(Text(itemRow.get('points').toString()))
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
      stream: FirebaseFirestore.instance
          .collection('points_tableB')
          .orderBy('points', descending: true)
          .snapshots(),
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
                    columnSpacing: 30,
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
                    rows: snapshot.data.docs
                        .map((itemRow) => DataRow(cells: [
                              DataCell(Text(itemRow.get('team_name'))),
                              DataCell(Text(
                                  itemRow.get('matches_played').toString())),
                              DataCell(Text(itemRow.get('won').toString())),
                              DataCell(Text(itemRow.get('loss').toString())),
                              DataCell(Text(itemRow.get('tie').toString())),
                              DataCell(Text(itemRow.get('points').toString()))
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
}
