import 'package:intl/intl.dart';

final NumberFormat _currencyFormat = NumberFormat.simpleCurrency();

String formatCurrency(num amount) => _currencyFormat.format(amount);

final DateFormat _dateTimeFormat = DateFormat('MMM d, y • h:mm a');

String formatDateTime(DateTime dateTime) => _dateTimeFormat.format(dateTime);
