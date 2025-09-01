class Tournament {
  final String name;
  Tournament(this.name);

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(json['name'] ?? '');
  }
}
