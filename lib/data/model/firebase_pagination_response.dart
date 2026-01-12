import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/domain/model/pagination_response.dart';

class FirebasePaginationResponse<T> extends PaginationResponse<T> {
  FirebasePaginationResponse({
    required super.hasMoreToLoad,
    required super.list,
    super.lastDoc,
  });

  factory FirebasePaginationResponse.empty() {
    return FirebasePaginationResponse<T>(
      hasMoreToLoad: true,
      list: <T>[],
      lastDoc: null,
    );
  }

  FirebasePaginationResponse<T> copyWith({
    bool? hasMoreToLoad,
    List<T>? list,
    DocumentSnapshot? lastDoc,
  }) {
    return FirebasePaginationResponse<T>(
      hasMoreToLoad: hasMoreToLoad ?? this.hasMoreToLoad,
      list: list ?? this.list,
      lastDoc: lastDoc ?? this.lastDoc,
    );
  }
}
