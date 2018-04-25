import 'dart:async';

import 'package:unne_app/model/EventoThumb.dart';
import 'package:unne_app/pages/MainPage.dart';
import 'package:unne_app/pages/PagesViews.dart';
import 'package:unne_app/config/Strings.dart';
import 'package:unne_app/presenter/Presenters.dart';
import 'package:unne_app/presenter/PresentersImpl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:map_view/map_view.dart';
import 'package:numberpicker/numberpicker.dart';

EventoPresenter _eventoPresenter;

class EventoPage extends StatefulWidget implements EventoView {
  EventoPage() {
    _eventoPresenter = new EventoPresenterImpl(this);
  }

  @override
  _EventoPage createState() => new _EventoPage();
}

class _EventoPage extends State<EventoPage> {
  //final TextEditingController _controllerName = new TextEditingController();
  //final TextEditingController _controllerDescription = new TextEditingController();
  String _hobby;
  String _name;
  String _description;
  String _level;
  int _maxPlayer;
  DateTime _fromDate = new DateTime.now();
  TimeOfDay _fromTime = new TimeOfDay.now();

  Widget _screen;
  Widget _button;
  int _screenCounter = 1;
  GoogleMap googleMap;

  final formKeyScreen1 = new GlobalKey<FormState>();
  final formKeyScreen2 = new GlobalKey<FormState>();

  _EventoPage(){
    googleMap = new GoogleMap();
  }

  @override
  Widget build(BuildContext context) {
    _screen = getScreen();
    _button = getProperButton();

    return new MaterialApp(
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text(Strings.eventoTitle),
            actions: [
              _button,
            ],
          ),
          body: new ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return _screen;
            },
          )),
    );
  }

  Widget getProperButton() {
    FlatButton flatButton;

    if (_screenCounter == 3) {
      flatButton = new FlatButton(
          onPressed: () {
            String level;
            switch(_level){
              case 'Bajo':
                level = Level.LOW.toString();
                break;
              case 'Medio':
                level = Level.MEDIUM.toString();
                break;
              case 'Alto':
                level = Level.HIGH.toString();
                break;
            }
            _eventoPresenter.save(_hobby, _name,
                _description, level, 0, _maxPlayer,_fromDate, _fromTime);

            Navigator.of(context).pop();
          },
          child: new Text('GUARDAR',
              style: Theme
                  .of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white)));
    } else {
      flatButton = new FlatButton(
          onPressed: () {
            setState(() {
              var formKey;
              switch(_screenCounter){
                case 1:
                  formKey = formKeyScreen1;
                  break;
                case 2:
                  formKey = formKeyScreen2;
                  break;
              }

              if(_validate(formKey)) {
                _button = getProperButton();
                _screen = getScreen();

                _screenCounter++;
              }
            });
          },
          child: new Text('Siguiente',
              style: Theme
                  .of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white)));
    }

    return flatButton;
  }

  Widget getScreen() {
    Widget screen;

    switch(_screenCounter){
      case 1:
        screen = new Form(
            key: formKeyScreen1,
            child: new Column(children: <Widget>[
              new DropdownButton<String>(
                value: _hobby,
                hint: const Text("Unne"),
                onChanged: (String newValue) {
                  setState(() {
                    _hobby = newValue;
                  });
                },
                items:
                <String>['Padel', 'Futbol', 'Basquet', 'Tenis'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
              ),
              new DropdownButton<String>(
                value: _level,
                hint: const Text("Nivel"),
                onChanged: (String newValue) {
                  setState(() {
                    _level = newValue;
                  });
                },
                items:
                <String>['Bajo', 'Medio', 'Alto',].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
              ),

              new NumberPicker.integer(
                  initialValue: 1,
                  minValue: 1,
                  maxValue: 999,
                  onChanged: (newValue) =>
                      setState(() => _maxPlayer = newValue)),
              const SizedBox(
                height: 24.0,
              ),
              new TextFormField(
                  //controller: _controllerName,
                  decoration: new InputDecoration(
                    hintText: 'Nombre del evento',
                  ),
              validator: (val) => val.isEmpty? 'El nombre no puede estar vacío' : null,
                  onSaved: (val) => _name = val,),
              new TextFormField(
                //controller: _controllerDescription,
                decoration: new InputDecoration(
                  hintText: 'Descripción',
                ),
                validator: (val) => val.isEmpty? 'La descripción no puede estar vacía' : null,
                onSaved: (val) => _description = val,
                maxLines: 6,
              )
            ]));
        break;
      case 2:
        screen = new Form(
          key: formKeyScreen2,
            child: new Column(children: <Widget>[
              new _DateTimePicker(
                labelText: "Fecha",
                selectedDate: _fromDate,
                selectedTime: _fromTime,
                selectDate: (DateTime date) {
                  setState(() {
                    _fromDate = date;
                  });
                },
                selectTime: (TimeOfDay time) {
                  setState(() {
                    _fromTime = time;
                  });
                },
              )
            ]));
        break;
      case 3:
        screen = new Center(child: new Container(child:new Text("Aquí va el mapa"))); //googleMap.showMap()));
          break;
    }

    return screen;
  }

  bool _validate(GlobalKey<FormState> key) {
    final form = key.currentState;

    if (form.validate()) {
      form.save();

      return true;
    }

    return false;
  }
/*
  Widget getMapBox(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          new FlutterMap(
            options: new MapOptions(
              center: new LatLng(51.5, -0.09),
              zoom: 13.0,
            ),
            layers: [
              new TileLayerOptions(
                urlTemplate: "https://api.tiles.mapbox.com/v4/"
                    "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoiZnJhbmNlc2MzMDAwIiwiYSI6ImNqZmNtMHFtZDFsb2QzM29mcWlvd2pnM3AifQ.CM-fMJyuDzlSITFi9LqTSQ',
                  'id': 'mapbox.streets',
                },
              ),
              new MarkerLayerOptions(
                markers: [
                  new Marker(
                    width: 80.0,
                    height: 80.0,
                    point: new LatLng(51.5, -0.09),
                    builder: (ctx) => new Container(
                          child: new FlutterLogo(),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
*/
}

