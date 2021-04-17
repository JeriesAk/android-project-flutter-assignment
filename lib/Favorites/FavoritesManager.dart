import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/widgets.dart';

class FavoritesManager with ChangeNotifier {
  final favorites = <WordPair>{};
  bool _connectedToCloud = false;
  String _firebaseCollectionId = '';

  bool pairIsFavorite(WordPair pair) => favorites.contains(pair);

  Future<void> connectToCloud(String userId) {
    if(_connectedToCloud) {
      return Future.delayed(Duration.zero);
    }
    _connectedToCloud = true;
    _firebaseCollectionId = userId;

    var collection = _getCollectionReference();

    return collection.get().then((QuerySnapshot querySnapshot) {
      favorites.addAll(querySnapshot.docs
          .map((e) => WordPair(e.data()['first'], e.data()['second']))
          .toList());
      print('Added word pairs from cloud');

      notifyListeners();

      favorites.forEach((element) => _getCollectionReference()
          .doc(element.toString())
          .set({'first': element.first, 'second': element.second}));
    });
  }

  void disconnectFromCloud() {
    _connectedToCloud = false;
  }

  CollectionReference _getCollectionReference() =>
      FirebaseFirestore.instance.collection(_firebaseCollectionId);

  Future<void> addWordPair(WordPair pair) {
    favorites.add(pair);
    notifyListeners();
    if (_connectedToCloud) {
      return _getCollectionReference()
          .doc(pair.toString())
          .set({'first': pair.first, 'second': pair.second});
    }

    return Future.delayed(Duration.zero);
  }

  Future<void> removeWordPair(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
    if (_connectedToCloud) {
      return _getCollectionReference().doc(pair.toString()).delete();
    }

    return Future.delayed(Duration.zero);
  }
}
