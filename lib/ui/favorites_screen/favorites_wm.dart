import 'package:books_app/data/book.dart';
import 'package:books_app/model/favorites/repository/favorites_repo.dart';
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

class FavoritesWm extends WidgetModel {
  FavoritesWm(WidgetModelDependencies baseDependencies, this.favoritesRepo)
      : super(baseDependencies);

  final IFavoritesRepository favoritesRepo;
  final favoritesState = EntityStreamedState<List<Book>>(EntityState.loading());

  @override
  void onLoad() {
    super.onLoad();
    _loadFavorites();
  }

  @override
  void onBind() {
    super.onBind();
  }

  Future _loadFavorites() async {
    favoritesState.loading();

    try {
      var books = await favoritesRepo.getBooks();
      favoritesState.content(books);
    } catch (e) {
      handleError(e);
      favoritesState.error(e);
    }
  }
}
