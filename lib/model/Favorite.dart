import 'dart:collection';

import 'package:meta/meta.dart';

class favorite{
  String _userId;
  Map<String,bool> _eventoIdList = new HashMap();

  favorite(@required this._userId);

  void enable(String eventoId){
    this._eventoIdList.putIfAbsent(eventoId, ()=>true);
  }

  toJson(){
    return {
      "userId": this._userId,
      "eventoIdList": this._eventoIdList
    };
  }
}