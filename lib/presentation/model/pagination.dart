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

  factory Pagination.empty() {
    return Pagination<T>(hasMoreToLoad: true, list: <T>[], lastDoc: null);
  }

  Pagination<T> copyWith({
    bool? hasMoreToLoad,
    List<T>? list,
    DocumentSnapshot? lastDoc,
  }) {
    return Pagination<T>(
      hasMoreToLoad: hasMoreToLoad ?? this.hasMoreToLoad,
      list: list ?? this.list,
      lastDoc: lastDoc ?? this.lastDoc,
    );
  }

  void addItemsToList(List<T> items) {
    list.addAll(items);
  }
}
