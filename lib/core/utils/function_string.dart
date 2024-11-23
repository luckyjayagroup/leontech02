import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'env.dart';

String? makeStr(d) => (d == null)
    ? null
    : (d == 'null')
        ? null
        : d.toString();
int? makeInt(d) => (int.tryParse(d.toString()));
double? makeDouble(d) => (double.tryParse(d.toString()));
double? makeDouble2(d) => double.tryParse(d.toString().replaceAll(',', '.').replaceAll('.', '')) ?? 0;
bool? makeBool(d) => ((d is bool) ? d : bool.tryParse(d.toString()) ?? false);
bool isNumeric(String s) {
  if (s.isEmpty) {
    return false;
  }
  return num.tryParse(s) != null;
}

imagetoThumbs(s){return 'thumbs/$s';}
dp([String? str]) {
  // str ??= prosestxt;
  /* if (kDebugMode) {
    debugPrint(str);
  } */
  print(str??'');
}
setProses([String? s]) {
  dp(s);
  s ??= prosestxt;
  dp(s);
}

final CurrencyTextInputFormatter uangformatter = CurrencyTextInputFormatter.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp. ');
final CurrencyTextInputFormatter angkaformatter = CurrencyTextInputFormatter.currency(locale: 'id', decimalDigits: 0, symbol: "");
formatangka(a) => angkaformatter.formatDouble(double.tryParse(a.toString().replaceAll(",", "")) ?? 0);
formatuang(a) => uangformatter.formatDouble(double.tryParse(a.toString().replaceAll(",", "")) ?? 0);

String addWhere(String baseSql, String? whereCondition) {
  if (baseSql.isEmpty) {
    throw ArgumentError('Base SQL query cannot be empty');
  }

  String dynamicQuery = baseSql.trim();
  bool hasWhereClause = dynamicQuery.toUpperCase().contains('WHERE');
  if (whereCondition != null && whereCondition.isNotEmpty) {
    if (hasWhereClause) {
      dynamicQuery = dynamicQuery.replaceFirst('where', 'WHERE');
      dynamicQuery = dynamicQuery.replaceFirst('WHERE', 'WHERE $whereCondition AND');
    } else {
      dynamicQuery += ' WHERE $whereCondition';
    }
  }
  return dynamicQuery;
}
String createWhere(String source, List<String> fields) {
  // Split the source string into individual words
  List<String> words = source.toLowerCase().split(' ');

  // Create a list to hold all groups of conditions
  List<String> groups = [];

  // For each word, create a group of conditions
  for (var word in words) {
    var wordConditions = fields.map((field) => "LOWER($field) LIKE '%$word%'").toList();
    // Join conditions for the current word with OR
    groups.add('(${wordConditions.join(' OR ')})');
  }

  // Join the groups with AND
  return "(${groups.join(' AND ')})";
}

String formattanggal(String? tgl, [String format = "dd/MM/yy"]) {
  if (tgl == null) return '-';
  try {
    final tanggal = DateTime.tryParse(tgl) ?? DateTime.now();
    return DateFormat(format).format(tanggal);
  } catch (e) {
    dp("formattanggal(e): $e");
    return "-";
  }
}