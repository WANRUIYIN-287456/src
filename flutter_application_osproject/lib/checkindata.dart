class CheckInData {
  String? userid;
  String? course;
  String? location;
  String? state;
  String? long;
  String? lat;
  String? checkindate;
  String? checkinid;

  CheckInData(
      {this.userid,
      this.course,
      this.location,
      this.state,
      this.long,
      this.lat,
      this.checkindate,
      this.checkinid,
      });

  CheckInData.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    course = json['course'];
    location = json['location'];
    state = json['state'];
    long = json['long'];
    lat = json['lat'];
    checkindate = json['checkindate'];
    checkinid = json['checkinid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userid'] = userid;
    data['course'] = course;
    data['location'] = location;
    data['state'] = state;
    data['long'] = long;
    data['lat'] = lat;
    data['checkindate'] = checkindate;
    data['checkinid'] = checkinid;
    return data;
  }
}