import 'package:intl/intl.dart';

final DateFormat _formatadorPadrao = DateFormat('dd/MM/yyyy');

String formatarData(DateTime? data) {
  if (data == null) {
    return '--/--/----';
  }
  return _formatadorPadrao.format(data);
}
