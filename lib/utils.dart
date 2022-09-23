import 'package:achizitii_cereale/constants.dart';
import 'package:intl/intl.dart';

class Utils {
  static formatPrice(double price) => numberFormat.format(price);
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}
