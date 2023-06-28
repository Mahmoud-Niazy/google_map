class AutoCompletePlaces {
   List<AutoCompletePlaceData> data = [] ;
  AutoCompletePlaces.fromJson(Map<String,dynamic>json){
    json['predictions'].forEach((element){
      data.add(AutoCompletePlaceData.fromJson(element));
    });
  }
}

class AutoCompletePlaceData {
  late String title;
  late String body ;
  late String placeId ;
  AutoCompletePlaceData.fromJson(Map<String,dynamic>json){
    title = json['structured_formatting']['main_text'];
    body = json['structured_formatting']['secondary_text'];
    placeId = json['place_id'];
  }
}