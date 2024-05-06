import 'package:invest_mobile/model/type_package.dart';

class Vente {
  int id;
  int nbrVente;
  double coutTotal;
  TypePackage typePack;

  Vente(
      {required this.id,
      required this.nbrVente,
      required this.coutTotal,
      required this.typePack});
}
