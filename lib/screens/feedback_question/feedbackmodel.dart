import 'dart:ffi';

class feedbackmodel {
  String? uid;
  int? likeness; 
  String? feeling;
  String? feedback;

  feedbackmodel({this.uid, this.likeness, this.feeling, this.feedback});

  // get from server
  factory feedbackmodel.fromMap(map)
  {
    return feedbackmodel(
      uid: map['uid'],
      likeness: map['likeness'],
      feeling: map['feeling'],
      feedback: map['feedback'],
    );
  }

  // push to server
  Map<String, dynamic> toMap(){
    return {
      'uid': uid,
      'likeness': likeness,
      'feeling': feeling,
      'feedback': feedback,
    };
  }

}