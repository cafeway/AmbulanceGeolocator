

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
import 'package:mapbox_search/mapbox_search.dart';

class AvailableCars extends StatefulWidget {
  const AvailableCars({super.key});

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
  void initState(){
    super.initState();    
     
    Controller = MapController();
  } 
  
  
  
  Future <void>_getUserLocation() async {
   await Geolocator.getCurrentPosition().then((Position position) => {
     setState((){
      lat = position.latitude;
      long = position.latitude;
     }),
    _currentPosition = position,
    
    // print('$_currentPosition')
   });
  }




  @override
  Widget build(BuildContext context) {
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
            FlutterMap(options: MapOptions(
              minZoom: 2,
              maxZoom: 18,
              zoom: 13,
              center: LatLng(lat,long),
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                additionalOptions: {
                  'accessToken': 'sk.eyJ1IjoiYnJpYW5raWJ1aSIsImEiOiJjbDhvYWVmaHcxMjllM3pxamIwMmM2bzJkIn0.k2rqUT71Q0brMa_RwliduQ'
                },
              ),
            MarkerLayerOptions(
              markers: [
                Marker(
                point: LatLng(lat,long) , 
                height: 80,
                width: 80,
                builder: (_){
                return GestureDetector(
                  onTap:  () {
                      
                  },
                  child: Icon(Icons.location_on),
                );
                })
              ],
            ),
            ],
            ),
            ListPickerField(label: 'ambulances', items: [
              "sss","bbb","ggg"
            ]),
          ],
      ),
    );
 }
 
}