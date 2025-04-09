import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/repository.dart';
import '../models/search_result.dart';
import '../utils/error_handler.dart';

class GitHubService {
  final String _baseUrl = 'api.github.com';
  final http.Client _client;

  GitHubService({http.Client? client}) : _client = client ?? http.Client();

  Future<SearchResult> searchRepositories(String query, {int page = 1, int perPage = 30}) async {
    if (query.isEmpty) {
      return SearchResult.empty();
    }

    final queryParams = {
      'q': query,
      'page': page.toString(),
      'per_page': perPage.toString(),
    };

    final uri = Uri.https(_baseUrl, '/search/repositories', queryParams);

    try {
      final response = await _client.get(
        uri,
        headers: {
          'Accept': 'application/vnd.github.v3+json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SearchResult.fromJson(data);
      } else if (response.statusCode == 403) {
        throw ApiRateLimitException('GitHub API rate limit exceeded. Please try again later.');
      } else if (response.statusCode >= 500) {
        throw ServerException('GitHub server error. Please try again later.');
      } else {
        throw ApiException('Failed to search repositories: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw NetworkException('Network error: ${e.toString()}');
    }
  }

  void dispose() {
    _client.close();
  }
}