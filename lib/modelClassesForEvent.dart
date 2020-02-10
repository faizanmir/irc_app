class EventData {
 final int eventId;
 final List<dynamic> employeeIdsInEvent;
  final String eventName;
  EventData(this.eventId, this.employeeIdsInEvent, this.eventName);

  factory EventData.fromMap(Map<dynamic, dynamic> map) {
    return EventData(int.parse(map["eventId"]), map['employeeIdEmailList'],map["eventName"]);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map['eventId'] = this.eventId;
    map['employeeIdEmailList'] = this.employeeIdsInEvent;
    map['eventName'] = this.eventName;
    return map;
  }
}

class EmployeeMapForEvent {
  final String email, role, eventId,name;
  final String employeeId;

  EmployeeMapForEvent(this.email, this.role, this.employeeId, this.eventId, this.name);

  factory EmployeeMapForEvent.fromMap(Map<String, dynamic> map) {
    return EmployeeMapForEvent(
        map['email'], map['role'], map['employeeId'], map['eventId'],map['name']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map();
    map['email'] = this.email;
    map['role'] = this.role;
    map['employeeId'] = this.employeeId;
    map['eventId'] = this.eventId;
    return map;
  }

  @override
  String toString() {
    super.toString();
    print(
        "\nemail: ${this.email} \n role: ${this.role} \n employeeId: ${this.employeeId} \n");
  }
}
