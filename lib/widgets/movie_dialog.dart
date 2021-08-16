import 'package:flutter/material.dart';
import 'package:movies_app/db/model/movies.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MovieDialog extends StatefulWidget {
  final Movie? movie;
  final Function(String title, String director, String urlImage) onClick;

  const MovieDialog({
    Key? key,
    this.movie,
    required this.onClick,
  }) : super(key: key);

  @override
  _MovieDialogState createState() => _MovieDialogState();
}

class _MovieDialogState extends State<MovieDialog> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _director = TextEditingController();
  final _urlImage = TextEditingController();

  bool isExpense = true;

  @override
  void initState() {
    super.initState();

    if (widget.movie != null) {
      final movie = widget.movie!;

      _title.text = movie.title;
      _director.text = movie.director;
      _urlImage.text = movie.urlImage;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _director.dispose();
    _urlImage.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.movie != null;
    final title = isEditing ? 'Edit Movie' : 'Add Movie';

    return AlertDialog(
      content: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorColor: Colors.pink,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      icon: Icon(FontAwesomeIcons.heading),
                    ),
                    controller: _title,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter title of the movie!';
                      } else {
                        if (value.length > 150) {
                          return 'Total characters exceeded';
                        } else {
                          return null;
                        }
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorColor: Colors.pink,
                    decoration: InputDecoration(
                      labelText: 'Director',
                      icon: Icon(FontAwesomeIcons.film),
                    ),
                    controller: _director,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name of the director!';
                      } else {
                        if (value.length > 200) {
                          return 'Total characters exceeded';
                        } else {
                          return null;
                        }
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorColor: Colors.pink,
                    decoration: InputDecoration(
                      labelText: 'Poster',
                      icon: Icon(FontAwesomeIcons.image),
                    ),
                    controller: _urlImage,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an image url!';
                      } else {
                        if (Uri.parse(value).isAbsolute) {
                          return null;
                        } else {
                          return 'Please enter a valid url!';
                        }
                      }
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.pink),
                      ),
                      child: Text(
                        isEditing ? "Save" : "Add",
                        style: TextStyle(fontWeight: FontWeight.w100),
                      ),
                      onPressed: () async {
                        final isValid = _formKey.currentState!.validate();
                        _formKey.currentState!.save();

                        if (isValid) {
                          final title = _title.text;
                          final director = _director.text;
                          final urlImage = _urlImage.text;

                          widget.onClick(title, director, urlImage);

                          Navigator.of(context).pop();
                        }
                      },
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
