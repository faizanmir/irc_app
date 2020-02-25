import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'model_classes.dart';

class SubmitConflictPage extends StatefulWidget {
  final Team team;

  const SubmitConflictPage(this.team);
  @override
  _SubmitConflictPageState createState() => _SubmitConflictPageState();
}

class _SubmitConflictPageState extends State<SubmitConflictPage> {
  final causeController = TextEditingController();
  final refereeController = TextEditingController();
  final teamViewController = TextEditingController();
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: appGradient,
        child: Form(
          key: key,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 50,
                    width: 60,
                    margin: EdgeInsets.all(10),
                    child: Center(
                        child: Text(
                      "Please fill in the form below to lodge a conflict",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    ))),
              ),
              ConflictField(
                  causeController, "Please mention the cause of conflict"),
              ConflictField(refereeController, "Referee's view"),
              ConflictField(teamViewController, "Team's View"),
              FlatButton(
                  onPressed: () async {
                    var temp = DateTime.now().millisecondsSinceEpoch.toString();
                    if(key.currentState.validate())
                      {
                        showDialog(context: context,builder: (context)=>CircularProgressIndicator());

                        Map<String,dynamic> map = Map();
                        map['conflictCause'] = causeController.text;
                        map['refereeView'] = refereeController.text;
                        map['teamView'] = teamViewController.text;
                        map['conflictId'] = temp;
                        map['teamId'] = widget.team.tid;

                        await Firestore.instance.collection('conflicts').document(temp).setData(map);

                        Map<String,dynamic> tempMap = Map();
                        tempMap['isConflicted'] = true;
                        tempMap['run'] =true;

                        await Firestore.instance.collection("teams").document(widget.team.tid).updateData(tempMap);
                        Navigator.of(context).pop(true);
                        Navigator.of(context,rootNavigator: false).pop();
                      }

                  },
                  child: Container(
                      height: 50,
                      width: 150,
                      child: Card(
                          color: color,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: Center(
                            child: Text("Proceed",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300)),
                          )
                      )
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ConflictField extends StatefulWidget {
  final TextEditingController controller;
  final String message;

  const ConflictField(this.controller, this.message);

  @override
  _ConflictFieldState createState() => _ConflictFieldState();
}

class _ConflictFieldState extends State<ConflictField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width - 20,
        child: TextFormField(
          controller: widget.controller,
          validator: (value){
            if(value.isEmpty)
              {
                return "Please enter text";
              }
            return null;
          },
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: TextStyle(
            fontSize: 15,
          ),
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.lightBlue)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              labelText: widget.message,
              labelStyle: TextStyle(
                color: Colors.black,
              )),
        ));
  }
}
