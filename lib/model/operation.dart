import 'package:invest_mobile/model/user.dart';

class Operation {
  int id;
  User person;
  double montant;
  String type;

  Operation(
      {required this.id,
      required this.person,
      required this.montant,
      required this.type});
}
