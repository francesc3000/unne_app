
abstract class HomeView{
  onLoggedInSuccess();
  onLoggedInNonSuccess();
}

abstract class EventoView{
}

abstract class DashboardView implements EventoAnimatedListView{

}

abstract class EventoAnimatedListView{
  addEvento2List(String eventoId, String name, String description, bool isFavorite);
  removeEventoFromList(String eventoId);
}