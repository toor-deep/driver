import 'package:intl/intl.dart';

String extractDate(String dateTimeString) {
  if(dateTimeString.isEmpty){
    return '';
  }
  // Parse the string to DateTime
  DateTime parsedDate = DateTime.parse(dateTimeString);

  // Format the date as 'yyyy-MM-dd' or any desired format
  String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

  return formattedDate;
}