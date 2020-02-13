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
