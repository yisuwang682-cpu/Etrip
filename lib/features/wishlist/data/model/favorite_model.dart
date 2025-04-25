import 'package:hive/hive.dart';
part 'favorite_model.g.dart';

// 2. Enum لتحديد نوع العنصر المفضل
@HiveType(typeId: 0)
enum FavoriteType {
  @HiveField(0)
  place,
  @HiveField(1)
  activity,
  @HiveField(2)
  event,
}

@HiveType(typeId: 1)
class FavoriteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final FavoriteType type;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final String price;

  @HiveField(5)
  final String city;

  @HiveField(6)
  final String? additionalInfo;

  FavoriteModel({
    required this.id,
    required this.type,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.city,
    this.additionalInfo,
  });
}
