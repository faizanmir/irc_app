import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';
class ViewAndAddTeamMate extends StatefulWidget {
  final DocumentReference documentReference;

  ViewAndAddTeamMate(this.documentReference);

  @override
  _ViewAndAddTeamMateState createState() => _ViewAndAddTeamMateState();
}

class _ViewAndAddTeamMateState extends State<ViewAndAddTeamMate> {

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(builder: (BuildContext context, AsyncSnapshot snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting)
        {
          return Center(
            child: Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
              ),
            ),
          );
        }
      else if(snapshot.connectionState == ConnectionState.done)
        {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(title:Text(snapshot.data["teamId"],)),
            body: Column(
              children: <Widget>[
                SizedBox(height: 50,),
                RaisedButton(
                  child: Text("Add Member"),
                  onPressed: () {
                  showDialog(
                      context: context,builder: (context)=>AddMemberDialog(widget.documentReference.collection("members")));
                },),
                Container(
                  height: 400,
                  color: Colors.deepOrange,
                  child: StreamBuilder(
                    stream: widget.documentReference.collection("members").snapshots(includeMetadataChanges: true),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting)
                      {
                        return Center(
                          child: Container(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }


                    else
                      {
                        QuerySnapshot qs = snapshot.data;
                        return ListView.builder(
                          itemCount: qs.documents.length,
                          itemBuilder: (BuildContext context, int index) {

                          return ListTile(
                            isThreeLine: true,
                            subtitle: Text(qs.documents[index].data["verified"]),
                            title: Text(qs.documents[index].data["name"]),
                          );
                        },);
                      }

                  },


                  ),
                )

              ],
            ),
          );
        }
      return Container();

    },future: widget.documentReference.get(),);
  }
}

class AddMemberDialog extends StatefulWidget {
  final CollectionReference memberCollectionReference;

  AddMemberDialog(this.memberCollectionReference);
  @override
  _AddMemberDialogState createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final controllerForName = TextEditingController();
  final controllerForVerified = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Form(
        key:_formKey ,
        child: Container(
          height: 250,
          child: Column(
            children: <Widget>[
              FieldForMember("Name",controllerForName),
              FieldForMember("Verified",controllerForVerified),
              SizedBox(width: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: RaisedButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: RaisedButton(
                    onPressed: () async {
                      Map<String,dynamic> map= Map();
                      map["name"] = controllerForName.text;
                      map["verified"] = controllerForVerified.text;
                       await widget.memberCollectionReference.document().setData(map);
                      Navigator.pop(context);
                    },
                    child: Text("Submit"),

                  ),
                )
              ],)
            ],
          ),
        ),
      ),
    );
  }
}

class FieldForMember extends StatefulWidget {
  final String fieldName;
  final TextEditingController controller;
  FieldForMember(this.fieldName, this.controller);

  @override
  _FieldForMemberState createState() => _FieldForMemberState();
}

class _FieldForMemberState extends State<FieldForMember> {
 String name;
 bool verified;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: widget.controller,
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          labelText: widget.fieldName,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0)
          )
        ),
      ),
    );
  }
}


