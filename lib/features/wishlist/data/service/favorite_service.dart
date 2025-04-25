import 'package:egyptopia/features/wishlist/data/model/favorite_model.dart';
import 'package:hive/hive.dart';

class FavoriteService {
  static const String boxName = 'favorites_box';

  static Future<void> initHive() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(FavoriteTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FavoriteModelAdapter());
    }
    
    await Hive.openBox<FavoriteModel>(boxName);
  }

  static Box<FavoriteModel> get _box => Hive.box<FavoriteModel>(boxName);

  static List<FavoriteModel> getAllFavorites() => _box.values.toList();

  static List<FavoriteModel> getFavoritesByType(FavoriteType type) {
    return _box.values.where((fav) => fav.type == type).toList();
  }

  static bool isFavorite(String id, FavoriteType type) {
    final key = '${id}_${type.name}';
    return _box.containsKey(key);
  }

  static Future<void> addFavorite(FavoriteModel model) async {
    final key = '${model.id}_${model.type.name}';
    await _box.put(key, model);
  }

  static Future<void> removeFavorite(String id, FavoriteType type) async {
    final key = '${id}_${type.name}';
    await _box.delete(key);
  }

  static Future<void> toggleFavorite(FavoriteModel model) async {
    if (isFavorite(model.id, model.type)) {
      await removeFavorite(model.id, model.type);
    } else {
      await addFavorite(model);
    }
  }
}
