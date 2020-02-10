import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class DropDownDemo extends StatefulWidget {
  @override
  _DropDownDemoState createState() => _DropDownDemoState();
}

class _DropDownDemoState extends State<DropDownDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: Firestore.instance.collection("event").getDocuments(),
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
          QuerySnapshot qs = snapshot.data;
          return DropDownMenu(qs);
        }
        return Text("Error !");
      },
    ));
  }
}

class DropDownMenu extends StatefulWidget {
  final QuerySnapshot qs;

  const DropDownMenu(this.qs);
  @override
  _DropDownMenuState createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  String dataForDropDown;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Center(
            child: DropdownButton(
              style: TextStyle(
                height: 50,
              ),
              hint: Text("Hello !"),
              elevation: 10,

              icon: Icon(EvilIcons.arrow_down),
              value: dataForDropDown,
              onChanged: (value) {
                setState(() {
                  dataForDropDown = value;
                });
              },

              items: widget.qs.documents
                  .map((f) => f.data.toString())
                  .map<DropdownMenuItem<String>>((dynamic value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Container(
                    width: 300,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child:ListTile(
                        subtitle: Text("Hello"),
                        trailing: Icon(
                            MaterialIcons.event,
                          color: Colors.lightBlue,
                        ),
                        title: Text(value),
                      )
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
