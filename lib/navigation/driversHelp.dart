

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Extras/Constants.dart';
import 'package:flutter_map/plugin_api.dart';

class driversRequests extends StatefulWidget {
  const driversRequests({super.key});

  @override
  State<driversRequests> createState() => _driversRequestsState();
}

class _driversRequestsState extends State<driversRequests> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text("Patients who need help"),
        actions: []),

      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('requests').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          } else{
            return ListView(
              
              children: snapshot.data!.docs.map((doc){
                return  Card(
                  child: ListTile(
                    onTap: () {
                      
                    },
                    trailing: Icon(Icons.help),
                    leading:  Text(doc.get('organization')),
                    subtitle: Text(doc.get('time').toString()),
                    title : Text("Time"),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}