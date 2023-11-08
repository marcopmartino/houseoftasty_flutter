import 'package:houseoftasty/network/ProductNetwork.dart';
import 'package:houseoftasty/utility/NotificationService.dart';
import 'package:intl/intl.dart';

class ScheduledFunction {
  @pragma('vm:entry-point')
  static void checkExpire() async {
    var expire = 0;
    var products = await ProductNetwork.getCurrentUserProductsOnce();

    for (var product in products.docs) {
      if (product.exists) {
        if (checkData(product['scadenza'])) expire++;
      }
    }

    if (expire > 1) {
      NotificationService.showNotification(title: 'Prodotto in scadenza!',
          body: 'Uno dei tuoi prodotti è in scadenza!');
    } else if (expire == 1) {
      NotificationService.showNotification(title: 'Prodotti in scadenza!',
          body: 'Alcuni dei tuoi prodotti sono in scadenza!');
    }
  }


  static bool checkData(String data) {
    if (data == '--/--/----') {
      return false;
    }

    int diff;

    DateTime now = DateTime.now();
    DateTime date = DateFormat('dd/MM/yyyy').parse(data);
    now.isAfter(date) ? diff = 0 : diff = now
        .difference(date)
        .inDays;

    int daysBetween(DateTime now, DateTime date) {
      now = DateTime(now.year, now.month, now.day);
      date = DateTime(date.year, date.month, date.day);
      return (date
          .difference(now)
          .inHours / 24).round();
    }
    diff = daysBetween(now, date);

    if (diff < 0) {
      return true;
    } else if (diff <= 2 && diff > 0) {
      return true;
    }

    return false;
  }

}