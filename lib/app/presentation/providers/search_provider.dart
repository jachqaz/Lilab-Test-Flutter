import 'dart:async';

import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  bool _isSearchActive = false;
  Timer? _debounceTimer;

  bool get isSearchActive => _isSearchActive;

  void activateSearch() {
    _isSearchActive = true;
    searchFocusNode.requestFocus();
    notifyListeners();
  }

  void deactivateSearch() {
    _isSearchActive = false;
    searchController.clear();
    searchFocusNode.unfocus();
    _debounceTimer?.cancel();
    notifyListeners();
  }

  void toggleSearch() {
    if (_isSearchActive) {
      deactivateSearch();
    } else {
      activateSearch();
    }
  }

  void onSearchChanged(String query, Function(String) onSearch) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      onSearch(query);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
