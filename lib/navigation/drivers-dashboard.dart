// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Extras/Constants.dart';
import 'package:flutter_map/plugin_api.dart';
class driversDashboard extends StatefulWidget {
  const driversDashboard({super.key});

  @override
  State<driversDashboard> createState() => _driversDashboardState();
}

class _driversDashboardState extends State<driversDashboard> {
  Position?  _currentPosition;
  double? lat;
  double long= 0.0;
final Future<SharedPreferences> preferences =SharedPreferences.getInstance();

  // flutter_map mapbox controller
  late final MapController Controller;
  @override
  void initState(){
    super.initState();   
            _getUserLocation(); 
    Controller = MapController();
  }
  @override
  Widget build(BuildContext context) {
 
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Ambulance Geolocsator"),
            centerTitle: true,
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(
                  Icons.home_filled,
                  color: Colors.green,
                ),
                text: "Home",
              ),
            
              
            ]),
          ),
          body: TabBarView(children: [
            GridView.count(
              crossAxisCount: 1,
              padding: EdgeInsets.all(3.0),
              children: [
                Card(
                    elevation: 1.0,
                    margin: EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(220, 220, 220, 1.0)),
                      child: InkWell(
                        onTap: () {
                             Navigator.pushNamed(context, 'drivers-help');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          verticalDirection: VerticalDirection.down,
                          children: const <Widget>[
                            SizedBox(height: 50.0),
                            Center(
                                child: Icon(
                              Icons.remove_red_eye,
                              size: 40.0,
                              color: Colors.red,
                            )),
                            SizedBox(height: 20.0),
                            Center(
                              child: Text("View Help Requests",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color.fromARGB(255, 165, 14, 14))),
                            )
                          ],
                        ),
                      ),
                    )),
                Card(
                    elevation: 1.0,
                    margin: EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(220, 220, 220, 1.0)),
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          verticalDirection: VerticalDirection.down,
                          children: const <Widget>[
                            SizedBox(height: 50.0),
                            Center(
                                child: Icon(
                              Icons.location_history,
                              size: 40.0,
                              color: Color.fromARGB(255, 14, 155, 21),
                            )),
                            SizedBox(height: 20.0),
                            Center(
                              child: Text("Trip History",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Color.fromARGB(255, 63, 201, 9))),
                            )
                          ],
                        ),
                      ),
                    )),
                Card(
                    elevation: 1.0,
                    margin: EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(220, 220, 220, 1.0)),
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          verticalDirection: VerticalDirection.down,
                          children: const <Widget>[
                            SizedBox(height: 50.0),
                            Center(
                                child: Icon(
                              Icons.payment,
                              size: 40.0,
                              color: Color.fromARGB(255, 173, 175, 15),
                            )),
                            SizedBox(height: 20.0),
                            Center(
                              child: Text("Billing",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color:
                                          Color.fromARGB(255, 209, 212, 18))),
                            )
                          ],
                        ),
                      ),
                    )),
                // Card(
                //     elevation: 1.0,
                //     margin: EdgeInsets.all(8.0),
                //     child: Container(
                //       decoration: BoxDecoration(
                //           color: Color.fromRGBO(220, 220, 220, 1.0)),
                //       child: InkWell(
                //         onTap: () {
                //           Geolocator.getCurrentPosition().then((Position positon) => {
                //             Navigator.pushNamed(context, 'showMap',arguments: {
                //               positon      
                //             })
                //           });
                //           Navigator.pushNamed(context, 'showMap',
                        
                //           );
                //         },
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.stretch,
                //           mainAxisSize: MainAxisSize.min,
                //           verticalDirection: VerticalDirection.down,
                //           children: const <Widget>[
                //             SizedBox(height: 50.0),
                //             Center(
                //                 child: Icon(
                //               Icons.map,
                //               size: 40.0,
                //               color: Colors.black,
                //             )),
                //             SizedBox(height: 20.0),
                //             Center(
                //               child: Text("View Map",
                //                   style: TextStyle(
                //                       fontSize: 18.0, color: Colors.black)),
                //             )
                //           ],
                //         ),
                //       ),
                //     )),
            
                Card(
                    elevation: 1.0,
                    margin: EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(220, 220, 220, 1.0)),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, 'navigate');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          verticalDirection: VerticalDirection.down,
                          children: const <Widget>[
                            SizedBox(height: 50.0),
                            Center(
                                child: Icon(
                              Icons.track_changes_rounded,
                              size: 40.0,
                              color: Color.fromARGB(255, 26, 115, 150),
                            )),
                            SizedBox(height: 20.0),
                            Center(
                              child: Text("Track progress",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color:
                                          Color.fromARGB(255, 33, 165, 165))),
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Container(
                width: 200,
                height: 50,
                child: Column(
                  children:  [
                    
                     AvatarGlow(
                      glowColor: Color.fromARGB(255, 179, 25, 14), endRadius: 150.0,
                      child: Material(
                      elevation: 8.0,
                      shape: CircleBorder(),
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 190, 19, 7),
                        child: Icon(Icons.call),
                      ),
                    )),
                  
                    SizedBox(
                      height: 10,
                    ),
                  
                    TextButton(
                      onPressed: (){
                
                        var a  ="brian";
                        Navigator.pushNamed(context, 'showMap',arguments: {
                          'lat': _currentPosition?.latitude.toDouble(),
                           'long': _currentPosition?.longitude.toDouble()
                        });
                      },
                     child: Text("View Available Ambulances"),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 80, 156, 218)),foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)))),
                   
                  SizedBox(
                      height: 10,
                    ),
                  Text("${_currentPosition?.latitude}") 
                  ]
                ),
              ),
            ), 
        
           
          ]),
        ));
  }

  Card makeDashbordCards(String title, IconData icon) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
        child: InkWell(
          onTap: () {},
        ),
      ),
    );
  }
   Future<void> _getUserLocation() async {
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position position){
      setState(() {
        lat = position.latitude;
        _currentPosition = position;
        
      });
    });
   
  }
}


