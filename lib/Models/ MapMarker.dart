import 'package:latlong2/latlong.dart';

class MapMarker {
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location;
  final int? rating;



  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
    required this.rating,
  }); 
}

final Markers =[
  MapMarker(
    image: 'assets/images/hospital.jpeg',
    title: 'Meru Teaching and Refferal',
    address: 'Meru Town',
    location: LatLng(0.0511,37.6540),
     rating: 3),

     MapMarker(
    image: 'assets/images/hospital.jpeg',
    title: 'Karen Hospital Meru',
    address: 'Meru Town',
    location: LatLng(0.0453186,37.657764),
     rating: 4),

     MapMarker(
    image: 'assets/images/hospital.jpeg',
    title: 'Meru Jordan Hospital',
    address: 'Meru Town',
    location: LatLng(0.05,37.65),
     rating: 3),
];