import 'package:hive/hive.dart';

part 'movies.g.dart';

@HiveType(typeId: 0)
class Movie extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String director;

  @HiveField(2)
  late String urlImage;
}
