import 'package:invest_mobile/model/type_package.dart';
import 'package:invest_mobile/model/user.dart';

class Package {
  int id;
  double coutAquisition;
  double gain;
  int nbrProduit;
  double coutVente;
  int periode;
  User person;
  TypePackage typePack;
  bool publie;

  Package(
      {required this.id,
      required this.gain,
      required this.coutAquisition,
      required this.nbrProduit,
      required this.periode,
      required this.coutVente,
      required this.person,
      required this.publie,
      required this.typePack});
}
