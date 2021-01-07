class MarkAsRead{
  String id;


  MarkAsRead({
    this.id
  });

  MarkAsRead.fromMap(Map map) :
        this.id = map['id'];

  Map toMap(){
    return {
      'id': this.id
    };
  }
}