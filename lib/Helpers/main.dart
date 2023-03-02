import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:velo/Helpers/google_auth.dart';
import 'package:velo/Helpers/gps_service.dart';
import 'package:velo/Helpers/stand.dart';
import 'package:velo/HomePage/map.dart';
import 'package:velo/HomePage/user_info_bar.dart';
import 'package:velo/RideHistoryPage/history_page.dart';
import 'package:velo/RidingPage/main.dart';
import 'package:velo/SignInPage/main.dart';
import 'package:velo/firebase_options.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var searchTerms = <String>[];
  var stands = <Stand>[];
  String searchValue = '';
  final List<String> _suggestions = [];

  Future<List<String>> _fetchSuggestions(String searchValue) async {
    await Future.delayed(const Duration(milliseconds: 750));

    return _suggestions.where((element) {
      return element.toLowerCase().contains(searchValue.toLowerCase());
    }).toList();
  }

  double? lat, long;
  String? name, address;
  String? points;
  bool isLocationAvailable = false;

  callback(double lat, double long) {
    setState(() {
      isLocationAvailable = true;
      this.lat = lat;
      this.long = long;
    });
    getAddress().then((value) {
      setState(() {
        address = value;
      });
    });
  }

  Future<bool> checkForUser() async {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<bool> checkIfRiding() async {
    User user = FirebaseAuth.instance.currentUser!;
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(user.uid)
        .get();
    return snapshot.child("isRiding").value == true;
  }

  Future<void> fetchStands() async {
    final ref = FirebaseDatabase.instance.ref();
    ref.child('Stands').onValue.listen((event) {
      for (var standSnapshot in event.snapshot.children) {
        Stand stand = Stand();
        searchTerms.add(standSnapshot.key!);

        Marker marker = Marker(
          markerId: MarkerId(standSnapshot.key!),
          position: LatLng(
              double.parse(standSnapshot
                  .child("latLong")
                  .value
                  .toString()
                  .split(',')[0]),
              double.parse(standSnapshot
                  .child("latLong")
                  .value
                  .toString()
                  .split(',')[1])),
          infoWindow: InfoWindow(
            snippet:
                'Cycles available: ${standSnapshot.child("cyclesAvailable").value.toString()}',
            title: '${standSnapshot.key}',
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        );
        stand.marker = marker;
        stand.name = standSnapshot.key;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
        .then((value) {
      checkForUser().then(
        (value) {
          if (!value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignInPage()));
          } else {
            checkIfRiding().then((value) {
              if (value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => RidingPage()));
              } else {
                name = FirebaseAuth
                    .instance.currentUser!.providerData[0].displayName;
                fetchStands();
                GPSService(callback);
                getPoints().then((value) {
                  setState(() {});
                });
              }
            });
          }
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
          backgroundColor: Color(0xFF0C9869),
          title: const Text('Velo'),
          onSearch: (value) {
            setState(() => searchValue = value);
            stands.forEach((element) {
              if (searchValue == element.name) {}
            });
          },
          asyncSuggestions: (value) async => await _fetchSuggestions(value)),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xFF0C9869),
          ),
          child: Text(
            'Velo',
            style: TextStyle(fontSize: 40),
            textAlign: TextAlign.center,
          ),
        ),
        ListTile(
            title: const Text('History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HistoryPage()));
            }),
        ListTile(
            title: const Text('Pay now'), onTap: () => Navigator.pop(context)),
        ListTile(
            title: const Text('Sign out'),
            onTap: () {
              Navigator.pop(context);
              GoogleAuth.signout();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                  (Route<dynamic> route) => false);
            }),
      ])),
      body: SafeArea(
        child: Stack(
          children: [
            isLocationAvailable
                ? MyMap(lat, long, stands)
                : Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator()),
            Column(
              children: [
                Spacer(),
                UserInfoBar(
                  name ?? "",
                  address ?? "Fetching your location...",
                  lat.toString(),
                  long.toString(),
                  points ?? "...",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getPoints() async {
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .get();
    points = snapshot.child("points").value.toString();
  }

  Future<String> getAddress() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    List<Placemark> addresses = await placemarkFromCoordinates(lat!, long!);
    var address = addresses.first;
    return "${address.name.toString()}, ${address.locality.toString()}, ${address.postalCode}";
  }
}
