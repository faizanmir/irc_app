import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:irc_prelim/event_run_sheet.dart';
import 'model_classes.dart';
import 'profile_page.dart';
import 'constants.dart';
import 'chief_referee_screen.dart';

class ChooseEventsScreen extends StatefulWidget {
  final String leagueId, employeeEmail;
  const ChooseEventsScreen(this.leagueId, this.employeeEmail);
  @override
  _ChooseEventsScreenState createState() => _ChooseEventsScreenState();
}

class _ChooseEventsScreenState extends State<ChooseEventsScreen> {
  var employeeForEvent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firestore.instance
            .collection("event")
            .where("employeeIdEmailList", arrayContains: widget.employeeEmail)
            .where("leagueId", isEqualTo: widget.leagueId)
            .getDocuments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            QuerySnapshot qs = snapshot.data;
            qs.documents.forEach((f) {
              print(f.data);
            });
            return Container(
              decoration: appGradient,
              child: SelectEventBody(qs, widget),
            );
          }

          return Text("Error");
        },
      ),
    );
  }
}

class SelectEventBody extends StatefulWidget {
  final QuerySnapshot qs;
  final ChooseEventsScreen widget;

  const SelectEventBody(this.qs, this.widget);

  @override
  _SelectEventBodyState createState() => _SelectEventBodyState();
}

class _SelectEventBodyState extends State<SelectEventBody> {
  ParticipatingEmployee employeeMapForEvent;
  EventChosenButton eventChosenButton;
  EventLoadingState eventLoadingState = EventLoadingState.NOT_SELECTED;

  Map<int, bool> colorMap = HashMap();

  static Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse("0x$hexColor"));
  }

  @override
  void initState() {
    super.initState();
    int i = 0;
    widget.qs.documents.forEach((f) {
      colorMap[i] = false;
      i++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300,
                  margin: EdgeInsets.all(10),
                  child: Center(
                    child: RichText(
                      strutStyle: StrutStyle(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      text: TextSpan(
                          text: "Hello !",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 30,
                          )),
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                "Choose an event",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 400,
              child: ListView.builder(
                itemCount: widget.qs.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  //Make this code again for separating setstates
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color:
                          (colorMap[index]) ? Colors.lightBlue : Colors.white,
                      child: ListTile(
                        title: Text(widget.qs.documents[index]['eventName']),
                        onTap: () async {
                          colorMap.forEach((k, v) {
                            colorMap[k] = false;
                          });
                          setState(() {
                            colorMap[index] = true;
                            eventLoadingState = EventLoadingState.LOADING;
                          });

                          QuerySnapshot querySnapshot = await Firestore.instance
                              .collection("event")
                              .document(widget.qs.documents[index]['eventId'])
                              .collection("participatingMembers")
                              .where("eventId",
                                  isEqualTo: widget.qs.documents[index]
                                      ["eventId"])
                              .where("email",
                                  isEqualTo: widget.widget.employeeEmail)
                              .getDocuments();
                          employeeMapForEvent = querySnapshot.documents
                              .map((f) => ParticipatingEmployee.fromMap(f.data))
                              .first;
                          setState(() {
                            eventLoadingState = EventLoadingState.DONE_LOADING;
                          });
                        },
                      ),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: checkEventState(eventLoadingState)),
            )
          ],
        ),
      ),
    );
  }

  Widget checkEventState(state) {
    if (state == EventLoadingState.LOADING) {
      return Center(
        child: Container(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(),
        ),
      );
    } else if (eventLoadingState == EventLoadingState.NOT_SELECTED) {
      return Text(
        "Please choose an event to continue",
        style: TextStyle(
            fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white),
      );
    } else if (eventLoadingState == EventLoadingState.DONE_LOADING) {
      return EventChosenButton(employeeMapForEvent);
    }
    return Text("Error");
  }
}

abstract class OnEventSelected {
  onEventSelected();
}

class EventChosenButton extends StatefulWidget {
  final ParticipatingEmployee employee;
  EventChosenButton(this.employee);

  @override
  _EventChosenButtonState createState() => _EventChosenButtonState();
}

class _EventChosenButtonState extends State<EventChosenButton>
    with TickerProviderStateMixin {
  Animation<BorderRadius> borderRadiusAnimation;
  Animation<double> _widthDimens;
  Animation<double> heightDimens;
  AnimationController animationController;
  bool isAnimationComplete = false;
  bool isEventChosen = false;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..addListener(() {
        setState(() {
          print("Called");
        });
      });
    borderRadiusAnimation = Tween<BorderRadius>(
            begin: BorderRadius.circular(150), end: BorderRadius.circular(20))
        .animate(CurvedAnimation(
            curve: Curves.bounceInOut, parent: animationController));

    _widthDimens = Tween<double>(begin: 70, end: 130).animate(
        CurvedAnimation(curve: Curves.elasticIn, parent: animationController));

    heightDimens = Tween<double>(begin: 10, end: 60).animate(
        CurvedAnimation(curve: Curves.bounceInOut, parent: animationController))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            isAnimationComplete = true;
          });
        }
      });
    animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.employee.isChiefReferee) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  ChiefRefereeScreen(widget.employee)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ProfilePage(widget.employee)));
        }
      },
      child: Container(
          margin: EdgeInsets.all(10),
          child: Center(
              child: isAnimationComplete
                  ? Text("Proceed",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w300))
                  : Text(" ")),
          height: heightDimens.value,
          width: _widthDimens.value,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromARGB(255, 149, 208, 158),
              borderRadius: borderRadiusAnimation.value)),
    );
  }
}
