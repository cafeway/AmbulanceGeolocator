import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Extras/Constants.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:list_picker/list_picker.dart';

import '../Models/ MapMarker.dart';
import 'package:avatar_glow/avatar_glow.dart';




class AvailableCars extends StatefulWidget {
  const AvailableCars();

  @override
  State<AvailableCars> createState() => _AvailableCarsState();
}

class _AvailableCarsState extends State<AvailableCars> {

  Position? _currentPosition;
  double? lat;
  double? long;
  // flutter_map mapbox controller
  late final MapController Controller;
  @override
  void initState() {
    super.initState();

    Controller = MapController();
  }

  Future<void> _getUserLocation() async {
    await Geolocator.getCurrentPosition().then((Position position) => {
          setState(() {
            lat = position.latitude;
            long = position.latitude;
          }),
          _currentPosition = position,

          // print('$_currentPosition')
        });
  }

  @override
  Widget build(BuildContext context) {
    
    // for getting the choosen value
    final searchBarController = TextEditingController();
    final position = ModalRoute.of(context)!.settings.arguments as Map;
    // var b = position.toString();
    var a = position['lat'];
    var d = position['long'];
    var b = a.toString();
    var e = d.toString();
    var lat = double.parse(b);
    var long = double.parse(e);
    return Scaffold(
      appBar: AppBar(
        title: Text("Search For Ambulances"),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              minZoom: 2,
              maxZoom: 18,
              zoom: 10,
              center: LatLng(lat, long),
            
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                additionalOptions: {
                  'accessToken':
                      'sk.eyJ1IjoiYnJpYW5raWJ1aSIsImEiOiJjbDhvYWVmaHcxMjllM3pxamIwMmM2bzJkIn0.k2rqUT71Q0brMa_RwliduQ'
                },
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                      point: LatLng(lat, long),
                      height: 80,
                      width: 80,
                      builder: (_) {
                        return GestureDetector(
                          onTap: () {},
                          child: const AvatarGlow(
                      glowColor: Color.fromARGB(255, 179, 25, 14), endRadius: 150.0,
                      child: Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 190, 19, 7),
                        child: Icon(Icons.call),
                      ),
                    )),
                        );
                      }),
                      Marker(
                      point: LatLng(0.0511,37.6540),
                      height: 80,
                      width: 80,
                      builder: (_) {
                        return GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.location_on),
                        );
                      }),
                      Marker(
                      point: LatLng(0.0453186,37.657764),
                      height: 80,
                      width: 80,
                      builder: (_) {
                        return GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.location_on),
                        );
                      }),
                       Marker(
                      point: LatLng(0.0341717,37.6564363),
                      height: 80,
                      width: 80,
                      builder: (_) {
                        return GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.location_on),
                        );
                      }),
                       Marker(
                      point: LatLng(-0.0509,37.6546),
                      height: 80,
                      width: 80,
                      builder: (_) {
                        return GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.location_on),
                        );
                      }),
                       Marker(
                      point: LatLng(0.046599,37.6527916),
                      height: 80,
                      width: 80,
                      builder: (_) {
                        return GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.location_on),
                        );
                      }),
                       Marker(
                      point: LatLng(0.0511,37.6540),
                      height: 80,
                      width: 80,
                      builder: (_) {
                        return GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.location_on),
                        );
                      }),
                      
                ],
              ),
            ],
          ),
          ListPickerField(controller: searchBarController,label: 'Choose a nearby hospital', items: ["Meru Level Five", "Karen Hospital", "Meru Jordan Hospital","Woodlands Hospital Meru","Aga Khan Embu","Meru District Hospital","Consolata Missions Hospital"]),
          Positioned(
            top: 65,
            left: 120,
            child: TextButton(
            
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red),foregroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () async { 
            var parameters  = searchBarController.text;
            switch (parameters) {
              case "Meru Level Five":
                   var origin = LatLng(lat,long);
                   var destination = LatLng(-0.0509,37.6540);
                  requestAmbulance(origin,destination);
                break;
              default:
            }
            // final response = await mapbox.forwardGeocoding.request(
            //   searchText: "Nairobi university",
            //   fuzzyMatch: true,
            //   language: 'en',
            //   country: ['ke']
            // );
            

            // if (response.features != null && response.features!.isNotEmpty){
            //   for (final feature in response.features!){
            //     print('${feature.center}');
            //   }
            // }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your sos request has been sent successfully'")));
             
            }
            ,
          child: Text("Request Ambulance"),)),
        ],
      ),
    );
  }

void requestAmbulance(LatLng origin,LatLng destination) {
  Navigator.pushNamed(context, 'navigate', arguments: {
    'origin': origin,
    'destination': destination
  });
}

}

