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
        decoration: appGradient,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            Text("Cause"),
            Text(widget.conflict.conflictCause),
            Text("Team's view over this conflict"),
            Text(widget.conflict.teamView),
            Text("Referee's view"),
            Text(widget.conflict.refereeView),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Button("Allow Re-Run",0),
                Button("Dismiss",1)
              ],
            )
          ],
        ),
      ),
    );
  }
}
class Button extends StatelessWidget {
  final String text;
  final int flag ;

  const Button( this.text, this.flag);
  @override
  Widget build(BuildContext context) {
    return FlatButton(child: Container(height: 50,width: 100,), onPressed: () {
      if(flag ==0)
        {

        }
      else if(flag ==1)
        {

        }
    },);
  }
}
