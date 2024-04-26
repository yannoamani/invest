import 'package:invest_mobile/model/package.dart';
import 'package:invest_mobile/model/user.dart';

class Achat {
  int id;
  Package pack;
  User person;
  DateTime dateValidite;
  bool validation;

  Achat(
      {required this.id,
      required this.pack,
      required this.person,
      required this.dateValidite,
      required this.validation});
}
