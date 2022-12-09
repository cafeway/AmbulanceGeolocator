

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

class viewRequets extends StatefulWidget {
  const viewRequets({super.key});

  @override
  State<viewRequets> createState() => _viewRequetsState();
}

class _viewRequetsState extends State<viewRequets> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text(" Sos requests"),
        actions: []),

      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('users').doc(FirebaseAuth.instance.currentUser!.email).collection('requests').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          } else{
            return ListView(
              
              children: snapshot.data!.docs.map((doc){
                return  Card(
                  child: ListTile(
                    trailing: Icon(Icons.help),
                    leading:  Text(doc.get('organization')),
                    subtitle: Text("Status"),
                    title : Text(doc.get('status'))
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