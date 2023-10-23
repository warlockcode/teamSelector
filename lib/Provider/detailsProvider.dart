import 'package:flutter/cupertino.dart';
import 'package:teamselector/model/Person.dart';

class DetailsProvider extends ChangeNotifier {
  late List<Person> _items =[] ;

  List<Person> get items =>_items;

  void addPerson(Person person) {

   _items.add(person);
    notifyListeners();
  }
  void removePerson(Person person) {
    _items.remove(person);
    notifyListeners();
  }
}