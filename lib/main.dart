import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_app/Favorites/FavoritesPage.dart';
import 'file:///C:/Users/jeabukhadra/StudioProjects/android-project-flutter-assignment/lib/LogInScreen/loginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'Authentication/UserState.dart';
import 'Favorites/FavoritesManager.dart';
import 'SnappingSheets/profileSnappingSheetWrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserState.instance()),
    ChangeNotifierProvider(create: (_) => FavoritesManager())
  ], child: App()));
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter',
        home: RandomWords(),
        theme: ThemeData(primaryColor: Colors.red));
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  final _x = <WordPair>[];

  FavoritesManager _getFavoritesManager() =>
      Provider.of<FavoritesManager>(context);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        // The itemBuilder callback is called once per suggested
        // word pairing, and places each suggestion into a ListTile
        // row. For even rows, the function adds a ListTile row for
        // the word pairing. For odd rows, the function adds a
        // Divider widget to visually separate the entries. Note that
        // the divider may be difficult to see on smaller devices.
        itemBuilder: (BuildContext _context, int i) {
          // Add a one-pixel-high divider widget before each row
          // in the ListView.
          if (i.isOdd) {
            return Divider();
          }

          // The syntax "i ~/ 2" divides i by 2 and returns an
          // integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings
          // in the ListView,minus the divider widgets.
          final int index = i ~/ 2;
          // If you've reached the end of the available word
          // pairings...
          if (index >= _suggestions.length) {
            // ...then generate 10 more and add them to the
            // suggestions list.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    var favoritesManager = _getFavoritesManager();
    final alreadySaved = favoritesManager.pairIsFavorite(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        if (alreadySaved) {
          favoritesManager.removeWordPair(pair);
          _x.remove(pair);
        } else {
          favoritesManager.addWordPair(pair);
          _x.add(pair);
        }
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {
        return FavoritesPage(_getFavoritesManager().favorites);
      }),
    );
  }

  void _onLoginButtonPress() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Login'),
              centerTitle: true,
            ),
            body: LoginPage(),
          );
        }, // ...to here.
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserState>(context);
    final actionsArray = [
      IconButton(
          icon: Icon(Icons.favorite),
          onPressed: _pushSaved,
          tooltip: 'Favourites')
    ];

    final isUserLoggedIn = user.isUserLoggedIn();

    var favoritesManager = Provider.of<FavoritesManager>(context);

    if (!isUserLoggedIn) {
      setState(() {
        actionsArray.add(IconButton(
            icon: Icon(Icons.login),
            onPressed: _onLoginButtonPress,
            tooltip: 'Log In'));
        favoritesManager.disconnectFromCloud();
      });
    } else {
      setState(() {
        actionsArray.add(IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => user.signOut(),
            tooltip: 'Log Out'));
        favoritesManager.connectToCloud(user.getUserEmail());
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: actionsArray,
      ),
      body: ProfileSnappingSheetWrapper(() => _buildSuggestions())
    );
  }
}