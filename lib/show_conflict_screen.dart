import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model_classes.dart';
import 'constants.dart';
import 'package:expandable/expandable.dart';

class ShowConflictDetails extends StatefulWidget {
  final Conflict conflict;

  const ShowConflictDetails(this.conflict);
  @override
  _ShowConflictDetailsState createState() => _ShowConflictDetailsState();
}

class _ShowConflictDetailsState extends State<ShowConflictDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text("Cause",style: TextStyle(fontSize: 40,fontWeight: FontWeight.w200),),
              SizedBox(height: 20,),
              Text(widget.conflict.conflictCause,style: TextStyle(fontSize: 20,),),
              Divider(),
              Text("Team's view over this conflict",style:TextStyle(fontSize: 40,fontWeight: FontWeight.w200)),
              SizedBox(height: 20,),
              Text(widget.conflict.teamView,style: TextStyle(fontSize: 20,)),
              Divider(),
              Text("Referee's view",style:TextStyle(fontSize: 40,fontWeight: FontWeight.w200)),
              SizedBox(height: 20,),
              Text(widget.conflict.refereeView,style: TextStyle(fontSize: 20,)),
              Divider(),
              SizedBox(height: 60,),

              Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Button("Allow Re-Run", 0,widget.conflict),
                  Button("Dismiss", 1,widget.conflict)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String text;
  final int flag;
  final Conflict conflict;
  const Button(this.text, this.flag, this.conflict);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Container(
        height: 50,
        width: 150,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: (flag == 0) ? color : Colors.deepOrangeAccent,
            child: Center(child: Text(text,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w300),),)),
        
      ),
      onPressed: () async {
        if (flag == 0) {
          Map<String,dynamic> map = new Map();
          map["isConflicted"] = false;
          map['run'] = false;
          await Firestore.instance.collection("teams").document(conflict.teamId).updateData(map);
          await Firestore.instance.collection("conflicts").document(conflict.conflictId).delete();
          Navigator.of(context).pop(context);
        } else if (flag == 1) {
          await Firestore.instance.collection("teams").document(conflict.teamId).updateData({"isConflicted":true});
          Navigator.of(context).pop(context);
        }
      },
    );
  }
}