class GoogleMap{
  static var API_KEY = "<AIzaSyDEi7TnZLQpnqKfU7deQ8Igl4JToAciz8s>"; //TODO:Quizas sin < >
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var compositeSubscription = new CompositeSubscription();
  var staticMapProvider = new StaticMapProvider(API_KEY);
  Uri staticMapUri;

  List<Marker> _markers = <Marker>[
    new Marker("1", "Work", 45.523970, -122.663081, color: Colors.blue),
    new Marker("2", "Nossa Familia Coffee", 45.528788, -122.684633),
  ];

  GoogleMap(){
    MapView.setApiKey(API_KEY);
    cameraPosition = new CameraPosition(Locations.portland, 2.0);
    staticMapUri = staticMapProvider.getStaticUri(Locations.portland, 12,
        width: 900, height: 400, mapType: StaticMapViewType.roadmap);
  }

  showMap() {
    mapView.show(
        new MapOptions(
            mapViewType: MapViewType.normal,
            showUserLocation: true,
            initialCameraPosition: new CameraPosition(
                new Location(45.5235258, -122.6732493), 14.0),
            title: "Recently Visited"),
        toolbarActions: [new ToolbarAction("Close", 1)]);

    var sub = mapView.onMapReady.listen((_) {
      mapView.setMarkers(_markers);
      mapView.addMarker(new Marker("3", "10 Barrel", 45.5259467, -122.687747,
          color: Colors.purple));
      mapView.zoomToFit(padding: 100);
    });
    compositeSubscription.add(sub);

    sub = mapView.onLocationUpdated
        .listen((location) => print("Location updated $location"));
    compositeSubscription.add(sub);

    sub = mapView.onTouchAnnotation
        .listen((annotation) => print("annotation tapped"));
    compositeSubscription.add(sub);

    sub = mapView.onMapTapped
        .listen((location) => print("Touched location $location"));
    compositeSubscription.add(sub);
/*
    sub = mapView.onCameraChanged.listen((cameraPosition) =>
        this.setState(() => this.cameraPosition = cameraPosition));
    compositeSubscription.add(sub);
*/
    sub = mapView.onToolbarAction.listen((id) {
      if (id == 1) {
        _handleDismiss();
      }
    });
    compositeSubscription.add(sub);

    sub = mapView.onInfoWindowTapped.listen((marker) {
      print("Info Window Tapped for ${marker.title}");
    });
    compositeSubscription.add(sub);
  }

  _handleDismiss() async {
    double zoomLevel = await mapView.zoomLevel;
    Location centerLocation = await mapView.centerLocation;
    List<Marker> visibleAnnotations = await mapView.visibleAnnotations;
    print("Zoom Level: $zoomLevel");
    print("Center: $centerLocation");
    print("Visible Annotation Count: ${visibleAnnotations.length}");
    var uri = await staticMapProvider.getImageUriFromMap(mapView,
        width: 900, height: 400);
    //setState(() => staticMapUri = uri);
    mapView.dismiss();
    compositeSubscription.cancel();
  }
}

class CompositeSubscription {
  Set<StreamSubscription> _subscriptions = new Set();

  void cancel() {
    for (var n in this._subscriptions) {
      n.cancel();
    }
    this._subscriptions = new Set();
  }

  void add(StreamSubscription subscription) {
    this._subscriptions.add(subscription);
  }

  void addAll(Iterable<StreamSubscription> subs) {
    _subscriptions.addAll(subs);
  }

  bool remove(StreamSubscription subscription) {
    return this._subscriptions.remove(subscription);
  }

  bool contains(StreamSubscription subscription) {
    return this._subscriptions.contains(subscription);
  }

  List<StreamSubscription> toList() {
    return this._subscriptions.toList();
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(2015, 8),
        lastDate: new DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        new Expanded(
          flex: 3,
          child: new _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
