class League{
  final String leagueId,leagueName;
  League(this.leagueId, this.leagueName);
  factory League.fromMap(Map<String,dynamic> map)
  {
    return League(map["leagueId"], map['leagueName']);
  }
}




class EventData {
  final int eventId;
  final List<dynamic> employeeIdsInEvent;
  final String eventName, leagueId;
  EventData(
      this.eventId, this.employeeIdsInEvent, this.eventName, this.leagueId);

  factory EventData.fromMap(Map<dynamic, dynamic> map) {
    return EventData(int.parse(map["eventId"]), map['employeeIdEmailList'],
        map["eventName"], map["leagueId"]);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map['eventId'] = this.eventId;
    map['employeeIdEmailList'] = this.employeeIdsInEvent;
    map['eventName'] = this.eventName;
    return map;
  }
}

class ParticipatingEmployee {
  final String email, eventId, name;
  final String employeeId, leagueId;
  final bool isReferee,
      isFieldLeader,
      isChiefReferee,
      isInRegistration,
      isInVandC;

  ParticipatingEmployee(
      this.email,
      this.eventId,
      this.name,
      this.employeeId,
      this.isReferee,
      this.isFieldLeader,
      this.isChiefReferee,
      this.isInRegistration,
      this.isInVandC,
      this.leagueId);

  factory ParticipatingEmployee.fromMap(Map<String, dynamic> map) {
    return ParticipatingEmployee(
        map['email'],
        map['eventId'],
        map['name'],
        map['employeeId'],
        map['isReferee'],
        map['isFieldLeader'],
        map['isChiefReferee'],
        map['isInRegistration'],
        map['isInVandC'],
        map['leagueId']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map['email'] = this.email;
    map['eventId'] = this.eventId;
    map['name'] = this.name;
    map['employeeId'] = this.employeeId;
    map['isReferee'] = this.isReferee;
    map['isFieldLeader'] = this.isFieldLeader;
    map['isChiefReferee'] = this.isChiefReferee;
    map['isInRegistration'] = this.isInRegistration;
    map['isInVandC'] = this.isInVandC;
    return map;
  }

  @override
  String toString() {
    super.toString();
    return "\nemail: ${this.email}"
        "\nisReferee$isReferee"
        "\nisFieldLeader:$isFieldLeader"
        "\nisInVandC:$isInVandC"
        "\nisCheifReferee$isChiefReferee"
        "\nemployeeId: $employeeId\n";
  }
}

class Team {
  final String eventId, teamName, tid, level, leagueName, leagueId;
  final bool registration, verification, collection, run, isConflicted;
  Team(
      this.eventId,
      this.teamName,
      this.tid,
      this.registration,
      this.verification,
      this.collection,
      this.run,
      this.isConflicted,
      this.level,
      this.leagueName,
      this.leagueId);

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
        map["eventId"],
        map["teamName"],
        map["tid"],
        map['registration'],
        map['verification'],
        map['collection'],
        map['run'],
        map['isConflicted'],
        map['level'],
        map['leagueName'],
        map['leagueId']);
  }
}

class Status {
  final bool registration;
  final bool verification;
  final bool collection;
  final bool arenaRun;

  Status(this.registration, this.verification, this.collection, this.arenaRun);

  factory Status.fromMap(Map<String, dynamic> map) {
    print(map);
    return Status(map['registration'], map['verification'], map['collection'],
        map['run']);
  }
}

class Question {
  final String question, eventId, level, description, questionId, leagueId;
  final int maxPoints;
  Question(this.question, this.eventId, this.level, this.description,
      this.maxPoints, this.questionId, this.leagueId);

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      map['question'],
      map['eventId'],
      map['level'],
      map['description'],
      map['maxPoints'],
      map['questionId'],
      map['leagueId'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map['question'] = this.question;
    map['eventId'] = this.eventId;
    map['level'] = this.level;
    map['description'] = this.description;
    map['maxPoints'] = this.maxPoints;
    map['questionId'] = this.questionId;
    map['leagueId'] = this.leagueId;
    return map;
  }

  @override
  String toString() {
    return "{ "
        "question : ${this.question} \n "
        "eventId: ${this.eventId}  \n"
        "level: $level \n"
        "description: $description\n"
        "maxpoints: $maxPoints \n"
        "questionId: $question \n"
        "league: $leagueId\n"
        "}";
  }
}

class Result {
  final String question;
  final Map<String, dynamic> map;

  Result(this.question, this.map);
}


class Conflict{
 final String teamView,refereeView,conflictCause,conflictId,teamId;
  Conflict(this.teamView, this.refereeView, this.conflictCause, this.conflictId, this.teamId);
  factory Conflict.fomMap(Map<String,dynamic> map) => Conflict(map['teamView'],map['refereeView'],map['conflictCause'],map['conflictId'],map['teamId']);
}
