import 'package:cloud_firestore/cloud_firestore.dart';
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

  getMonths(String year) async {
    QuerySnapshot result = await _docs.doc(year).collection('months').get();
    return result;
  }
}
