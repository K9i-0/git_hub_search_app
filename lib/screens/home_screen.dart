import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/repository.dart';
import '../providers/github_provider.dart';
import '../utils/constants.dart';
import '../utils/error_handler.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/repository_card.dart';
import '../widgets/search_bar.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = Provider.of<GitHubProvider>(context, listen: false);
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        provider.hasMoreData &&
        !provider.isLoadingMore &&
        provider.status == SearchStatus.success) {
      provider.loadMoreRepositories();
    }
  }

  void _navigateToDetails(Repository repository) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(repository: repository),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        elevation: 0,
      ),
      body: Column(
        children: [
          Consumer<GitHubProvider>(
            builder: (context, provider, _) {
              return GitHubSearchBar(
                initialValue: provider.searchQuery,
                isLoading: provider.status == SearchStatus.loading && provider.repositories.isEmpty,
                onSearch: (query) {
                  provider.searchRepositories(query);
                },
              );
            },
          ),
          Expanded(
            child: Consumer<GitHubProvider>(
              builder: (context, provider, _) {
                // Empty state
                if (provider.status == SearchStatus.idle) {
                  return const EmptySearchResults(
                    message: AppConstants.searchEmpty,
                    icon: Icons.search,
                  );
                }

                // Initial loading state
                if (provider.status == SearchStatus.loading && provider.repositories.isEmpty) {
                  return const LoadingIndicator();
                }

                // Error state
                if (provider.status == SearchStatus.error && provider.repositories.isEmpty) {
                  return ErrorDisplay(
                    message: ErrorHelper.getMessageForUser(provider.error!),
                    onRetry: () => provider.searchRepositories(provider.searchQuery),
                  );
                }

                // No results
                if (provider.repositories.isEmpty) {
                  return const EmptySearchResults(
                    message: AppConstants.searchNoResults,
                  );
                }

                // Results list with pagination
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: provider.repositories.length + (provider.hasMoreData ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Loading indicator at the end
                    if (index == provider.repositories.length) {
                      return const LoadingMoreIndicator();
                    }

                    // Repository item
                    final repository = provider.repositories[index];
                    return Hero(
                      tag: 'repo_${repository.id}',
                      child: RepositoryCard(
                        repository: repository,
                        onTap: () => _navigateToDetails(repository),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}