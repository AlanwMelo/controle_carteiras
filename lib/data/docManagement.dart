import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_carteiras/data/stock.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DocManagement {
  final CollectionReference _docs = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('documents');

  createDoc({required String year, required String month}) async {
    Map<String, dynamic> updated = {'updated': DateTime.now()};
    Map<String, dynamic> data = {'created': DateTime.now()};

    await _docs.doc(year).set(updated);
    await _docs.doc(year).collection('months').doc(month).set(data);
    return true;

    /*_docs
        .doc('2025')
        .collection('months')
        .doc('janeiro')
        .collection('stocks')
        .doc('RBVA11')
        .set(data);*/
  }

  getDocuments() async {
    QuerySnapshot result = await _docs.get();
    return result;
  }

  getStocks(String year, String month) async {
    QuerySnapshot result = await _docs
        .doc(year)
        .collection('months')
        .doc(month)
        .collection('stocks')
        .get();
    return result;
  }

  getFIIs(String year, String month) async {
    QuerySnapshot result = await _docs
        .doc(year)
        .collection('months')
        .doc(month)
        .collection('fii')
        .get();
    return result;
  }

  saveStock(Stock stock, String year, String month) async {
    Map<String, dynamic> data = {
      'updated': DateTime.now(),
      'stock': stock.paper.replaceAll(' ', ''),
      'amount': stock.amount,
      'boughtValue': stock.boughtValue,
      'lastValue': stock.lastValue,
    };

    await _docs
        .doc(year)
        .collection('months')
        .doc(month)
        .collection('stocks')
        .doc(stock.paper.toUpperCase())
        .set(data);

    return true;
  }

  deleteStock(String stock, String year, String month) async {
    await _docs
        .doc(year)
        .collection('months')
        .doc(month)
        .collection('stocks')
        .doc(stock.toUpperCase())
        .delete();

    return true;
  }

  saveFII(Stock stock, String year, String month) async {
    Map<String, dynamic> data = {
      'updated': DateTime.now(),
      'stock': stock.paper.replaceAll(' ', ''),
      'amount': stock.amount,
      'boughtValue': stock.boughtValue,
      'lastValue': stock.lastValue,
    };

    await _docs
        .doc(year)
        .collection('months')
        .doc(month)
        .collection('fii')
        .doc(stock.paper.toUpperCase())
        .set(data);

    return true;
  }

  deleteFII(String stock, String year, String month) async {
    await _docs
        .doc(year)
        .collection('months')
        .doc(month)
        .collection('fii')
        .doc(stock.toUpperCase())
        .delete();

    return true;
  }

  getMonths(String year) async {
    QuerySnapshot result = await _docs.doc(year).collection('months').get();
    return result;
  }

  deleteMonth(String year, String month) async {
    await _docs.doc(year).collection('months').doc(month).delete();

    return true;
  }

  deleteYear(String year) async {
    await _docs.doc(year).delete();

    return true;
  }
}
