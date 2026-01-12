import 'package:cloud_firestore/cloud_firestore.dart';

class Pagination<T> {
  final DocumentSnapshot? lastDoc;
  final bool hasMoreToLoad;
  final List<T> list;

  Pagination({
    required this.list,
    required this.lastDoc,
    required this.hasMoreToLoad,
  });
}
