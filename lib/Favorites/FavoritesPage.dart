import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_app/SnappingSheets/profileSnappingSheetWrapper.dart';
import 'package:provider/provider.dart';

import 'FavoritesManager.dart';

class FavoritesPage extends StatelessWidget {
  final Set<WordPair> _favoritePairs;
  FavoritesPage(this._favoritePairs);

  @override
  Widget build(BuildContext context) {
    var favoritesManager = Provider.of<FavoritesManager>(context);
    final tiles = _favoritePairs.map(
      (WordPair pair) {
        return ListTile(
          title: Text(
            pair.asPascalCase,
            style: const TextStyle(fontSize: 18),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete_outline_rounded),
            onPressed: () {
              favoritesManager.removeWordPair(pair);
            },
          ),
        );
      },
    );
    final divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    var favoritesPageBody = ListView(children: divided);

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Suggestions'),
      ),
      body: ProfileSnappingSheetWrapper(favoritesPageBody),
    );
  }
}
