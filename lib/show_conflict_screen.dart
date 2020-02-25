import 'package:flutter/material.dart';
import 'model_classes.dart';
import 'constants.dart';
import 'package:expandable/expandable.dart';
class ShowItems extends StatefulWidget {
 final Conflict conflict;

  const ShowItems(this.conflict);
  @override
  _ShowItemsState createState() => _ShowItemsState();
}

class _ShowItemsState extends State<ShowItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
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

            ],
          )
        ],
      ),
    );
  }
}
class Buttons extends StatelessWidget {
  final String text;
  final int flag ;

  const Buttons( this.text, this.flag)
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
