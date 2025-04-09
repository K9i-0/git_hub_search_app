import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/constants.dart';

class GitHubSearchBar extends StatefulWidget {
  final void Function(String) onSearch;
  final String initialValue;
  final bool isLoading;

  const GitHubSearchBar({
    Key? key,
    required this.onSearch,
    this.initialValue = '',
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<GitHubSearchBar> createState() => _GitHubSearchBarState();
}

class _GitHubSearchBarState extends State<GitHubSearchBar> {
  late TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(query.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: AppConstants.searchHint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: widget.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        widget.onSearch('');
                      },
                    )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        ),
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) => widget.onSearch(value.trim()),
      ),
    );
  }
}