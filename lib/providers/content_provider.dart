import 'package:flutter/material.dart';
import '../models/app_category.dart';
import '../models/video_item.dart';
import '../services/content_service.dart';

class ContentProvider extends ChangeNotifier {
  final _service = ContentService();
  List<AppCategory> categories = [];
  List<VideoItem> videos = [];
  String? selectedCategoryId;
  bool loading = true;

  Future<void> loadInitial() async {
    loading = true; notifyListeners();
    categories = await _service.fetchCategories();
    await selectCategory(null);
    loading = false; notifyListeners();
  }

  Future<void> selectCategory(String? id) async {
    selectedCategoryId = id;
    videos = await _service.fetchVideos(categoryId: id);
    notifyListeners();
  }
}
