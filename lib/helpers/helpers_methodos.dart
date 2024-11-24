import 'package:cloud_firestore/cloud_firestore.dart';

String formatData(Timestamp timestamp){
  //timestam is the objet we retrive from firebase
  //so to dislay it, lests convert it to a string
  DateTime dataTime = timestamp.toDate();

  //get year
  String year = dataTime.year.toString();

  //get month
  String month = dataTime.month.toString();

  //get day 
  String day = dataTime.day.toString();

  //final formatted date
  String formattedData = '$day/$month/$year';

  return formattedData;
}