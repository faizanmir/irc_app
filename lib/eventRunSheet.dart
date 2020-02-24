import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'constants.dart' as constants;
import 'modelClasses.dart';
import 'displayResultToTeam.dart';

class ScoringScreen extends StatefulWidget {
  final String scanResult;

  ScoringScreen(this.scanResult);

  @override
  _ScoringScreenState createState() => _ScoringScreenState();
}

class _ScoringScreenState extends State<ScoringScreen> {
  final controller = PageController();
  List<Widget> widgetList;
  int index = 0;
  String docId;

  Map<String, dynamic> map = new Map();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QuestionsPage(widget.scanResult),
    );
  }
}

class QuestionsPage extends StatefulWidget {
  final String teamId;
  const QuestionsPage(this.teamId);
  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage>
    with AutomaticKeepAliveClientMixin<QuestionsPage> {
  List<double> ratingRecord;
  List<Question> tempList;
  Map<String, dynamic> resultMap = new Map();
  Map<String, dynamic> questionMap = new Map();
  Future<QuerySnapshot> querySnapshot;
  Team team;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: getTeam(widget.teamId),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            QuerySnapshot qs = snapshot.data;
            var temp = qs.documents.map((f) => Team.fromMap(f.data)).toList();
             team = temp.first;
            return _makeFutureBuilder();
          } else {
            return Center(
                child: Container(
                    height: 50, width: 50, child: CircularProgressIndicator()));
          }
        });
  }

  Widget _makeFutureBuilder() {
    return FutureBuilder(
        future: Firestore.instance
            .collection("questions")
            .where("leagueId", isEqualTo: team.leagueId)
            .where("level", isEqualTo: team.level)
            .getDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            QuerySnapshot querySnapshot = snapshot.data;

            tempList = querySnapshot.documents
                .map((f) => Question.fromMap(f.data))
                .toList();
            tempList.forEach((f) {
              questionMap[f.questionId] = f.question;
            });

            return Container(
              height: MediaQuery.of(context).size.height,
              decoration: constants.appGradient,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 500,
                    child: ListView.builder(
                      itemCount: tempList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width - 20,
                            height: 250,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                  color: Colors.blueGrey,
                                                  margin: EdgeInsets.all(3),
                                                  child: Center(
                                                      child: Text(
                                                    (index + 1).toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 30),
                                                  ))),
                                            ),
                                            Expanded(
                                              flex: 6,
                                              child: Container(
                                                margin: EdgeInsets.all(10),
                                                child: ExpandablePanel(
                                                  header: Center(
                                                      child: Text(
                                                    tempList[index].question,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  )),
                                                  expanded: Text(tempList[index]
                                                      .description),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: RatingBar(
                                                itemCount:
                                                    tempList[index].maxPoints,
                                                itemBuilder: (context, _) =>
                                                    Icon(MaterialIcons
                                                        .fiber_manual_record),
                                                onRatingUpdate: (double value) {
                                                  resultMap[tempList[index]
                                                      .questionId] = value;
                                                }),
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      height: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Center(
                                                child: Text(
                                              "Do you want to continue with the score submission ?",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w300),
                                            )),
                                            margin: EdgeInsets.all(15),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                child: FlatButton(
                                                  onPressed: () {
                                                    _onConfirmation();
                                                  },
                                                  child: Text("Yes"),
                                                  color: constants.color,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                                margin: EdgeInsets.all(10),
                                              ),
                                              Container(
                                                child: FlatButton(
                                                  onPressed: () {
                                                    resultMap.clear();
                                                    Navigator.of(context)
                                                        .pop(context);
                                                  },
                                                  child: Text(
                                                    "No",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  color: Color.fromARGB(
                                                      255, 0, 26, 71),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                margin: EdgeInsets.all(10),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                        },
                        child: Container(
                          margin: EdgeInsets.all(20),
                          height: 60,
                          width: 200,
                          child: Card(
                            elevation: 10,
                            color: constants.color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                                child: Text("Proceed",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20,
                                        color: Colors.white))),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  _onConfirmation() {
    if (resultMap.length < tempList.length) {
      tempList.forEach((f) {
        if (!resultMap.containsKey(f.questionId)) {
          resultMap[f.questionId] = 0.0;
        }
      });
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            ShowResultsScreen(resultMap, questionMap, team)));
    print(resultMap);
  }

  @override
  bool get wantKeepAlive => true;

  Future<QuerySnapshot> getTeam(String teamId) async {
    return await Firestore.instance
        .collection("teams")
        .where("tid", isEqualTo: teamId)
        .getDocuments();
  }
}
