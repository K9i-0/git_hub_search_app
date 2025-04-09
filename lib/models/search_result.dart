import 'package:dreamflow/models/repository.dart';

class SearchResult {
  final List<Repository> items;
  final int totalCount;
  final bool incompleteResults;

  SearchResult({
    required this.items,
    required this.totalCount,
    required this.incompleteResults,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    final List<dynamic> itemsJson = json['items'] as List<dynamic>;
    final List<Repository> repositoryList = itemsJson
        .map((dynamic item) =>
            Repository.fromJson(item as Map<String, dynamic>))
        .toList();

    return SearchResult(
      items: repositoryList,
      totalCount: json['total_count'] as int,
      incompleteResults: json['incomplete_results'] as bool,
    );
  }

  factory SearchResult.empty() {
    return SearchResult(
      items: [],
      totalCount: 0,
      incompleteResults: false,
    );
  }
}