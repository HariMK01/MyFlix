import 'package:hive/hive.dart';
import 'model/movies.dart';

class Boxes {
  static Box<Movie> getMovies() => Hive.box<Movie>('movies');
}
