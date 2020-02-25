import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model_classes.dart';
import 'constants.dart';
import 'signature_pad.dart';
import 'conflict_page.dart';

class ShowResultsScreen extends StatefulWidget {
  final Map<String, dynamic> resultMap;
  final Map<String, dynamic> questionMap;
  final Team team;
  const ShowResultsScreen(this.resultMap, this.questionMap, this.team);

  @override
  _ShowResultsScreenState createState() => _ShowResultsScreenState();
}

class _ShowResultsScreenState extends State<ShowResultsScreen> {
  Map<String, dynamic> tempMap = new Map();

  @override
  void initState() {
    widget.resultMap.keys.forEach((f) {
      tempMap[widget.questionMap[f]] = widget.resultMap[f];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: DataTable(
                columns: <DataColumn>[
                  DataColumn(label: Text("Question")),
                  DataColumn(label: Text("Points"))
                ],
                rows: tempMap.keys
                    .map((f) => DataRow(cells: <DataCell>[
                          DataCell(Text(f)),
                          DataCell(Text(tempMap[f].toString()))
                        ]))
                    .toList()),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  print(widget.resultMap);
                 var result = await Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Signature(widget.team,tempMap)));
                 if(result)
                   {
                     Navigator.pop(context,true);
                   }
                },
                child: Container(
                  margin: EdgeInsets.all(10), 
                  height: 60,
                  width: 120,
                  child: Card(
                    color: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(
                      child: Text("Proceed",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20,color: Colors.white),),

                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                   var result = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SubmitConflictPage(widget.team)));
                   if(result)
                     {
                       Navigator.pop(context,true);
                     }
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  height: 60,
                  width: 120,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.deepOrange,
                    child: Center(child: Text("Conflict",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300,color: Colors.white),)),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
