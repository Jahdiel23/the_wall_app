import 'package:cloud_firestore/cloud_firestore.dart';

/// Función para formatear un objeto `Timestamp` de Firebase en una cadena de texto legible.
String formatData(Timestamp timestamp) {
  // `timestamp` es el objeto que obtenemos de Firebase.
  // Para mostrarlo, lo convertimos a un objeto `DateTime`.
  DateTime dataTime = timestamp.toDate();

  // Obtener el año del objeto `DateTime`.
  String year = dataTime.year.toString();

  // Obtener el mes del objeto `DateTime`.
  String month = dataTime.month.toString();

  // Obtener el día del objeto `DateTime`.
  String day = dataTime.day.toString();

  // Construir la fecha formateada en el formato `día/mes/año`.
  String formattedData = '$day/$month/$year';

  // Retornar la fecha como cadena formateada.
  return formattedData;
}