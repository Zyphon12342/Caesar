import 'package:flutter/material.dart';

extension ScrollControllerExtensions on ScrollController {
  void scrollToBottom() {
    if (hasClients) {
      animateTo(
        position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}