import 'package:flutter/foundation.dart';
import '../models/app_category.dart' as app_models;
import '../models/video_item.dart';
import '../services/content_service.dart';

class ContentProvider with ChangeNotifier {
  final _service = ContentService();
  List<app_models.AppCategory> categories = [];
  List<VideoItem> videos = [];
  int? selectedCategoryId;

  bool loading = false;

  Future<void> load() async {
    loading = true;
    notifyListeners();
    try {
      categories = await _service.fetchCategories();
      videos = await _service.fetchVideos();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> filterByCategory(int? id) async {
    selectedCategoryId = id;
    loading = true;
    notifyListeners();
    try {
      videos = await _service.fetchVideos(categoryId: id);
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
