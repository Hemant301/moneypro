// To parse this JSON data, do
//
//     final teamMember = teamMemberFromJson(jsonString);

import 'dart:convert';

TeamMember teamMemberFromJson(String str) => TeamMember.fromJson(json.decode(str));

String teamMemberToJson(TeamMember data) => json.encode(data.toJson());

class TeamMember {
  TeamMember({
  required  this.status,
    required  this.teams,
  });

  String status;
  List<Team> teams;

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
    status: json["status"],
    teams: List<Team>.from(json["teams"].map((x) => Team.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "teams": List<dynamic>.from(teams.map((x) => x.toJson())),
  };
}

class Team {
  Team({
    required  this.firstName,
    required  this.lastName,
    required  this.mobile,
  });

  var firstName;
  var lastName;
  var mobile;

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    firstName: json["first_name"],
    lastName: json["last_name"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "mobile": mobile,
  };
}
