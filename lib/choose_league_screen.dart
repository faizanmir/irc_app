import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:irc_prelim/model_classes.dart';
import 'constants.dart';
import 'choose_event_screen.dart';
class ChooseLeagueScreen extends StatefulWidget {
  final String employeeEmail;

  const ChooseLeagueScreen( this.employeeEmail);
  @override
  _ChooseLeagueScreenState createState() => _ChooseLeagueScreenState();
}

class _ChooseLeagueScreenState extends State<ChooseLeagueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: appGradient,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: Firestore.instance.collection("league").getDocuments(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData && (snapshot.connectionState == ConnectionState.done)){
              QuerySnapshot qs = snapshot.data;
              var list = qs.documents.map((t)=>League.fromMap(t.data)).toList();
              return Column(
                children: <Widget>[
                  SizedBox(height: 50,),
                  Container(child: Text("Please select a league ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 30),)),
                  Container(
                    height: 300,
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: ListTile(
                            title: Text(list[index].leagueName),
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>ChooseEventsScreen(list[index].leagueId,widget.employeeEmail)));
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            }
            return Center(child: Container(height: 50,width: 50,child: CircularProgressIndicator()));

          },

        ),
      ),
    );
  }
}
