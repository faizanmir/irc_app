class Team {
  String eventId,teamName,tid;

  Team(this.eventId, this.teamName, this.tid);



  factory Team.fromMap(Map<String,dynamic> map )
  {
    return Team(map["eventId"], map["teamName"], map["tid"]);
  }


}