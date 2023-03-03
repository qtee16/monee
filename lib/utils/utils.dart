import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as prefix0;
import 'package:intl/intl.dart' as intl;

final key = prefix0.Key.fromLength(32);
final iv = IV.fromLength(16);
final encrypter = Encrypter(AES(key));

String encrypt(String plainText) {
  if(plainText.isEmpty) {
    return "";
  }
  try {
    return encrypter.encrypt(plainText, iv: iv).base64;
  } catch (e) {
    return plainText;
  }
}

final formatter = intl.NumberFormat.decimalPattern();

String formatDate(DateTime dateTime) {
  return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
}

String formatDateCollection(DateTime dateTime) {
  return "${dateTime.month}-${dateTime.year}";
}

