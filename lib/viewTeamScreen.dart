import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'viewAndAddTeamMembers.dart';
import 'package:flutter_icons/flutter_icons.dart';
class ViewTeamScreen extends StatefulWidget {
  final CollectionReference collectionReference;

  ViewTeamScreen(this.collectionReference);

  @override
  _ViewTeamScreenState createState() => _ViewTeamScreenState();
}

class _ViewTeamScreenState extends State<ViewTeamScreen> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(
        future: widget.collectionReference.getDocuments(),
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
            return ListView.builder(
              itemCount: qs.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    title:Text(
                      qs.documents[index].data["teamId"],
                    ) ,
                    leading: Icon(Ionicons.ios_browsers) ,
                onTap: () async{
                      print(qs.documents[index].reference);

                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {return ViewAndAddTeamMate(qs.documents[index].reference);}));
                },
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
