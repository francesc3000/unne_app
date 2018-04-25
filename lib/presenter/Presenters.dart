import 'dart:async';

import 'package:unne_app/model/User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

enum SignInState {LOGGING, LOGGED, NOTLOGGED}

abstract class EventoAnimatedListPresenter{
  void addFavoriteEvento(String eventoId,String hobby,String name,
      String level, int enroll, int maxPlayer,
      String fromDate,String toDate);
  void removeFavoriteEvento(String eventoId,String hobby,String name,
      String level, int enroll, int maxPlayer,
      String fromDate,String toDate);
}

abstract class HomePresenter implements EventoAnimatedListPresenter{
  Query getHomeListQuery();
  User getCurrentUser();
  Future<Null> onInitLoggedIn();
  Future<Null> loginWithGoogle();
  void signOut();
  Future<bool> loginWithFacebook();
}

abstract class EventoPresenter implements EventoAnimatedListPresenter{
  void save(String hobby, String name, String description,
      String level,
      int enroll,
      int maxPlayer, DateTime _fromDate, TimeOfDay _fromTime);
}

abstract class DashboardPresenter implements EventoAnimatedListPresenter{
  Future<Null> getFavoriteEventos();

}