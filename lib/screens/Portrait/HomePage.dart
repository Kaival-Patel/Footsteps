import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:footsteps/components/Dialogs/centerBottomToast.dart';
import 'package:footsteps/config/size_config.dart';
import 'package:footsteps/config/styling.dart';
import 'package:footsteps/screens/Portrait/Sign_in.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng DEFAULT_LOCATION = LatLng(42.747932, -71.167889);

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key key, this.user}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState(user: this.user);
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  User user;
  _HomePageState({this.user});
  Location location = Location();
  Completer<GoogleMapController> _controller = Completer();
  bool isHomeLocationMarked = false, _serviceEnabled;
  PermissionStatus _permissionGranted;
  Set<Marker> _markers = {};
  SharedPreferences prefs;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  LocationData currentLocation;
  dynamic userrepo;
  CameraPosition initialCameraPosition;
  BitmapDescriptor homeIconPin, currentIconPin;
  centerBottomToast cbt = centerBottomToast();
  String sliding_header_title = "Swipe up for trackers management";

  //initState
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //Initialising the camera position;
    initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: DEFAULT_LOCATION);

    //initialising locaitons
    initLocation();

    location.onLocationChanged.listen((LocationData cloc) {
      currentLocation = cloc;
      updateCurrentLocationPin();
      uploadCurrentLocation(LatLng(cloc.latitude, cloc.longitude));
    });

    //initialising shared prefs;
    initSharedPrefs();

    //setting up google maps pin icons
    setPinIcons();
    // location.onLocationChanged.listen((LocationData updatedLocation) {
    //   currentLocation = updatedLocation;
    //   updateCurrentLocationPin();
    // });
    if (user == null) {
      signOut();
    }
  }

  //Uploads the location to database
  void uploadCurrentLocation(LatLng currpos) {
    _database
        .reference()
        .child('Users')
        .child(user.uid.toString())
        .child('Current Location')
        .set({
      'latitude': currpos.latitude.toString(),
      'longitude': currpos.longitude.toString(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    }).whenComplete(() => print("Location Uploaded Successfully!"));
  }

  //setup the pin icons
  void setPinIcons() {
    homeIconPin =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    currentIconPin =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
  }

  //shows the pins on map
  void showMapPins() {
    print("SHOWING MAP PINS");
    var currentPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);
    _markers.add(Marker(
      markerId: MarkerId('Current Location'),
      position: currentPosition,
      icon: currentIconPin,
    ));
  }

  //updates the pin as current location gets updated
  void updateCurrentLocationPin() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    setState(() {
      // updated position
      var updatedPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'Current Location');
      _markers.add(Marker(
          infoWindow: InfoWindow(title: 'Current Position'),
          markerId: MarkerId('Current Location'),
          position: updatedPosition, // updated position
          icon: currentIconPin));
      if (MarkerId(user.uid) != null) {
        var distance = geo.Geolocator.bearingBetween(
          Marker(markerId: MarkerId(user.uid)).position.latitude,
          Marker(markerId: MarkerId(user.uid)).position.longitude,
          currentLocation.latitude,
          currentLocation.longitude,
        );
      }
    });
  }

  //initialisation and checking the permissions
  Future<void> initLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setCurrentLocation();
  }

  //fetches and sets the current location
  Future<void> setCurrentLocation() async {
    print("FETCHING LOCATION");
    currentLocation = await location.getLocation();
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
      );
      final GoogleMapController controller = await _controller.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(initialCameraPosition));
      uploadCurrentLocation(
          LatLng(currentLocation.latitude, currentLocation.longitude));
      
        checkforhomeLocationMarked();
    }
  }

  //inits the shared prefs
  Future<void> initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  //checks if user had set the homelocation marker
  Future<void> checkforhomeLocationMarked() async {
      _database
          .reference()
          .child('Users')
          .child(user.uid.toString())
          .once()
          .then((DataSnapshot dataSnapshot) {
        Map<dynamic, dynamic> values = dataSnapshot.value;
        print(dataSnapshot.key);
        if (!values.containsKey('Homelocation') && prefs.getBool('homelocationAlert')==null || prefs.getBool('homelocationAlert')==false) {
          print("ASKING USER!!");
          setState(() {
            isHomeLocationMarked = false;
          });
          askUserToSetHomeLocation();
        } else {
          //print(values['latitude']);
          setState(() {
            _markers.add(Marker(
                markerId: MarkerId(user.uid),
                infoWindow: InfoWindow(
                    snippet: "Home sweet home",
                    title: "Home Location",
                    onTap: () {
                      //TODO: On home icon tapped
                    }),
                position: LatLng(
                    double.parse(
                        values.values.toList()[0]['latitude'].toString()),
                    double.parse(
                        values.values.toList()[0]['longitude'].toString())),
                icon: homeIconPin));
          });
        }
      });
  }

  //asks the user to set the current location as home
  void askUserToSetHomeLocation() {
    showDialog(
        context: context,
        child: Container(
          height: SizeConfig.heightMultiplier * 20,
          child: AlertDialog(
            title: Text(
              "Set Home Location",
              style: TextStyle(fontSize: SizeConfig.textMultiplier * 3),
            ),
            content: Text(
                "Do you want to set your current Location as HomeLocation? You can change it by tapping location edit icon!"),
            actions: [
              ButtonBar(
                children: [
                  FlatButton(
                    onPressed: () async {
                      if (prefs != null) {
                        prefs.setBool('homelocationAlert', true);
                        prefs.setString(
                            'latitude', currentLocation.latitude.toString());
                        prefs.setString(
                            'longitude', currentLocation.longitude.toString());
                      }
                      _database
                          .reference()
                          .child('Users')
                          .child(user.uid)
                          .child('Homelocation')
                          .set({
                            'latitude': currentLocation.latitude,
                            'longitude': currentLocation.longitude
                          })
                          .catchError((e) => cbt.showCenterFlash(
                                alignment: Alignment.bottomCenter,
                                bgColor: Colors.red,
                                textColor: Colors.white,
                                ctx: context,
                                borderColor: Colors.red,
                                duration: Duration(seconds: 3),
                                msgtext:
                                    "Error while setting your current location as home location",
                              ))
                          .whenComplete(() {
                            cbt.showCenterFlash(
                              alignment: Alignment.bottomCenter,
                              bgColor: Colors.green,
                              textColor: Colors.white,
                              ctx: context,
                              borderColor: Colors.green,
                              duration: Duration(seconds: 3),
                              msgtext:
                                  "Home Location set successfully! You can change in profile section",
                            );
                            _markers.add(Marker(
                                markerId: MarkerId(user.uid),
                                position: LatLng(currentLocation.latitude,
                                    currentLocation.longitude),
                                infoWindow: InfoWindow(title: 'Home Location'),
                                icon: homeIconPin));
                          });
                      setState(() {
                        isHomeLocationMarked = true;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(fontSize: SizeConfig.textMultiplier * 2),
                    ),
                    color: AppTheme.appDarkVioletColor,
                  ),
                  FlatButton(
                    onPressed: () async {
                      if (prefs != null) {
                        prefs.setBool('homelocationAlert', true);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      "No",
                      style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 2,
                          color: Colors.grey),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        floatingActionButton:Padding(
                padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 5),
                child: FloatingActionButton(
                  backgroundColor: AppTheme.appDarkVioletColor,
                  child: Icon(Icons.edit_location_rounded),
                  heroTag: "Set as Home Location",
                  onPressed: () {
                    askUserToSetHomeLocation();
                  },
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: Stack(
          children: [
            Container(
              child: GoogleMap(
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                compassEnabled: true,
                tiltGesturesEnabled: false,
                buildingsEnabled: true,
                initialCameraPosition: initialCameraPosition,
                mapType: MapType.normal,
                markers: _markers,
                onTap: (argument) {
                  print("MAP TAPPED ${argument}");
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            SlidingUpPanel(
              panel: Center(
                child: Text("Loading Tracker..."),
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
              header:
                  //Peel Icon
                  Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.widthMultiplier * 22,
                    right: SizeConfig.widthMultiplier * 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      //first container
                      height: SizeConfig.heightMultiplier * 2.5,
                      width: SizeConfig.widthMultiplier * 12,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5, top: 5),
                        child: RaisedButton(
                            color: Colors.grey[100],
                            onPressed: () {},
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0))),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(sliding_header_title,
                            style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.italic)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  void showMapLoadingError() {
    cbt.showCenterFlash(
        alignment: Alignment.bottomCenter,
        bgColor: Colors.red[50],
        borderColor: Colors.red,
        ctx: context,
        duration: Duration(seconds: 6),
        msgtext: "Error Loading Map!",
        textColor: Colors.red[900]);
  }

  void signOut() {
    userrepo.signOut();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Sign_In(),
        ));
  }
}
