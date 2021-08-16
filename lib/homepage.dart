import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:movies_app/db/boxes.dart';
import 'package:movies_app/db/model/movies.dart';
import 'package:movies_app/widgets/movie_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    Hive.box('movies').close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('MyFlix'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Colors.black, Colors.pink, Colors.red])),
          ),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<Movie>>(
          valueListenable: Boxes.getMovies().listenable(),
          builder: (context, box, _) {
            final movies = box.values.toList().cast<Movie>();

            return movieContent(movies);
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink,
          child: Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => MovieDialog(
              onClick: addMovie,
            ),
          ),
        ),
      );

  Widget movieContent(List<Movie> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Text(
          'No movies added yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          final movie = movies[index];

          return movieCard(context, movie);
        },
      );
    }
  }

  Widget movieCard(
    BuildContext context,
    Movie movie,
  ) {
    final title = movie.title;
    final director = movie.director;
    final image = movie.urlImage;

    return Container(
      margin: EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.network(
                image.toString(),
                fit: BoxFit.fill,
              ),
            ),
            ListTile(
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w100,
                ),
              ),
              subtitle: Text("By " + director),
            ),
            bottomButtons(context, movie),
          ],
        ),
      ),
    );
  }

  Widget bottomButtons(BuildContext context, Movie movie) => Row(
        children: [
          Expanded(
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.pink,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => MovieDialog(
                  movie: movie,
                  onClick: (title, director, image) =>
                      editMovie(movie, title, director, image),
                ),
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () => deleteMovie(movie),
            ),
          )
        ],
      );

  Future addMovie(String title, String director, String image) async {
    final transaction = Movie()
      ..title = title
      ..director = director
      ..urlImage = image;

    final box = Boxes.getMovies();
    box.add(transaction);
  }

  void editMovie(
    Movie movie,
    String title,
    String director,
    String image,
  ) {
    movie.title = title;
    movie.director = director;
    movie.urlImage = image;

    movie.save();
  }

  void deleteMovie(Movie movie) {
    movie.delete();
  }
}
