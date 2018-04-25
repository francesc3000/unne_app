import 'package:unne_app/dao/EventoDao.dart';
import 'package:unne_app/model/EventoThumb.dart';

class Evento extends EventoThumb{

  Evento(String key, String hobby, String name, String description,
      Level level, int enroll, int maxPlayer)
      : super(key, hobby, name, level, enroll, maxPlayer){
    this._description = description;
  }

  String _description;

  //Getter and Setters
  String get description => _description;

  set description(String value) {
    _description = value;
  }

  @override
  toJson(){
    return {
      EventoDao.hobby: this.hobby,
      EventoDao.name: this.name,
      EventoDao.level: this.level.toString(),
      EventoDao.enroll: this.enroll,
      EventoDao.maxPlayer: this.maxPlayer,
      EventoDao.description: this.description,
      EventoDao.fromDate: this.fromDate.millisecondsSinceEpoch.toString(), //timestamp
      EventoDao.toDate: this.toDate.millisecondsSinceEpoch.toString()
    };
  }
}