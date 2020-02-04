import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:irc_prelim/viewTeamScreen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final controller = TextEditingController();
  String value = " ";
  Map <String,dynamic> map = new Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.all(10),
              child: Text("Welcome Admin",
                style: TextStyle(
                  color: Colors.blue.shade600,
                  fontSize: 30,
                  fontWeight: FontWeight.w300
                ),
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                onChanged: (data) {
                  setState(() {
                    controller.text;
                  });
                },
                validator: (validation) {
                  if (validation.length == 0) {
                    return "Please enter team id";
                  } else {
                    return null;
                  }
                },
                controller: controller,
                decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    labelText: "Team ID",
                    helperText: "Please enter your team id",
                    prefixIcon: Icon(
                      Icons.move_to_inbox,
                      color: Colors.deepOrange,
                    )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              splashColor: Colors.accents[6],
              color: Colors.blue[400],
              hoverColor: Colors.deepOrange,
              child: Text("Submit team",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onPressed: () async{
                map["teamId"] = controller.text;
                print(controller.text);
                 await Firestore.instance.collection("teams").document(controller.text).setData(map);
                 Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ViewTeamScreen(Firestore.instance.collection("teams"))));
              },
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: QrImage(
                data: controller.text,
                size: 200,
                version: QrVersions.auto,
                gapless: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
