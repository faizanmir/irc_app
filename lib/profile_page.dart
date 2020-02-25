import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:irc_prelim/event_run_sheet.dart';
import 'model_classes.dart';
import 'constants.dart';

class ProfilePage extends StatefulWidget {
  final ParticipatingEmployee employee;
  const ProfilePage(this.employee);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String scanResult = "";
  String updateStatus;
  String role;

  void makeChoiceForResults() async {
    try {
      scanResult = await BarcodeScanner.scan();
      print(scanResult);
    } catch (e) {
      print(e);
    }

    if (widget.employee.isReferee) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ScoringScreen(scanResult)));
    } else {
      QuerySnapshot qs = await Firestore.instance
          .collection("teams")
          .where("tid", isEqualTo: scanResult)
          .getDocuments();
      var result = qs.documents.map((f) => Team.fromMap(f.data)).toList();
      Map<String, bool> map = new Map();
      map[updateStatus.toLowerCase()] = true;
      await Firestore.instance
          .collection("teams")
          .document(result.first.tid)
          .updateData(map);
    }
  }

  @override
  void initState() {
    role = _getRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }

  String _getRole() {
    if (widget.employee.isInVandC) {
      updateStatus = "verification";
      return "Verification and Collection";
    } else if (widget.employee.isInRegistration) {
      updateStatus = "registration";
      return "Registration";
    } else if (widget.employee.isReferee) {
      updateStatus = "run";
      return "Referee";
    } else if (widget.employee.isFieldLeader) {
      return "Field-Leader";
    } else if (widget.employee.isChiefReferee) {
      return "Chief-Referee";
    }
    return "Error";
  }

  Widget body() {
    return Container(
        decoration: appGradient,
        child: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            brightness: Brightness.dark,
            floating: true,
            pinned: false,
            snap: false,
            stretch: true,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: IconButton(
                  icon: Icon(MaterialIcons.camera),
                  onPressed: () {
                    makeChoiceForResults();
                  },
                  iconSize: 50,
                  tooltip: "Scan team",
                ),
              )
            ],
            expandedHeight: 250.0,
            titleSpacing: 10,
            centerTitle: true,
            backgroundColor: Colors.blueGrey[900],
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.all(10),
                title: Container(
                  height: 30,
                  child: Column(
                    children: <Widget>[
                      Text(
                        role,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 20),
                      )
                    ],
                  ),
                )),
            title: Text(
              "${widget.employee.name}",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          StreamBuilder(
            stream: Firestore.instance
                .collection("teams")
                .where("eventId", isEqualTo: widget.employee.eventId)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                print(snapshot.data);
                QuerySnapshot qs = snapshot.data;
                qs.documents.forEach((f) {
                  print(f.data);
                });
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: ListTile(
                          title: Text(qs.documents[index]["teamName"]),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  ShowTeamInfoDialog(qs.documents[index]),
                            );
                          },
                        ),
                      );
                    },
                    childCount: qs.documents.length,
                  ),
                );
              }
              return SliverToBoxAdapter(child: Text("Error"));
            },
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(),
          ),
        ]));
  }
}

class ShowTeamInfoDialog extends StatefulWidget {
  final DocumentSnapshot _documentSnapshot;
  ShowTeamInfoDialog(this._documentSnapshot);

  @override
  _ShowTeamInfoDialogState createState() =>
      _ShowTeamInfoDialogState(_documentSnapshot);
}

class _ShowTeamInfoDialogState extends State<ShowTeamInfoDialog> {
  final DocumentSnapshot _documentSnapshot;
  _ShowTeamInfoDialogState(this._documentSnapshot);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: Duration(milliseconds: 1000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
          height: 400,
          child: FutureBuilder(
            future: _documentSnapshot.reference
                .collection("state")
                .document("state")
                .get(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                DocumentSnapshot documentSnapshot = snapshot.data;
                var ref = Status.fromMap(documentSnapshot.data);
                return Container(
                  height: 60,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Text("Registration done : ${ref.registration}"),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Verification done : ${ref.verification}"),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Collection done : ${ref.collection}"),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Arena Rundone : ${ref.arenaRun}"),
                    ],
                  ),
                );
              }
              return Text("Error");
            },
          )),
    );
  }
}
