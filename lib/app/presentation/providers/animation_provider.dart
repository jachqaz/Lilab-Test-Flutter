import 'package:flutter/material.dart';

class AnimationProvider extends ChangeNotifier {
  bool _isLikeAnimating = false;
  int? _animatingPostId;

  bool get isLikeAnimating => _isLikeAnimating;

  int? get animatingPostId => _animatingPostId;

  void startLikeAnimation(int postId) {
    _isLikeAnimating = true;
    _animatingPostId = postId;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 300), () {
      _isLikeAnimating = false;
      _animatingPostId = null;
      notifyListeners();
    });
  }

  bool isAnimating(int postId) {
    return _isLikeAnimating && _animatingPostId == postId;
  }
}
