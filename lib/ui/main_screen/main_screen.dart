import 'package:books_app/data/book.dart';
import 'package:books_app/ui/favorites_screen/favorites_route.dart';
import 'package:books_app/ui/favorites_screen/favorites_screen.dart';
import 'package:books_app/ui/widgets/book_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _MainScreenState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: _buildAppBar,
        setState: setState,
        onSubmitted: (_) {
          print("submitted");
        },
        onCleared: () {},
        onClosed: () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: searchBar.build(context),
        body: ListView.separated(
            separatorBuilder: (context, index) => Divider(height: 4),
            itemCount: 4,
            itemBuilder: (_, index) {
              var book = Book(
                  id: "b$index",
                  title:
                      "ZENONIA GUİDES 4 v1.1.6 + Mod (a lot of money) for Android",
                  authors: ["Hector Smith", "Author2"],
                  description:
                      "Now also available in German! The ultimate action RPG has returned, now in stunning HD! If the forces of evil shake the world, the heroes of the time have to leave the fate of the world again on the right track. Come together with Regret, Chael, ECNE, Lu, and many others, the greatest ZENONIA adventure yet! ───────────────────── The best looking ZENONIA® ALLERZEITEN Explore the world in HD, now with spectacular graphics and fantastic animations optimized for high quality displays. DYNAMIC AND FIGHT visceral and become a great fighter – unleash your combo hits and devastating skills with explosive graphics, incredible and enchanting animations. EQUIPPED YOU AND YOU INDIVIDUALLY FOR THE ADVENTURE Skille Skille and upgrade your warrior, rogue, hunter or druid with countless armor, weapons and items.",
                  thumbnailLink:
                      "http://books.google.com/books/content?id=XLVnCAAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
                  infoLink:
                      "https://play.google.com/store/books/details?id=aqpJDwAAQBAJ&rdid=book-aqpJDwAAQBAJ&rdot=1&source=gbs_api");

              return BookListItemWidget(book: book);
            }));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Books'),
      backgroundColor: Colors.deepPurpleAccent,
      actions: [
        searchBar.getSearchAction(context),
        IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(FavoritesRoute());
            }),
        IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }
}
