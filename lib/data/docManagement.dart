import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DocManagement {
  final CollectionReference _docs = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('documents');

  createDoc() {
    Map<String, dynamic> data = {'teste': 'testa'};

    _docs
        .doc('2025')
        .collection('months')
        .doc('janeiro')
        .collection('stocks')
        .doc('RBVA11')
        .set(data);
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