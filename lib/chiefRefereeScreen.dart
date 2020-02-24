import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:irc_prelim/signaturePad.dart';
import 'modelClasses.dart';
import 'constants.dart' as constants;
import 'package:expandable/expandable.dart';

class ChiefRefereeScreen extends StatefulWidget {
  final ParticipatingEmployee participatingEmployee;

  const ChiefRefereeScreen(this.participatingEmployee);
  @override
  _ChiefRefereeScreenState createState() => _ChiefRefereeScreenState();
}

class _ChiefRefereeScreenState extends State<ChiefRefereeScreen> {
  int index = 0;
  PageController controller = PageController();
  _onItemTapped(int index) {
    setState(() {
      this.index = index;
      controller.animateToPage(index,
          duration: Duration(seconds: 1), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
        actions: <Widget>[
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this.index,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.shifting,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            title: Text("Junior"),
            activeIcon: Icon(
              FontAwesome5Solid.baby,
              color: Colors.white,
            ),
            icon: Icon(FontAwesome5Solid.baby),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            title: Text("Middle"),
            activeIcon: Icon(
              FontAwesome.child,
              color: Colors.white,
            ),
            icon: Icon(
              FontAwesome.child,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            title: Text("Senior"),
            activeIcon: Icon(
              FontAwesome5Solid.male,
              color: Colors.white,
            ),
            icon: Icon(FontAwesome5Solid.male),
          ),
        ],
      ),
      body: PageView(
        controller: controller,
        onPageChanged: (value) {
          setState(() {
            this.index = value;
          });
        },
        children: <Widget>[
          GetDataForTeams("junior", widget.participatingEmployee),
          GetDataForTeams("middle", widget.participatingEmployee),
          GetDataForTeams("senior", widget.participatingEmployee),
        ],
      ),
    );
  }
}

class GetDataForTeams extends StatefulWidget {
  final String level;
  final ParticipatingEmployee participatingEmployee;

  const GetDataForTeams(this.level, this.participatingEmployee);
  @override
  _GetDataForTeamsState createState() => _GetDataForTeamsState();
}

class _GetDataForTeamsState extends State<GetDataForTeams> {
  String queryLevel;
  Stream stream;
  String _defineLevel() {
    if (widget.level == "junior") {
      queryLevel = "junior";
    } else if (widget.level == "middle") {
      queryLevel = "middle";
    } else if (widget.level == "senior") {
      queryLevel = "senior";
    }
    return null;
  }

  @override
  void initState() {
    _defineLevel();
    stream = Firestore.instance
        .collection("teams")
        .where("eventId", isEqualTo: widget.participatingEmployee.eventId)
        .where("level", isEqualTo: widget.level)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return Center(child: Container(child: CircularProgressIndicator()));
        } else if (snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData) {
          print(snapshot.data);
          QuerySnapshot querySnapshot = snapshot.data;
          var list =
              querySnapshot.documents.map((f) => Team.fromMap(f.data)).toList();
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  child: Card(
                    color: getColorForChiefReferee(
                        list[index].registration,
                        list[index].verification,
                        list[index].isConflicted,
                        list[index].run),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(
                        "${list[index].teamName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w300,
                            fontSize: 30),
                      ),
                      isThreeLine: true,
                      leading: Icon(MaterialIcons.people),
                      subtitle: ExpandablePanel(
                        header: Text("Details"),
                        expanded: DataTable(
                          rows: <DataRow>[
                            DataRow(cells: <DataCell>[
                              DataCell(Text(
                                "Registration",
                                style: constants.tableTextStyle,
                              )),
                              DataCell(Text(
                                  "${(list[index].registration) ? "Done" : "Pending"}",
                                  style: constants.tableTextStyle)),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(
                                Text("Verification",
                                    style: constants.tableTextStyle),
                              ),
                              DataCell(Text(
                                  "${(list[index].verification) ? "Done" : "Pending"}",
                                  style: constants.tableTextStyle)),
                            ]),
                            DataRow(cells: <DataCell>[
                              DataCell(Text("Arena Run",
                                  style: constants.tableTextStyle)),
                              DataCell(Text(
                                  "${(list[index].run) ? "Done" : "Pending"}",
                                  style: constants.tableTextStyle)),
                            ])
                          ],
                          columns: <DataColumn>[
                            DataColumn(
                              label: Text("Label"),
                            ),
                            DataColumn(label: Text("Status"))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        return Center(
            child: Container(
                child: Text("Something went wrong ! ,Please contact team ")));
      },
    );
  }

  Color getColorForChiefReferee(
      bool registration, bool verification, bool isConflicted, bool run) {
    if (registration && !verification && !isConflicted && !run) {
      return Colors.green;
    } else if (registration && verification && !isConflicted && !run) {
      return Colors.amber;
    } else if (run && registration && verification && !isConflicted) {
      return Colors.blue;
    } else if (run && registration && verification && isConflicted) {
      return Colors.deepOrange;
    } else if (!registration && (verification || run)) {
      return Colors.red;
    } else if (!verification && run) {
      return Colors.red;
    } else {
      return Colors.blueGrey;
    }
  }
}
