class Check {
  String? checkinId;
  String? userId;
  String? checkinCourse;
  String? checkinGroup;
  String? checkinLocation;
  String? checkinState;
  String? checkinLat;
  String? checkinLong;
  String? checkinDate;

  Check(
      {this.checkinId,
      this.userId,
      this.checkinCourse,
      this.checkinGroup,
      this.checkinLocation,
      this.checkinState,
      this.checkinLat,
      this.checkinLong,
      this.checkinDate});

  Check.fromJson(Map<String?, dynamic> json) {
    checkinId = json['checkin_id'];
    userId = json['user_id'];
    checkinCourse = json['checkin_course'];
    checkinGroup = json['checkin_group'];
    checkinLocation = json['checkin_location'];
    checkinState = json['checkin_state'];
    checkinLat = json['checkin_lat'];
    checkinLong = json['checkin_long'];
    checkinDate = json['checkin_date'];
  }

  Map<String?, dynamic> toJson() {
    final Map<String?, dynamic> data = <String?, dynamic>{};
    data['checkin_id'] = checkinId;
    data['user_id'] = userId;
    data['checkin_course'] = checkinCourse;
    data['checkin_group'] = checkinGroup;
    data['checkin_location'] = checkinLocation;
    data['checkin_state'] = checkinState;
    data['checkin_lat'] = checkinLat;
    data['checkin_long'] = checkinLong;
    data['checkin_date'] = checkinDate;
    return data;
  }
}
