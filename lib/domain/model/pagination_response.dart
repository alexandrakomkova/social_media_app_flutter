import 'package:cloud_firestore/cloud_firestore.dart';

class PaginationResponse<T> {
  final bool hasMoreToLoad;
  final List<T> list;
  final DocumentSnapshot? lastDoc;

  PaginationResponse({
    required this.hasMoreToLoad,
    required this.list,
    this.lastDoc,
  });
}
