import 'package:flutter/foundation.dart';
import '../models/repository.dart';
import '../models/search_result.dart';
import '../services/github_service.dart';

enum SearchStatus { idle, loading, success, error }

class GitHubProvider with ChangeNotifier {
  final GitHubService _gitHubService;
  
  String _searchQuery = '';
  SearchResult _searchResult = SearchResult.empty();
  SearchStatus _status = SearchStatus.idle;
  Exception? _error;
  int _currentPage = 1;
  bool _hasMoreData = true;
  bool _isLoadingMore = false;
  
  GitHubProvider({GitHubService? gitHubService})
      : _gitHubService = gitHubService ?? GitHubService();
  
  // Getters
  String get searchQuery => _searchQuery;
  List<Repository> get repositories => _searchResult.items;
  SearchStatus get status => _status;
  Exception? get error => _error;
  bool get hasMoreData => _hasMoreData;
  bool get isLoadingMore => _isLoadingMore;
  
  // Search for repositories
  Future<void> searchRepositories(String query) async {
    if (query.isEmpty) {
      _searchQuery = '';
      _searchResult = SearchResult.empty();
      _status = SearchStatus.idle;
      _error = null;
      _currentPage = 1;
      _hasMoreData = true;
      notifyListeners();
      return;
    }
    
    if (_searchQuery != query) {
      _searchQuery = query;
      _currentPage = 1;
      _searchResult = SearchResult.empty();
      _hasMoreData = true;
    }
    
    _status = SearchStatus.loading;
    _error = null;
    notifyListeners();
    
    try {
      final result = await _gitHubService.searchRepositories(
        query,
        page: _currentPage,
      );
      
      if (_currentPage == 1) {
        _searchResult = result;
      } else {
        // Append to existing results
        final updatedItems = [..._searchResult.items, ...result.items];
        _searchResult = SearchResult(
          items: updatedItems,
          totalCount: result.totalCount,
          incompleteResults: result.incompleteResults,
        );
      }
      
      _hasMoreData = _searchResult.items.length < _searchResult.totalCount;
      _status = SearchStatus.success;
      
    } catch (e) {
      _status = SearchStatus.error;
      _error = e as Exception;
    } finally {
      notifyListeners();
    }
  }
  
  // Load more repositories (pagination)
  Future<void> loadMoreRepositories() async {
    if (!_hasMoreData || _isLoadingMore || _status == SearchStatus.loading) {
      return;
    }
    
    _isLoadingMore = true;
    notifyListeners();
    
    try {
      _currentPage++;
      final result = await _gitHubService.searchRepositories(
        _searchQuery,
        page: _currentPage,
      );
      
      final updatedItems = [..._searchResult.items, ...result.items];
      _searchResult = SearchResult(
        items: updatedItems,
        totalCount: result.totalCount,
        incompleteResults: result.incompleteResults,
      );
      
      _hasMoreData = _searchResult.items.length < _searchResult.totalCount;
      
    } catch (e) {
      _currentPage--;
      _error = e as Exception;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }
  
  // Clear search results
  void clearSearch() {
    _searchQuery = '';
    _searchResult = SearchResult.empty();
    _status = SearchStatus.idle;
    _error = null;
    _currentPage = 1;
    _hasMoreData = true;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _gitHubService.dispose();
    super.dispose();
  }
}